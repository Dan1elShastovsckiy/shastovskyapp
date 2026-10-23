/*// lib/pages/pages_instruments/page_seo_forecast.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/components/share_buttons_block.dart';
import 'package:minimal/models/monthly_data.dart';
import 'package:minimal/pages/pages.dart';
import 'package:minimal/services/auth_service.dart';
import 'package:minimal/services/forecast_calculator_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:responsive_framework/responsive_framework.dart'
    hide MaxWidthBox;
import 'package:provider/provider.dart';
import 'package:csv/csv.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:universal_html/html.dart' as html;
import 'package:excel/excel.dart' as excel;
import 'package:flutter/services.dart' show rootBundle;
import 'package:minimal/components/forecast_explanation.dart';
import 'package:url_launcher/url_launcher.dart'; // Импортируем контент объяснения

class SeoForecastPage extends StatefulWidget {
  static const String name = 'useful/instruments/seo-forecast';
  const SeoForecastPage({super.key});

  @override
  State<SeoForecastPage> createState() => _SeoForecastPageState();
}

Map<String, dynamic> _runCalculation(SeoForecastCalculator calculator) {
  return calculator.runForecast();
}

class _SeoForecastPageState extends State<SeoForecastPage> {
  final List<MonthlyData> _historicalData = [];
  Map<ForecastTarget, List<ForecastResult>> _forecastResults = {};
  Map<int, double> _usedSeasonality = {};
  bool _isLoading = false;

  DateTime _startDate = DateTime(DateTime.now().year - 2, DateTime.now().month);
  DateTime _endDate = DateTime(DateTime.now().year, DateTime.now().month - 1);

  final List<TextEditingController> _seoGrowthControllers = [
    TextEditingController(text: "5")
  ];
  TrendType _selectedTrend = TrendType.linear;
  SeasonalitySource _seasonalitySource = SeasonalitySource.automatic;
  final List<ManualSeasonalityPoint> _manualSeasonalityData = [];

  ForecastTarget _forecastTarget = ForecastTarget.total;

  bool _showYandex = true;
  bool _showGoogle = true;
  bool _showTotal = true;
  bool _showHistory = true;
  bool _showBrand = false;
  bool _showNonBrand = false;

  @override
  void initState() {
    super.initState();
    _generateHistoricalRows();
  }

  void _generateHistoricalRows() {
    setState(() {
      _historicalData.clear();
      _manualSeasonalityData.clear();
      _forecastResults.clear();
      int months = (_endDate.year - _startDate.year) * 12 +
          _endDate.month -
          _startDate.month +
          1;
      if (months <= 0) return;

      for (int i = 0; i < months; i++) {
        final currentMonth = DateTime(_startDate.year, _startDate.month + i, 1);
        _historicalData.add(MonthlyData(month: currentMonth));
        _manualSeasonalityData.add(ManualSeasonalityPoint(month: currentMonth));
      }
    });
  }

  void _pasteFromSheet({required bool isForSeasonality}) {
    final pasteController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isForSeasonality
            ? "Вставка данных о спросе"
            : "Вставка данных о трафике"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isForSeasonality
                ? "Скопируйте столбец 'Число запросов' из Яндекс.Вебмастера и вставьте ниже."
                : "Скопируйте до 3 столбцов (Визиты Яндекс, Визиты Google, Бренд Яндекс) из Excel/Sheets и вставьте ниже."),
            const SizedBox(height: 16),
            TextField(
              controller: pasteController,
              maxLines: 10,
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Вставьте данные сюда...",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Отмена")),
          ElevatedButton(
            onPressed: () {
              final pastedText = pasteController.text;
              final lines = pastedText
                  .split('\n')
                  .where((line) => line.trim().isNotEmpty)
                  .toList();
              setState(() {
                if (isForSeasonality) {
                  for (int i = 0;
                      i < lines.length && i < _manualSeasonalityData.length;
                      i++) {
                    _manualSeasonalityData[i].queryCount = double.tryParse(
                            lines[i].replaceAll(RegExp(r'[\s\u00A0]'), '')) ??
                        0;
                  }
                } else {
                  for (int i = 0;
                      i < lines.length && i < _historicalData.length;
                      i++) {
                    final cells = lines[i].split('\t');
                    if (cells.isNotEmpty) {
                      _historicalData[i].yandexVisits = double.tryParse(
                              cells[0].replaceAll(RegExp(r'[\s\u00A0]'), '')) ??
                          0;
                    }
                    if (cells.length > 1) {
                      _historicalData[i].googleVisits = double.tryParse(
                              cells[1].replaceAll(RegExp(r'[\s\u00A0]'), '')) ??
                          0;
                    }
                    if (cells.length > 2) {
                      _historicalData[i].yandexBrandVisits = double.tryParse(
                              cells[2].replaceAll(RegExp(r'[\s\u00A0]'), '')) ??
                          0;
                    }
                  }
                }
              });
              Navigator.pop(context);
            },
            child: const Text("Применить"),
          ),
        ],
      ),
    );
  }

  void _addSeoGrowthField() {
    setState(() {
      _seoGrowthControllers.add(TextEditingController(text: "10"));
    });
  }

  void _removeSeoGrowthField(int index) {
    if (_seoGrowthControllers.length > 1) {
      setState(() {
        _seoGrowthControllers.removeAt(index).dispose();
      });
    }
  }

  void _runForecast() async {
    final filledData = _historicalData
        .where((d) => d.yandexVisits > 0 || d.googleVisits > 0)
        .toList();
    if (filledData.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Пожалуйста, введите данные хотя бы за 2 месяца."),
            backgroundColor: Colors.orange),
      );
      return;
    }

    if (_seasonalitySource == SeasonalitySource.manual &&
        _manualSeasonalityData.where((d) => d.queryCount > 0).isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("При ручном режиме нужно ввести данные о сезонности."),
            backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 50));

    final settings = ForecastSettings(
      trendType: _selectedTrend,
      seasonalitySource: _seasonalitySource,
      seoGrowthFactors: _seoGrowthControllers
          .map((c) =>
              1 + (double.tryParse(c.text.replaceAll(',', '.')) ?? 0) / 100)
          .toList(),
    );
    final calculator = SeoForecastCalculator(
      List.from(filledData),
      settings,
      manualSeasonalityData:
          _manualSeasonalityData.where((d) => d.queryCount > 0).toList(),
    );

    final results = await compute(_runCalculation, calculator);

    if (mounted) {
      setState(() {
        _forecastResults = {
          ForecastTarget.total: List<ForecastResult>.from(results['total']),
          ForecastTarget.yandex: List<ForecastResult>.from(results['yandex']),
          ForecastTarget.google: List<ForecastResult>.from(results['google']),
        };
        _usedSeasonality = Map<int, double>.from(results['seasonality']);
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _seoGrowthControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showInfoDialog(BuildContext context,
      {required String title, required String markdownContent}) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(title, style: headlineSecondaryTextStyle(context)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MarkdownBody(
                  data: markdownContent,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                    p: bodyTextStyle(context),
                    listBullet: bodyTextStyle(context),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Понятно"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _exportToPdf() async {
    final pdf = pw.Document();

    // ИСПРАВЛЕНИЕ: Используем правильный относительный путь к ассету
    final fontData =
        await rootBundle.load("assets/fonts/Montserrat-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);

    final resultsToExport = _forecastResults[
        _forecastTarget != ForecastTarget.combined
            ? _forecastTarget
            : ForecastTarget.total];
    if (resultsToExport == null || resultsToExport.isEmpty) return;

    final headers = [
      "Месяц",
      "Коэф. сез.",
      "Бренд",
      "Небренд (без SEO)",
      "Итого (без SEO)",
      "Прирост SEO",
      "Небренд",
      "Итого"
    ];

    final data = resultsToExport.map((result) {
      return [
        DateFormat('MMM yyyy', 'ru_RU').format(result.month),
        _usedSeasonality[result.month.month]?.toStringAsFixed(2) ?? '1.00',
        result.brandForecast.toStringAsFixed(0),
        result.nonBrandWithoutSeo.toStringAsFixed(0),
        result.totalWithoutSeo.toStringAsFixed(0),
        "+${result.nonBrandGrowth.toStringAsFixed(0)}",
        result.nonBrandForecast.toStringAsFixed(0),
        result.totalForecast.toStringAsFixed(0),
      ];
    }).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        header: (context) => pw.Header(
            level: 0,
            child: pw.Text("Прогноз SEO-трафика",
                style: pw.TextStyle(
                    font: ttf, fontSize: 24, fontWeight: pw.FontWeight.bold))),
        build: (context) => [
          pw.Table.fromTextArray(
            headerStyle:
                pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold),
            cellStyle: pw.TextStyle(font: ttf),
            headers: headers,
            data: data,
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  void _exportToCsv() {
    List<List<dynamic>> rows = [];

    final resultsToExport = _forecastResults[
        _forecastTarget != ForecastTarget.combined
            ? _forecastTarget
            : ForecastTarget.total];
    if (resultsToExport == null || resultsToExport.isEmpty) return;

    rows.add([
      "Месяц",
      "Коэф. сез.",
      "Бренд (Прогноз)",
      "Небренд (без SEO)",
      "Итого (без SEO)",
      "Прирост от SEO",
      "Небренд (Прогноз)",
      "Итоговый Прогноз"
    ]);

    for (var result in resultsToExport) {
      rows.add([
        DateFormat('MMM yyyy', 'ru_RU').format(result.month),
        _usedSeasonality[result.month.month]?.toStringAsFixed(2) ?? '1.00',
        result.brandForecast.toStringAsFixed(0),
        result.nonBrandWithoutSeo.toStringAsFixed(0),
        result.totalWithoutSeo.toStringAsFixed(0),
        "+${result.nonBrandGrowth.toStringAsFixed(0)}",
        result.nonBrandForecast.toStringAsFixed(0),
        result.totalForecast.toStringAsFixed(0),
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows, fieldDelimiter: ';');
    final bytes = utf8.encode(csv);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute("download", "seo_forecast.csv")
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  void _exportToXlsx() {
    var excelFile = excel.Excel.createExcel();
    excel.Sheet sheetObject = excelFile['Forecast'];

    final headers = [
      "Месяц",
      "Коэф. сез.",
      "Бренд (Прогноз)",
      "Небренд (без SEO)",
      "Итого (без SEO)",
      "Прирост от SEO",
      "Небренд (Прогноз)",
      "Итоговый Прогноз"
    ];
    sheetObject.appendRow(headers.map((h) => excel.TextCellValue(h)).toList());

    final resultsToExport = _forecastResults[
        _forecastTarget != ForecastTarget.combined
            ? _forecastTarget
            : ForecastTarget.total];
    if (resultsToExport == null || resultsToExport.isEmpty) return;

    for (var result in resultsToExport) {
      sheetObject.appendRow([
        excel.TextCellValue(
            DateFormat('MMM yyyy', 'ru_RU').format(result.month)),
        excel.TextCellValue(
            _usedSeasonality[result.month.month]?.toStringAsFixed(2) ?? '1.00'),
        excel.DoubleCellValue(result.brandForecast),
        excel.DoubleCellValue(result.nonBrandWithoutSeo),
        excel.DoubleCellValue(result.totalWithoutSeo),
        excel.DoubleCellValue(result.nonBrandGrowth),
        excel.DoubleCellValue(result.nonBrandForecast),
        excel.DoubleCellValue(result.totalForecast),
      ]);
    }

    excelFile.save(fileName: "seo_forecast.xlsx");
  }

  void _showExplanationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Как работает прогнозирование",
            style: headlineSecondaryTextStyle(context)),
        content: const SizedBox(
          width: 600, // Задаем ширину для диалогового окна
          child: SingleChildScrollView(child: ForecastExplanation()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Закрыть"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = Provider.of<AuthService>(context);
    if (!authService.isAuthenticated) {
      return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: MinimalMenuBar(),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: MaxWidthBox(
            maxWidth: 1000,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Прогноз SEO-трафика", style: headlineTextStyle(context)),
                const SizedBox(height: 16),
                Text(
                  "Автоматизируйте планирование KPI и прогнозируйте органический трафик на основе исторических данных, сезонности и планируемого SEO-роста.",
                  style: subtitleTextStyle(context),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // --- НОВЫЙ БЛОК С ИНТЕРАКТИВНОЙ КАРТИНКОЙ ---
                InkWell(
                  onTap: () {
                    // Функция для открытия картинки в диалоговом окне
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(
                              context), // Закрыть по тапу на картинку
                          child: Image.asset(
                              'assets/images/seo_forecast/forecast_example_promo.webp'),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 300, // Ограничиваем высоту картинки
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      // Белая рамка
                      border: Border.all(color: Colors.white, width: 2),
                      // Тень для объема
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      // Обрезаем углы изображения
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        'assets/images/seo_forecast/forecast_example_promo.webp',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                    "Пример сгенерированного прогноза (нажмите, чтобы увеличить)",
                    style: subtitleTextStyle(context)
                        .copyWith(fontSize: 14, fontStyle: FontStyle.italic)),
                const SizedBox(height: 32),

                // --- НОВЫЙ БЛОК С АНИМИРОВАННОЙ СТРЕЛКОЙ ---
                const AnimatedArrow(),
                const SizedBox(height: 16),

                ElevatedButton(
                  style: elevatedButtonStyle(context)?.copyWith(
                    padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16)),
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/${LoginPage.name}'),
                  child: const Text("Войти, чтобы попробовать"),
                ),
                const SizedBox(height: 32),
                const AnimatedArrow(),
                const SizedBox(height: 32),
                divider(context),
                const SizedBox(height: 40),
                const TextHeadlineSecondary(
                    text: "Как это работает и чем может быть полезно?"),
                const SizedBox(height: 20),
                const ForecastExplanation(),

                // <<< НАЧАЛО ВСТАВКИ >>>
                const SizedBox(height: 60),
                divider(context),
                const SizedBox(height: 40),

                // Теги, релевантные инструменту
                const Align(
                  alignment: Alignment.centerLeft,
                  child: TagWrapper(tags: [
                    Tag(tag: "SEO"),
                    Tag(tag: "Прогнозирование"),
                    Tag(tag: "KPI"),
                    Tag(tag: "Аналитика"),
                  ]),
                ),

                // Блок "Поделиться"
                const Align(
                  alignment: Alignment.centerLeft,
                  child: ShareButtonsBlock(
                    shareText:
                        "Посмотрите, какой удобный инструмент для прогнозирования SEO-трафика:",
                    shareSubject: "Инструмент: Прогноз SEO-трафика",
                  ),
                ),
                const SizedBox(height: 40),

                // Блок с соцсетями автора
                Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  width: double.infinity,
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(Icons.telegram,
                                color: theme.colorScheme.onSurface),
                            label: const Text('Telegram личный'),
                            style: elevatedButtonStyle(context),
                            onPressed: () => launchUrl(
                                Uri.parse('https://t.me/switchleveler')),
                          ),
                          ElevatedButton.icon(
                            icon: Icon(Icons.campaign,
                                color: theme.colorScheme.onSurface),
                            label: const Text('Telegram канал'),
                            style: elevatedButtonStyle(context),
                            onPressed: () => launchUrl(
                                Uri.parse('https://t.me/shastovscky')),
                          ),
                          ElevatedButton.icon(
                            icon: Icon(Icons.camera_alt,
                                color: theme.colorScheme.onSurface),
                            label: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Instagram'),
                                const SizedBox(height: 2),
                                Text(
                                  'Запрещенная в РФ организация',
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: theme.colorScheme.secondary),
                                ),
                              ],
                            ),
                            style: elevatedButtonStyle(context),
                            onPressed: () => launchUrl(Uri.parse(
                                'https://instagram.com/yellolwapple')),
                          ),
                          ElevatedButton.icon(
                            icon: Icon(Icons.work,
                                color: theme.colorScheme.onSurface),
                            label: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('LinkedIn'),
                                const SizedBox(height: 2),
                                Text(
                                  'Запрещенная в РФ организация',
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: theme.colorScheme.secondary),
                                ),
                              ],
                            ),
                            style: elevatedButtonStyle(context),
                            onPressed: () => launchUrl(Uri.parse(
                                'https://hh.ru/resume/b94af167ff049031c70039ed1f746c61797571')),
                          ),
                          ElevatedButton.icon(
                            icon: Icon(Icons.smart_display_outlined,
                                color: theme.colorScheme.onSurface),
                            label: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('YouTube'),
                                const SizedBox(height: 2),
                                Text(
                                  'Запрещенная в РФ организация',
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: theme.colorScheme.secondary),
                                ),
                              ],
                            ),
                            style: elevatedButtonStyle(context),
                            onPressed: () => launchUrl(
                                Uri.parse('https://www.youtube.com/@itsmyadv')),
                          ),
                          ElevatedButton.icon(
                            icon: Icon(Icons.article_outlined,
                                color: theme.colorScheme.onSurface),
                            label: const Text('VC.RU'),
                            style: elevatedButtonStyle(context),
                            onPressed: () =>
                                launchUrl(Uri.parse('https://vc.ru/id1145025')),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Секция автора
                ...authorSection(
                  context: context,
                  imageUrl: "assets/images/avatar_default.webp",
                  name: "Автор инструмента: Шастовский Даниил",
                  bio:
                      "SEO-специалист и Flutter-разработчик. Создаю полезные инструменты для себя и коллег, чтобы автоматизировать рутину.",
                ),
                const SizedBox(height: 40),

                // Хлебные крошки внизу
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Breadcrumbs(
                    items: [
                      BreadcrumbItem(text: "Главная", routeName: '/'),
                      BreadcrumbItem(text: "Полезное", routeName: '/useful'),
                      BreadcrumbItem(
                          text: "Инструменты SEO",
                          routeName: '/useful/instruments'),
                      BreadcrumbItem(text: "Прогноз SEO-трафика"),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Футер
                divider(context),
                const Footer(),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: MinimalMenuBar(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: MaxWidthBox(
          maxWidth: 1600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Прогноз SEO-трафика", style: headlineTextStyle(context)),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  icon: const Icon(Icons.help_outline, size: 18),
                  label: const Text("Как это работает?"),
                  onPressed: _showExplanationDialog,
                ),
              ),
              // <<< КОНЕЦ ВСТАВКИ >>>

              const SizedBox(height: 40),
              ResponsiveRowColumn(
                layout: ResponsiveBreakpoints.of(context).largerThan(TABLET)
                    ? ResponsiveRowColumnType.ROW
                    : ResponsiveRowColumnType.COLUMN,
                rowCrossAxisAlignment: CrossAxisAlignment.start,
                columnSpacing: 40,
                rowSpacing: 40,
                children: [
                  ResponsiveRowColumnItem(
                    rowFlex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextHeadlineSecondary(
                            text: "1. Исторические данные"),
                        const TextBody(
                            text:
                                "Введите данные по трафику за выбранный период."),
                        const SizedBox(height: 24),
                        _buildDateRangePicker(),
                        const SizedBox(height: 24),
                        _buildHistoricalDataTable(),
                      ],
                    ),
                  ),
                  ResponsiveRowColumnItem(
                    rowFlex: 1,
                    child: _buildSettingsPanel(),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.calculate_outlined),
                  label: const Text("Сгенерировать прогноз"),
                  style: elevatedButtonStyle(context)?.copyWith(
                      padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 48, vertical: 20)),
                      backgroundColor:
                          WidgetStateProperty.all(Colors.green.shade700)),
                  onPressed: _isLoading ? null : _runForecast,
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading) const Center(child: CircularProgressIndicator()),
              if (_forecastResults.isNotEmpty && !_isLoading) ...[
                const SizedBox(height: 40),
                divider(context),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const TextHeadlineSecondary(text: "3. Результаты прогноза"),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        ElevatedButton.icon(
                            onPressed: _exportToCsv,
                            icon: const Icon(Icons.table_chart_outlined),
                            label: const Text("CSV")),
                        ElevatedButton.icon(
                            onPressed: _exportToXlsx,
                            icon: const Icon(Icons.table_rows_outlined),
                            label: const Text("XLSX")),
                        ElevatedButton.icon(
                            onPressed: _exportToPdf,
                            icon: const Icon(Icons.picture_as_pdf_outlined),
                            label: const Text("PDF")),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 24),
                Text("График прогноза",
                    style: headlineSecondaryTextStyle(context)
                        .copyWith(fontSize: 20)),
                const SizedBox(height: 16),
                _buildChartControls(),
                const SizedBox(height: 16),
                _buildForecastChart(),
                const SizedBox(height: 24),
                _buildChartLegend(),
                const SizedBox(height: 40),
                Text("Таблица прогноза",
                    style: headlineSecondaryTextStyle(context)
                        .copyWith(fontSize: 20)),
                const SizedBox(height: 16),
                _buildForecastResultTable(),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateRangePicker() {
    return Wrap(
      spacing: 24,
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Период с: "),
            TextButton(
              child: Text(DateFormat('MMM yyyy', 'ru_RU').format(_startDate)),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime(2010),
                  lastDate: _endDate,
                  locale: const Locale('ru', 'RU'),
                );
                if (date != null) {
                  setState(() => _startDate = date);
                  _generateHistoricalRows();
                }
              },
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(" по: "),
            TextButton(
              child: Text(DateFormat('MMM yyyy', 'ru_RU').format(_endDate)),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _endDate,
                  firstDate: _startDate,
                  lastDate: DateTime.now(),
                  locale: const Locale('ru', 'RU'),
                );
                if (date != null) {
                  setState(() => _endDate = date);
                  _generateHistoricalRows();
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHistoricalDataTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: () => _pasteFromSheet(isForSeasonality: false),
          icon: const Icon(Icons.content_paste),
          label: const Text("Вставить данные трафика из таблицы"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text("Месяц")),
              DataColumn(label: Text("Визиты Яндекс"), numeric: true),
              DataColumn(label: Text("Визиты Google"), numeric: true),
              DataColumn(label: Text("Бренд Яндекс"), numeric: true),
            ],
            rows: _historicalData.map((data) {
              return DataRow(cells: [
                DataCell(
                    Text(DateFormat('MMM yyyy', 'ru_RU').format(data.month))),
                DataCell(_buildNumericCell(
                    data.yandexVisits, (val) => data.yandexVisits = val)),
                DataCell(_buildNumericCell(
                    data.googleVisits, (val) => data.googleVisits = val)),
                DataCell(_buildNumericCell(data.yandexBrandVisits,
                    (val) => data.yandexBrandVisits = val)),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildNumericCell(double initialValue, Function(double) onChanged) {
    return TextFormField(
      key: ValueKey(initialValue),
      initialValue: initialValue > 0 ? initialValue.toStringAsFixed(0) : '',
      keyboardType: TextInputType.number,
      textAlign: TextAlign.right,
      onChanged: (val) => onChanged(
          double.tryParse(val.replaceAll(RegExp(r'[\s\u00A0]'), '')) ?? 0),
      decoration: const InputDecoration(border: InputBorder.none),
    );
  }

  Widget _buildSettingsPanel() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextHeadlineSecondary(text: "2. Настройки прогноза"),
        const SizedBox(height: 24),
        const TextBody(text: "Цель прогноза:"),
        DropdownButton<ForecastTarget>(
          value: _forecastTarget,
          isExpanded: true,
          items: const [
            DropdownMenuItem(
                value: ForecastTarget.total,
                child: Text("Общий трафик (Яндекс + Google)")),
            DropdownMenuItem(
                value: ForecastTarget.yandex, child: Text("Только Яндекс")),
            DropdownMenuItem(
                value: ForecastTarget.google, child: Text("Только Google")),
            DropdownMenuItem(
                value: ForecastTarget.combined,
                child: Text("Совмещенный (Все на одном графике)")),
          ],
          onChanged: (val) {
            if (val != null) setState(() => _forecastTarget = val);
          },
        ),
        const SizedBox(height: 24),
        const TextBody(text: "Модель тренда:"),
        DropdownButton<TrendType>(
          value: _selectedTrend,
          isExpanded: true,
          items: const [
            DropdownMenuItem(
                value: TrendType.linear,
                child: Text("Линейный тренд (стабильный рост)")),
            DropdownMenuItem(
                value: TrendType.exponential,
                child: Text(
                    "Экспоненциальное сглаживание (адаптация к изменениям)")),
          ],
          onChanged: (val) {
            if (val != null) setState(() => _selectedTrend = val);
          },
        ),
        const SizedBox(height: 24),
        const TextBody(text: "Источник данных для сезонности:"),
        RadioListTile<SeasonalitySource>(
          contentPadding: EdgeInsets.zero,
          title: const Text("Рассчитать автоматически (по данным трафика)"),
          value: SeasonalitySource.automatic,
          groupValue: _seasonalitySource,
          onChanged: (v) {
            if (v != null) {
              setState(() => _seasonalitySource = v);
            }
          },
        ),
        RadioListTile<SeasonalitySource>(
          contentPadding: EdgeInsets.zero,
          title: const Text("Задать вручную (по данным Wordstat/Вебмастера)"),
          value: SeasonalitySource.manual,
          groupValue: _seasonalitySource,
          onChanged: (v) {
            if (v != null) {
              setState(() => _seasonalitySource = v);
            }
          },
        ),
        if (_seasonalitySource == SeasonalitySource.manual) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              const Text("Данные о спросе (Число запросов):"),
              IconButton(
                icon: Icon(Icons.help_outline,
                    color: theme.colorScheme.secondary),
                onPressed: () => _showInfoDialog(context,
                    title: "Где взять данные о спросе?",
                    markdownContent:
                        "1.  Возьмите 2-3 самых частотных небрендовых запроса вашего проекта.\n"
                        "2.  Перейдите в **Яндекс.Вебмастер** -> Поисковые запросы -> **История запросов**.\n"
                        "3.  Введите эти запросы.\n"
                        "4.  Установите тот же период, что и для исторических данных трафика.\n"
                        "5.  Скопируйте данные из столбца **'Число запросов'** и вставьте в таблицу ниже с помощью кнопки 'Вставить'."),
              )
            ],
          ),
          const SizedBox(height: 8),
          _buildManualSeasonalityTable(),
        ],
        const SizedBox(height: 24),
        const TextBody(text: "Ежемесячный прирост от SEO (%):"),
        const SizedBox(height: 8),
        Text("Задайте планируемый рост трафика от SEO по месяцам.",
            style: subtitleTextStyle(context)),
        const SizedBox(height: 16),
        ..._seoGrowthControllers.asMap().entries.map((entry) {
          int index = entry.key;
          TextEditingController controller = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: "Месяц ${index + 1}",
                      suffixText: "%",
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                if (_seoGrowthControllers.length > 1)
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline,
                        color: Colors.red),
                    onPressed: () => _removeSeoGrowthField(index),
                  )
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
        // Показываем кнопку "Добавить", только если полей меньше 12
        if (_seoGrowthControllers.length < 12)
          TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Добавить следующий месяц"),
            onPressed: _addSeoGrowthField,
          ),
      ],
    );
  }

  Widget _buildManualSeasonalityTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: () => _pasteFromSheet(isForSeasonality: true),
          icon: const Icon(Icons.content_paste),
          label: const Text("Вставить данные о спросе"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text("Месяц")),
              DataColumn(label: Text("Число запросов"), numeric: true),
            ],
            rows: _manualSeasonalityData.map((data) {
              return DataRow(cells: [
                DataCell(
                    Text(DateFormat('MMM yyyy', 'ru_RU').format(data.month))),
                DataCell(_buildNumericCell(
                    data.queryCount, (val) => data.queryCount = val)),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildChartControls() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        FilterChip(
            label: const Text("История"),
            selected: _showHistory,
            onSelected: (val) => setState(() => _showHistory = val),
            showCheckmark: false),
        if (_forecastTarget == ForecastTarget.combined) ...[
          FilterChip(
              label: const Text("Общий Прогноз"),
              selected: _showTotal,
              onSelected: (val) => setState(() => _showTotal = val),
              showCheckmark: false),
          FilterChip(
              label: const Text("Прогноз Яндекс"),
              selected: _showYandex,
              onSelected: (val) => setState(() => _showYandex = val),
              showCheckmark: false),
          FilterChip(
              label: const Text("Прогноз Google"),
              selected: _showGoogle,
              onSelected: (val) => setState(() => _showGoogle = val),
              showCheckmark: false),
        ],
        FilterChip(
            label: const Text("Бренд"),
            selected: _showBrand,
            onSelected: (val) => setState(() => _showBrand = val),
            showCheckmark: false),
        FilterChip(
            label: const Text("Небренд"),
            selected: _showNonBrand,
            onSelected: (val) => setState(() => _showNonBrand = val),
            showCheckmark: false),
      ],
    );
  }

  Widget _buildForecastChart() {
    final theme = Theme.of(context);
    final filledHistorical = _historicalData
        .where((d) => d.yandexVisits > 0 || d.googleVisits > 0)
        .toList();
    if (_forecastResults.isEmpty && filledHistorical.isEmpty) {
      return const SizedBox(
          height: 400,
          child: Center(child: Text("Введите данные для построения графика")));
    }

    return SizedBox(
      height: 400,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 50)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: _bottomTitleWidgets,
                    interval: _getChartInterval())),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
              show: true, border: Border.all(color: theme.dividerColor)),
          lineBarsData: _getChartLines(),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              //tooltipBgColor: theme.cardColor.withOpacity(0.9),
              getTooltipItems: (touchedSpots) {
                final spotIndex = touchedSpots.first.x.toInt();
                final allMonths = [
                  ..._historicalData.map((d) => d.month),
                  ...(_forecastResults[ForecastTarget.total] ?? [])
                      .map((r) => r.month)
                ];

                if (spotIndex >= allMonths.length) {
                  return [];
                }
                final month = allMonths[spotIndex];

                return touchedSpots.map((spot) {
                  final lineName = _getLineNameByColor(
                      spot.bar.color ?? Colors.transparent, theme);
                  return LineTooltipItem(
                    '$lineName\n${spot.y.toStringAsFixed(0)} визитов',
                    TextStyle(
                        color: spot.bar.color ?? theme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                    children: [
                      TextSpan(
                        text:
                            '\n${DateFormat('MMM yyyy', 'ru_RU').format(month)}',
                        style: TextStyle(
                            fontSize: 10,
                            color:
                                theme.colorScheme.onSurface.withOpacity(0.7)),
                      )
                    ],
                    textAlign: TextAlign.left,
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  List<LineChartBarData> _getChartLines() {
    final theme = Theme.of(context);
    List<LineChartBarData> lines = [];
    final historicalCount = _historicalData.length;
    if (historicalCount == 0) return [];

    final yandexHistory = _historicalData.map((d) => d.yandexVisits).toList();
    final googleHistory = _historicalData.map((d) => d.googleVisits).toList();
    final totalHistory =
        _historicalData.map((d) => d.yandexVisits + d.googleVisits).toList();
    final brandHistory = _historicalData.map((d) => d.brandTraffic).toList();
    final nonBrandHistory =
        _historicalData.map((d) => d.nonBrandTraffic).toList();

    FlSpot getConnectingSpot(List<double> history) {
      if (history.isEmpty) return const FlSpot(0, 0);
      return FlSpot((historicalCount - 1).toDouble(), history.last);
    }

    if (_showHistory) {
      if (_forecastTarget == ForecastTarget.combined) {
        if (_showYandex) {
          lines.add(_buildLineBarData(
              yandexHistory
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              Colors.red.withOpacity(0.5),
              isDashed: true));
        }
        if (_showGoogle) {
          lines.add(_buildLineBarData(
              googleHistory
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              Colors.green.withOpacity(0.5),
              isDashed: true));
        }
      }

      if (_showTotal) {
        final data = (_forecastTarget == ForecastTarget.yandex)
            ? yandexHistory
            : (_forecastTarget == ForecastTarget.google)
                ? googleHistory
                : totalHistory;
        lines.add(_buildLineBarData(
            data
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList(),
            Colors.grey,
            isDashed: true));
      }

      if (_showBrand)
        lines.add(_buildLineBarData(
            brandHistory
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList(),
            Colors.orange.withOpacity(0.5),
            isDashed: true));
      if (_showNonBrand)
        lines.add(_buildLineBarData(
            nonBrandHistory
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList(),
            Colors.purple.withOpacity(0.5),
            isDashed: true));
    }

    if (_forecastResults.isNotEmpty) {
      if (_forecastTarget == ForecastTarget.combined) {
        if (_showYandex &&
            _forecastResults.containsKey(ForecastTarget.yandex)) {
          var spots = _forecastResults[ForecastTarget.yandex]!
              .asMap()
              .entries
              .map((e) => FlSpot(
                  (e.key + historicalCount).toDouble(), e.value.totalForecast))
              .toList();
          if (_showHistory && yandexHistory.isNotEmpty)
            spots.insert(0, getConnectingSpot(yandexHistory));
          lines.add(_buildLineBarData(spots, Colors.red, barWidth: 2));
        }
        if (_showGoogle &&
            _forecastResults.containsKey(ForecastTarget.google)) {
          var spots = _forecastResults[ForecastTarget.google]!
              .asMap()
              .entries
              .map((e) => FlSpot(
                  (e.key + historicalCount).toDouble(), e.value.totalForecast))
              .toList();
          if (_showHistory && googleHistory.isNotEmpty)
            spots.insert(0, getConnectingSpot(googleHistory));
          lines.add(_buildLineBarData(spots, Colors.green, barWidth: 2));
        }
        if (_showTotal && _forecastResults.containsKey(ForecastTarget.total)) {
          var spots = _forecastResults[ForecastTarget.total]!
              .asMap()
              .entries
              .map((e) => FlSpot(
                  (e.key + historicalCount).toDouble(), e.value.totalForecast))
              .toList();
          if (_showHistory && totalHistory.isNotEmpty)
            spots.insert(0, getConnectingSpot(totalHistory));
          lines.add(_buildLineBarData(spots, theme.primaryColor, barWidth: 4));
        }
      } else if (_forecastResults.containsKey(_forecastTarget)) {
        final results = _forecastResults[_forecastTarget]!;
        final history = _forecastTarget == ForecastTarget.yandex
            ? yandexHistory
            : (_forecastTarget == ForecastTarget.google
                ? googleHistory
                : totalHistory);

        var pessimisticSpots = results
            .asMap()
            .entries
            .map((e) => FlSpot((e.key + historicalCount).toDouble(),
                e.value.pessimisticForecast))
            .toList();
        var optimisticSpots = results
            .asMap()
            .entries
            .map((e) => FlSpot((e.key + historicalCount).toDouble(),
                e.value.optimisticForecast))
            .toList();
        var realisticSpots = results
            .asMap()
            .entries
            .map((e) => FlSpot(
                (e.key + historicalCount).toDouble(), e.value.totalForecast))
            .toList();

        if (_showHistory && history.isNotEmpty) {
          final connector = getConnectingSpot(history);
          pessimisticSpots.insert(0, connector);
          optimisticSpots.insert(0, connector);
          realisticSpots.insert(0, connector);
        }
        lines.add(_buildLineBarData(
            pessimisticSpots, Colors.red.withOpacity(0.7),
            isDashed: true));
        lines.add(_buildLineBarData(
            optimisticSpots, Colors.green.withOpacity(0.7),
            isDashed: true));
        lines.add(
            _buildLineBarData(realisticSpots, theme.primaryColor, barWidth: 4));
      }

      if (_showBrand && _forecastResults.containsKey(ForecastTarget.total)) {
        var spots = _forecastResults[ForecastTarget.total]!
            .asMap()
            .entries
            .map((e) => FlSpot(
                (e.key + historicalCount).toDouble(), e.value.brandForecast))
            .toList();
        if (_showHistory && brandHistory.isNotEmpty)
          spots.insert(0, getConnectingSpot(brandHistory));
        lines.add(_buildLineBarData(spots, Colors.orange, barWidth: 2));
      }
      if (_showNonBrand && _forecastResults.containsKey(ForecastTarget.total)) {
        var spots = _forecastResults[ForecastTarget.total]!
            .asMap()
            .entries
            .map((e) => FlSpot(
                (e.key + historicalCount).toDouble(), e.value.nonBrandForecast))
            .toList();
        if (_showHistory && nonBrandHistory.isNotEmpty)
          spots.insert(0, getConnectingSpot(nonBrandHistory));
        lines.add(_buildLineBarData(spots, Colors.purple, barWidth: 2));
      }
    }

    return lines;
  }

  String _getLineNameByColor(Color color, ThemeData theme) {
    if (color == theme.primaryColor)
      return _forecastTarget == ForecastTarget.combined
          ? 'Общий'
          : 'Реалистичный';
    if (color == Colors.grey) return 'История (Общая)';
    if (color == Colors.red) return 'Яндекс';
    if (color == Colors.green) return 'Google';
    if (color == Colors.red.withOpacity(0.5)) return 'История Яндекс';
    if (color == Colors.green.withOpacity(0.5)) return 'История Google';
    if (color == Colors.red.withOpacity(0.7)) return 'Пессимистичный';
    if (color == Colors.green.withOpacity(0.7)) return 'Оптимистичный';
    if (color == Colors.orange) return 'Бренд';
    if (color == Colors.purple) return 'Небренд';
    if (color == Colors.orange.withOpacity(0.5)) return 'История Бренд';
    if (color == Colors.purple.withOpacity(0.5)) return 'История Небренд';
    return '';
  }

  double _getChartInterval() {
    final totalMonths = _historicalData.length +
        (_forecastResults.values.firstOrNull?.length ?? 0);
    if (totalMonths <= 18) return 1;
    if (totalMonths <= 36) return 3;
    return 6;
  }

  LineChartBarData _buildLineBarData(List<FlSpot> spots, Color color,
      {double barWidth = 2, bool isDashed = false}) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: barWidth,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      dashArray: isDashed ? [5, 5] : null,
    );
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    final allMonths = [
      ..._historicalData.map((d) => d.month),
      ...(_forecastResults[ForecastTarget.total] ?? []).map((r) => r.month)
    ];
    if (value.toInt() >= allMonths.length || value.toInt() < 0)
      return const SizedBox();

    final month = allMonths[value.toInt()];

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: Text(DateFormat('MMM yy', 'ru_RU').format(month),
          style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildChartLegend() {
    final theme = Theme.of(context);

    List<Widget> legends = [];

    if (_showHistory) {
      if (_forecastTarget == ForecastTarget.combined) {
        if (_showYandex)
          legends.add(_buildLegendItem(Colors.red.withOpacity(0.5),
              "История Яндекс", "Исторические данные трафика Яндекс",
              isDashed: true));
        if (_showGoogle)
          legends.add(_buildLegendItem(Colors.green.withOpacity(0.5),
              "История Google", "Исторические данные трафика Google",
              isDashed: true));
      } else {
        legends.add(_buildLegendItem(
            Colors.grey, "История", "Исторические данные трафика",
            isDashed: true));
      }
    }

    if (_forecastTarget == ForecastTarget.combined) {
      if (_showTotal)
        legends.add(_buildLegendItem(theme.primaryColor, "Общий прогноз",
            "Прогноз суммарного трафика (Яндекс + Google)",
            isBold: true));
      if (_showYandex)
        legends.add(_buildLegendItem(
            Colors.red, "Прогноз Яндекс", "Прогноз трафика только для Яндекс"));
      if (_showGoogle)
        legends.add(_buildLegendItem(Colors.green, "Прогноз Google",
            "Прогноз трафика только для Google"));
    } else {
      legends.add(_buildLegendItem(
          theme.primaryColor, "Реалистичный", "Наиболее вероятный прогноз",
          isBold: true));
      legends.add(_buildLegendItem(
          Colors.green.withOpacity(0.7),
          "Оптимистичный",
          "Прогноз с учетом максимального положительного отклонения",
          isDashed: true));
      legends.add(_buildLegendItem(
          Colors.red.withOpacity(0.7),
          "Пессимистичный",
          "Прогноз с учетом максимального отрицательного отклонения",
          isDashed: true));
    }

    if (_showBrand)
      legends.add(_buildLegendItem(
          Colors.orange, "Бренд", "Прогноз брендового трафика"));
    if (_showNonBrand)
      legends.add(_buildLegendItem(
          Colors.purple, "Небренд", "Прогноз небрендового трафика"));

    return Wrap(
      spacing: 24,
      runSpacing: 8,
      children: legends,
    );
  }

  Widget _buildLegendItem(Color color, String text, String tooltip,
      {bool isBold = false, bool isDashed = false}) {
    return Tooltip(
      message: tooltip,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: isBold ? 4 : 2,
            color: isDashed ? Colors.transparent : color,
            child: isDashed
                ? CustomPaint(painter: _DashedLinePainter(color))
                : null,
          ),
          const SizedBox(width: 8),
          Text(text,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildForecastResultTable() {
    final resultsToDisplay = _forecastResults[
        _forecastTarget != ForecastTarget.combined
            ? _forecastTarget
            : ForecastTarget.total];

    if (resultsToDisplay == null || resultsToDisplay.isEmpty)
      return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final table = _buildDataTable(resultsToDisplay);
        if (constraints.maxWidth < 1100) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: table,
          );
        } else {
          return table;
        }
      },
    );
  }

  DataTable _buildDataTable(List<ForecastResult> results) {
    final numberFormat = NumberFormat("#,##0", "ru_RU");
    return DataTable(
      columnSpacing: 20,
      columns: const [
        DataColumn(label: Text("Месяц")),
        DataColumn(label: Text("Коэф. сез."), numeric: true),
        DataColumn(label: Text("Бренд"), numeric: true),
        DataColumn(label: Text("Небренд\n(без SEO)"), numeric: true),
        DataColumn(label: Text("Итого\n(без SEO)"), numeric: true),
        DataColumn(label: Text("Прирост\nот SEO"), numeric: true),
        DataColumn(label: Text("Небренд\n(Прогноз)"), numeric: true),
        DataColumn(label: Text("Итого\nПрогноз"), numeric: true),
      ],
      rows: results.map((result) {
        return DataRow(cells: [
          DataCell(Text(DateFormat('MMM yyyy', 'ru_RU').format(result.month))),
          DataCell(Text(
              _usedSeasonality[result.month.month]?.toStringAsFixed(2) ??
                  '1.00')),
          DataCell(Text(numberFormat.format(result.brandForecast))),
          DataCell(Text(numberFormat.format(result.nonBrandWithoutSeo))),
          DataCell(Text(numberFormat.format(result.totalWithoutSeo))),
          DataCell(Text("+${numberFormat.format(result.nonBrandGrowth)}",
              style: const TextStyle(color: Colors.green))),
          DataCell(Text(numberFormat.format(result.nonBrandForecast))),
          DataCell(Text(numberFormat.format(result.totalForecast),
              style: const TextStyle(fontWeight: FontWeight.bold))),
        ]);
      }).toList(),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  _DashedLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;
    const double dashWidth = 5;
    const double dashSpace = 3;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, size.height / 2),
          Offset(startX + dashWidth, size.height / 2), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
*/