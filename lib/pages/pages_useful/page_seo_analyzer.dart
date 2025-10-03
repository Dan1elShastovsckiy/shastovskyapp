// /lib/pages/pages_useful/page_seo_analyzer.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart'
    hide MaxWidthBox;
import 'package:minimal/utils/meta_tag_service.dart';
import 'package:minimal/pages/pages.dart';
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

// <<< ИСПРАВЛЕНИЕ: ВСЕ МОДЕЛИ ВЫНЕСЕНЫ НА ВЕРХНИЙ УРОВЕНЬ ФАЙЛА >>>

class KeywordRequirement {
  final String phrase;
  final int min;
  final int max;
  KeywordRequirement(this.phrase, this.min, this.max);
}

class GeneralRequirementResult {
  final String name;
  final String requirement;
  final String actual;
  final bool isSuccess;
  GeneralRequirementResult(
      this.name, this.requirement, this.actual, this.isSuccess);
}

class TzData {
  String volume;
  String metaTitle;
  String metaDescription;
  String structure;
  String exactKeywords;
  String dilutedKeywords;
  String thematicWords;
  String generalRequirements;

  TzData({
    required this.volume,
    required this.metaTitle,
    required this.metaDescription,
    required this.structure,
    required this.exactKeywords,
    required this.dilutedKeywords,
    required this.thematicWords,
    required this.generalRequirements,
  });
}

class AnalysisResult {
  final List<GeneralRequirementResult> generalResults;
  final String volumeResult;
  final String titleResult;
  final String descriptionResult;
  final String structureResult;
  final AnalysisCategoryResult exactInclusion;
  final AnalysisCategoryResult dilutedInclusion;
  final AnalysisCategoryResult thematicWords;
  final List<TextSpan> highlightedText;

  AnalysisResult({
    required this.generalResults,
    required this.volumeResult,
    required this.titleResult,
    required this.descriptionResult,
    required this.structureResult,
    required this.exactInclusion,
    required this.dilutedInclusion,
    required this.thematicWords,
    required this.highlightedText,
  });
}

class AnalysisCategoryResult {
  final List<MapEntry<KeywordRequirement, int>> results;
  int notFound = 0, moreThanNeeded = 0, lessThanNeeded = 0, perfectMatch = 0;
  AnalysisCategoryResult(this.results) {
    for (var entry in results) {
      final req = entry.key;
      final count = entry.value;
      if (count == 0)
        notFound++;
      else if (count < req.min)
        lessThanNeeded++;
      else if (count > req.max)
        moreThanNeeded++;
      else
        perfectMatch++;
    }
  }
}

class TextTzPair {
  final TextEditingController textController = TextEditingController();
  final TextEditingController tzController = TextEditingController();

  // <<< ДОБАВЛЯЕМ КОНТРОЛЛЕРЫ ДЛЯ РЕДАКТИРУЕМЫХ ПОЛЕЙ СЮДА >>>
  final TextEditingController volumeController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController structureController = TextEditingController();
  final TextEditingController exactKeywordsController = TextEditingController();
  final TextEditingController dilutedKeywordsController =
      TextEditingController();
  final TextEditingController thematicWordsController = TextEditingController();

  final GlobalKey key = GlobalKey();
  TzData? parsedTz;
  AnalysisResult? analysisResult;
}

class SeoAnalyzerPage extends StatefulWidget {
  static const String name = 'useful/instruments/seo-analyzer';
  const SeoAnalyzerPage({super.key});

  @override
  State<SeoAnalyzerPage> createState() => _SeoAnalyzerPageState();
}

enum SearchMode {
  overlapping, // Пересечение
  singlePass, // Разовые
  uniquePass, // Уникальные
}

class _SeoAnalyzerPageState extends State<SeoAnalyzerPage> {
  List<TextTzPair> _pairs = [TextTzPair()];
  bool _isLoading = false;
  SearchMode _selectedMode =
      SearchMode.overlapping; // По умолчанию выбран режим "Пересечение"

  // В начале класса _SeoAnalyzerPageState
  static const List<String> _allKnownMarkers = [
    'Объем текста', 'Объем',
    'Title:', 'Title', 'Метатег Title', // Добавили Title с двоеточием
    'Description:', 'Description',
    'Метатег Description', // Добавили Description с двоеточием
    'H1:', 'H1', // Добавили H1 с двоеточием
    'Мета-теги', // Просто для обозначения блока
    'Структура текста', 'Примерная структура статьи', // Более точные заголовки
    'Ключевые фразы', 'Ключи, которые нужно использовать в тексте', 'Ключи',
    'Слова из подсветки в выдаче', 'Разбавленное вхождение',
    'Тематические слова использовать в любой форме',
    'Тематикозадающие слова / LSI', 'LSI', 'Тематические слова',
    'Общие требования к тексту',
    'Тема/H1', 'Страница URL',
    'Частые вопросы (FAQ)',
    'Перелинковка', 'Примеры конкурентов',
    'Примечание' // Добавили для лучшего разделения
  ];

  @override
  void initState() {
    super.initState();
    MetaTagService().updateAllTags(
      title: "SEO Анализатор текста | Инструменты Даниила Шастовского",
      description:
          "Бесплатный онлайн-инструмент для проверки соответствия текста SEO-ТЗ. Анализ ключевых слов, LSI, объема и других параметров.",
    );
  }

  void _showHelpDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text("Как пользоваться анализатором",
              style: headlineSecondaryTextStyle(context)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Этот инструмент создан для автоматизации проверки текстов на соответствие SEO-ТЗ. Процесс состоит из двух простых этапов:",
                  style: bodyTextStyle(context),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Text("Этап 1: Парсинг Технического Задания",
                    style: bodyTextStyle(context)
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                MarkdownBody(
                  data: "1.  **Вставьте текст статьи** в левое поле.\n"
                      "2.  **Вставьте текст вашего ТЗ** в правое поле.\n"
                      "3.  Нажмите кнопку **«Распарсить ТЗ»**. Инструмент автоматически попытается найти и извлечь основные требования: объем, мета-теги, структуру и списки ключевых слов.",
                  styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                      p: bodyTextStyle(context),
                      listBullet: bodyTextStyle(context)),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Text("Этап 2: Проверка и Финальный Анализ",
                    style: bodyTextStyle(context)
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                MarkdownBody(
                  data:
                      "1.  После парсинга ниже появятся **редактируемые поля** с извлеченными данными.\n"
                      "2.  **Проверьте их!** Если парсер ошибся или не нашел какую-то секцию (например, из-за нестандартного заголовка в ТЗ), вы можете **вручную скорректировать** данные прямо в этих полях.\n"
                      "3.  Когда все данные верны, нажмите **«Запустить финальный анализ»**.\n"
                      "4.  Инструмент проведет полную проверку текста на соответствие скорректированным требованиям и выведет подробный отчет.",
                  styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                      p: bodyTextStyle(context),
                      listBullet: bodyTextStyle(context)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Все понятно!"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    for (var pair in _pairs) {
      pair.textController.dispose();
      pair.tzController.dispose();
    }
    super.dispose();
  }

  void _addPair() {
    if (_pairs.length < 5) {
      setState(() {
        _pairs.add(TextTzPair());
      });
    }
  }

  void _removePair(int index) {
    if (_pairs.length > 1) {
      setState(() {
        _pairs.removeAt(index);
      });
    }
  }

// Метод для показа всплывающего окна с описанием
  void _showModeHelpDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: headlineSecondaryTextStyle(context)),
        content: Text(content, style: bodyTextStyle(context)),
        actions: [
          TextButton(
            child: const Text("Понятно"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

// Метод для создания виджета с переключателями
  Widget _buildSearchModeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Выберите режим анализа вхождений:",
            style: headlineSecondaryTextStyle(context),
          ),
          const SizedBox(height: 8),
          // Опция "Пересечение вхождений"
          RadioListTile<SearchMode>(
            title: Row(
              children: [
                const Text("Пересечение вхождений (стандартный)"),
                IconButton(
                  icon: const Icon(Icons.help_outline, size: 18),
                  onPressed: () => _showModeHelpDialog(
                    "Пересечение вхождений",
                    "Самый простой режим. Каждая ключевая фраза ищется по всему тексту независимо от других. Если фраза 'купить автомобиль' найдена, то при поиске слова 'автомобиль' оно также будет найдено внутри этой фразы. Этот режим может завышать количество коротких ключей.",
                  ),
                )
              ],
            ),
            value: SearchMode.overlapping,
            groupValue: _selectedMode,
            onChanged: (SearchMode? value) {
              if (value != null) setState(() => _selectedMode = value);
            },
          ),
          // Опция "Разовые вхождения"
          RadioListTile<SearchMode>(
            title: Row(
              children: [
                const Text("Разовые вхождения (рекомендуемый)"),
                IconButton(
                  icon: const Icon(Icons.help_outline, size: 18),
                  onPressed: () => _showModeHelpDialog(
                    "Разовые вхождения",
                    "Более точный SEO-алгоритм. Сначала ищутся самые длинные фразы. Если фраза 'купить автомобиль' найдена, то эта часть текста 'блокируется', и более короткие ключи ('автомобиль', 'купить') внутри нее уже не ищутся. Блокировка работает только в рамках одного типа ключей (например, 'Точных').",
                  ),
                ),
              ],
            ),
            value: SearchMode.singlePass,
            groupValue: _selectedMode,
            onChanged: (SearchMode? value) {
              if (value != null) setState(() => _selectedMode = value);
            },
          ),
          // Опция "Уникальные вхождения"
          RadioListTile<SearchMode>(
            title: Row(
              children: [
                const Text("Уникальные вхождения (строгий)"),
                IconButton(
                  icon: const Icon(Icons.help_outline, size: 18),
                  onPressed: () => _showModeHelpDialog(
                    "Уникальные вхождения",
                    "Самый строгий режим. Если любая фраза (например, точное вхождение 'купить автомобиль') найдена, то эта часть текста блокируется для поиска ВООБЩЕ ВСЕХ ДРУГИХ ключей (включая LSI и слова из подсветки). Полезно для избегания переспама.",
                  ),
                ),
              ],
            ),
            value: SearchMode.uniquePass,
            groupValue: _selectedMode,
            onChanged: (SearchMode? value) {
              if (value != null) setState(() => _selectedMode = value);
            },
          ),
        ],
      ),
    );
  }

  void _parseTzForPair(int index) {
    final pair = _pairs[index];
    final String tz = pair.tzController.text;
    if (tz.isEmpty || tz.length > 35000 || tz.contains('<script')) {
      _showError(
          "Поле ТЗ №${index + 1} пустое, превышает 35000 символов или содержит <script>.");
      return;
    }

    final parsedData = TzData(
      volume: _parseSection(tz, ['Объем текста', 'Объем']) ?? "Не найдено",
      // Ищем точные заголовки Title: и Description:
      metaTitle: _parseSection(tz, ['Title:', 'Title']) ?? "Не найдено",
      metaDescription:
          _parseSection(tz, ['Description:', 'Description']) ?? "Не найдено",
      // Ищем именно "Структура текста", чтобы не спутать с упоминанием в "Общих требованиях"
      structure: _parseSection(
              tz, ['Структура текста', 'Примерная структура статьи']) ??
          "Не найдено",

      // Извлекаем "сырой" текст ключей
      exactKeywords: _parseSection(tz, [
            'Ключевые фразы',
            'Ключи, которые нужно использовать в тексте',
            'Ключи'
          ]) ??
          "Не найдено",

      dilutedKeywords: _parseSection(
              tz, ['Слова из подсветки в выдаче', 'Разбавленное вхождение']) ??
          "Не найдено",
      thematicWords: _parseSection(tz, [
            'Тематические слова использовать в любой форме',
            'Тематикозадающие слова / LSI',
            'LSI',
            'Тематические слова'
          ]) ??
          "Не найдено",
      generalRequirements:
          _parseSection(tz, ['Общие требования к тексту']) ?? "Не найдено",
    );

    pair.volumeController.text = parsedData.volume;
    pair.titleController.text = parsedData.metaTitle;
    pair.descriptionController.text = parsedData.metaDescription;
    pair.structureController.text = parsedData.structure;

    // <<< ФОРМАТИРУЕМ КЛЮЧИ ПЕРЕД ВСТАВКОЙ В ПОЛЕ >>>
    pair.exactKeywordsController.text =
        _formatKeywordsForField(parsedData.exactKeywords);

    // Остальные списки оставляем как есть (они очищаются в _parseSection)
    pair.dilutedKeywordsController.text = parsedData.dilutedKeywords;
    pair.thematicWordsController.text = parsedData.thematicWords;

    setState(() {
      pair.parsedTz = parsedData;
      pair.analysisResult = null;
    });
  }

  Future<void> _runGlobalAnalysis() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 50));

    for (var pair in _pairs) {
      if (pair.textController.text.isEmpty) {
        continue;
      }
      final text = pair.textController.text;

      // 1. Сбор данных из контроллеров (остается как было)
      final tzData = TzData(
        volume: pair.volumeController.text,
        metaTitle: pair.titleController.text,
        metaDescription: pair.descriptionController.text,
        structure: pair.structureController.text,
        exactKeywords: pair.exactKeywordsController.text,
        dilutedKeywords: pair.dilutedKeywordsController.text,
        thematicWords: pair.thematicWordsController.text,
        generalRequirements: _parseSection(
                pair.tzController.text, ['Общие требования к тексту']) ??
            "Не найдено",
      );

      // 2. Общий анализ (остается как было)
      final generalResults =
          _analyzeGeneralRequirements(text, tzData.generalRequirements);
      final volumeResult = _analyzeVolume(text, tzData.volume);
      final titleResult = _analyzeMetaTag(text, tzData.metaTitle, "Title");
      final descriptionResult =
          _analyzeMetaTag(text, tzData.metaDescription, "Description");
      final structureResult = _analyzeStructure(text, tzData.structure);

      // 3. Парсинг ключевых слов (остается как было)
      final exactReqs = _parseKeywordsFromText(tzData.exactKeywords);
      final dilutedReqs = _parseKeywordsFromText(tzData.dilutedKeywords);
      final thematicReqs = _parseKeywordsFromText(tzData.thematicWords);

      // 4. НОВАЯ ЛОГИКА: Создание списка "занятых" диапазонов и вызов анализа
      // Создаем ОДИН список для режима "Уникальные", который будет передаваться во все вызовы
      List<List<int>> globalConsumedRanges = [];

      // Вызываем анализ с передачей выбранного режима (_selectedMode) и списка диапазонов
      final exactResult = _analyzeKeywords(
          text, exactReqs, 'exact', _selectedMode, globalConsumedRanges);
      final dilutedResult = _analyzeKeywords(
          text, dilutedReqs, 'diluted', _selectedMode, globalConsumedRanges);
      final thematicResult = _analyzeKeywords(
          text, thematicReqs, 'thematic', _selectedMode, globalConsumedRanges);

      // 5. Создание подсветки и итогового результата (остается как было)
      final highlightedText =
          _buildHighlightedText(text, exactReqs, thematicReqs);

      pair.analysisResult = AnalysisResult(
        generalResults: generalResults,
        volumeResult: volumeResult,
        titleResult: titleResult,
        descriptionResult: descriptionResult,
        structureResult: structureResult,
        exactInclusion: AnalysisCategoryResult(exactResult),
        dilutedInclusion: AnalysisCategoryResult(dilutedResult),
        thematicWords: AnalysisCategoryResult(thematicResult),
        highlightedText: highlightedText,
      );
    }

    setState(() => _isLoading = false);
  }

  // <<< ИСПРАВЛЕНИЕ: ДОБАВЛЕН НЕДОСТАЮЩИЙ МЕТОД >>>
  void _showError(String message) {
    setState(() => _isLoading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  String? _parseSection(String tzText, List<String> markers) {
    final tzLines = tzText.split('\n');
    int bestStartLine = -1;
    String? foundMarker;

    // 1. Ищем наиболее подходящую стартовую строку.
    for (int i = 0; i < tzLines.length; i++) {
      final trimmedLine = tzLines[i].trim();
      if (trimmedLine.isEmpty) continue;

      for (var marker in markers) {
        final lowerMarker = marker.toLowerCase();
        final potentialHeader =
            trimmedLine.split(RegExp(r'[:\-—]')).first.trim().toLowerCase();

        // ИЗМЕНЕНИЕ: Заменяем '==' на 'startsWith' для большей гибкости.
        // Это позволяет находить заголовки, даже если в строке есть доп. текст, например "(...)"
        if (potentialHeader.startsWith(lowerMarker)) {
          // Мы нашли подходящий заголовок. Запоминаем его и продолжаем поиск,
          // чтобы найти самое последнее (а значит, самое релевантное) вхождение в ТЗ.
          bestStartLine = i;
          foundMarker = marker;
        }
      }
    }

    if (bestStartLine == -1) return null;

    // 2. Обработка однострочных полей (Title, Description)
    final startLineText = tzLines[bestStartLine].trim();
    final separatorMatch = RegExp(r'[:\-—]').firstMatch(startLineText);

    if (markers.any((m) => ['title', 'description']
            .contains(m.toLowerCase().replaceAll(':', ''))) &&
        separatorMatch != null) {
      final content = startLineText.substring(separatorMatch.end).trim();
      if (content.isNotEmpty) return content;
    }

    // 3. Сбор контента для многострочных секций
    List<String> contentLines = [];
    final lowerCaseMarkers =
        markers.map((m) => m.toLowerCase().replaceAll(':', '')).toList();

    final bool isParsingStructure =
        lowerCaseMarkers.any((m) => m.contains('структура'));

    List<String> stopMarkers = _allKnownMarkers
        .map((m) => m.toLowerCase().replaceAll(':', ''))
        .where((m) => !lowerCaseMarkers.contains(m))
        .toList();

    if (isParsingStructure) {
      stopMarkers.removeWhere((m) => m == 'h1' || m == 'h2');
    }

    // Начинаем сбор со следующей строки после заголовка
    for (int i = bestStartLine + 1; i < tzLines.length; i++) {
      final currentLine = tzLines[i];
      final trimmedLine = currentLine.trim();

      if (trimmedLine.isEmpty) {
        if (contentLines.isEmpty) continue;
        if (i + 1 < tzLines.length && tzLines[i + 1].trim().isEmpty) {
          if (!isParsingStructure) {
            break;
          }
        }
      }

      if (trimmedLine.isNotEmpty) {
        bool isNewSection = stopMarkers.any((stopMarker) {
          final potentialHeader =
              trimmedLine.split(RegExp(r'[:\-—]')).first.trim().toLowerCase();
          // Здесь оставляем '==' для четкой остановки
          return potentialHeader == stopMarker;
        });
        if (isNewSection) break;
      }

      contentLines.add(currentLine);
    }

    String fullContent = contentLines.join('\n').trim();

    // 4. Пост-обработка для списков слов (убираем вводные фразы)
    if (markers.any((m) =>
        m.toLowerCase().contains('подсветки') ||
        m.toLowerCase().contains('тематические'))) {
      final lines = fullContent.split('\n');
      int listStartIndex = -1;
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (RegExp(r'^[•*-]').hasMatch(line) ||
            (line.isNotEmpty && !line.contains(' ') && line.length < 30) ||
            (line.isNotEmpty &&
                RegExp(r'^\S.*\S$').hasMatch(line) &&
                !line.toLowerCase().startsWith('используя'))) {
          listStartIndex = i;
          break;
        }
      }
      if (listStartIndex != -1) {
        return lines.sublist(listStartIndex).join('\n').trim();
      }
    }

    return fullContent.isEmpty ? null : fullContent;
  }

  List<KeywordRequirement> _parseKeywordsFromText(String text) {
    if (text.toLowerCase() == "не найдено" || text.isEmpty) return [];

    List<KeywordRequirement> keywords = [];
    final lines =
        text.split('\n').where((line) => line.trim().isNotEmpty).toList();

    // --- НОВАЯ ЛОГИКА ДЛЯ ДВУХСТРОЧНОГО ФОРМАТА ---

    // 1. Отфильтровываем заголовки таблицы, чтобы они не стали ключами
    final header1 = 'Ключевое слово'.toLowerCase();
    final header2 = 'Количество упоминаний в тексте(раз(а))'.toLowerCase();
    final contentLines = lines.where((line) {
      final trimmedLower = line.trim().toLowerCase();
      return trimmedLower.isNotEmpty &&
          trimmedLower != header1 &&
          trimmedLower != header2;
    }).toList();

    // Регулярное выражение для поиска количества на отдельной строке, например "(10)"
    final countOnNextLineRegex = RegExp(r'^\((\d+)\)$');

    // Регулярные выражения для других форматов (как запасной вариант)
    final rangeRegex = RegExp(r'(.+?)\s*\((\d+)(?:-(\d+))?\)\s*$');
    final tableRegex = RegExp(r'^(.*?)\s+\d+\s+раз\(?а?\)');

    // 2. Итерируем по отфильтрованным строкам, ища пары "ключ -> (количество)"
    for (int i = 0; i < contentLines.length; i++) {
      final currentLine = contentLines[i].trim();

      // Проверяем, есть ли следующая строка и похожа ли она на "(число)"
      if (i + 1 < contentLines.length) {
        final nextLine = contentLines[i + 1].trim();
        final match = countOnNextLineRegex.firstMatch(nextLine);

        if (match != null) {
          // Нашли пару!
          final phrase = currentLine.replaceAll(RegExp(r'[\.,;]$'), '');
          final count = int.parse(match.group(1)!);

          keywords.add(KeywordRequirement(phrase, count, count));

          // Пропускаем следующую строку, так как мы ее уже обработали
          i++;
          continue; // Переходим к следующей паре
        }
      }

      // 3. Если пара не найдена, пробуем распознать другие форматы (для универсальности)
      final rangeMatch = rangeRegex.firstMatch(currentLine);
      if (rangeMatch != null) {
        final phrase =
            rangeMatch.group(1)!.trim().replaceAll(RegExp(r'[\.,;]$'), '');
        final min = int.parse(rangeMatch.group(2)!);
        final max =
            rangeMatch.group(3) != null ? int.parse(rangeMatch.group(3)!) : min;
        keywords.add(KeywordRequirement(phrase, min, max));
        continue;
      }

      final tableMatch = tableRegex.firstMatch(currentLine);
      if (tableMatch != null) {
        // Это для формата "ключ 10 раз(а)"
        final phrase =
            tableMatch.group(1)!.trim().replaceAll(RegExp(r'[\.,;]$'), '');
        final countString = RegExp(r'(\d+)').firstMatch(currentLine)!.group(1)!;
        final count = int.parse(countString);
        keywords.add(KeywordRequirement(phrase, count, count));
        continue;
      }

      // 4. Если ничего не подошло, считаем, что это ключ с требованием "хотя бы 1 раз"
      if (currentLine.isNotEmpty) {
        keywords.add(KeywordRequirement(
            currentLine.replaceAll(RegExp(r'[\.,;]$'), ''), 1, 999));
      }
    }

    return keywords;
  }

  List<GeneralRequirementResult> _analyzeGeneralRequirements(
      String text, String requirementText) {
    List<GeneralRequirementResult> results = [];

    final services = ['Уникальность', 'Главред', 'Тургенев', 'Спам', 'Вода'];
    for (var service in services) {
      final reqRegex =
          RegExp(service + r'.*?(\d+[\.,]?\d*)', caseSensitive: false);
      final actRegex = RegExp(service + r'[:\-—\s]*(\d+[\.,]?\d*)[/\d\s,]*%',
          caseSensitive: false);

      final reqMatch = reqRegex.firstMatch(requirementText);
      final actMatch = actRegex.firstMatch(text);

      final reqValue =
          double.tryParse(reqMatch?.group(1)?.replaceAll(',', '.') ?? '');
      final actValue =
          double.tryParse(actMatch?.group(1)?.replaceAll(',', '.') ?? '');

      if (reqValue != null && actValue != null) {
        bool success = true;
        String reqString = '';
        if (service == 'Уникальность' || service == 'Главред') {
          success = actValue >= reqValue;
          reqString = '≥ $reqValue';
        } else {
          success = actValue <= reqValue;
          reqString = '≤ $reqValue';
        }
        results.add(
            GeneralRequirementResult(service, reqString, '$actValue', success));
      }
    }

    final firstParagraph = text.split('\n').first;
    results.add(GeneralRequirementResult('Первый абзац', '≤ 500 симв.',
        '${firstParagraph.length}', firstParagraph.length <= 500));

    final hasList = text.contains(RegExp(r'^\s*[•*-]|\d+\.', multiLine: true));
    results.add(GeneralRequirementResult(
        'Списки', 'Хотя бы 1', hasList ? 'Есть' : 'Нет', hasList));

    final h2Count =
        RegExp(r'^H2\s*[:\-—]', multiLine: true, caseSensitive: false)
            .allMatches(text)
            .length;
    results.add(GeneralRequirementResult('Подзаголовки H2', 'Есть',
        h2Count > 0 ? 'Найдено: $h2Count' : 'Нет', h2Count > 0));

    return results;
  }

  String _formatKeywordsForField(String rawText) {
    final reqs = _parseKeywordsFromText(rawText);
    if (reqs.isEmpty)
      return rawText; // Возвращаем как есть, если не удалось распарсить
    return reqs.map((r) => "${r.phrase} (${r.min})").join('\n');
  }

  String _analyzeVolume(String text, String requirement) {
    final currentVolume = text.replaceAll(' ', '').length;
    final regex = RegExp(r'(\d+)');
    final matches = regex.allMatches(requirement).toList();
    if (matches.isEmpty) {
      return 'Текущий объем: $currentVolume симв. Требование в ТЗ не найдено.';
    }
    final minVolume = int.parse(matches[0].group(1)!);
    final maxVolume = matches.length > 1
        ? int.parse(matches[1].group(1)!)
        : minVolume + (minVolume * 0.2).round();

    if (currentVolume >= minVolume && currentVolume <= maxVolume) {
      return '✅ Объем соответствует: $currentVolume из $minVolume-$maxVolume симв. (без пробелов)';
    } else if (currentVolume < minVolume) {
      return '❌ Объем не соответствует: $currentVolume из $minVolume-$maxVolume симв. (нужно еще ${minVolume - currentVolume})';
    } else {
      return '❌ Объем не соответствует: $currentVolume из $minVolume-$maxVolume симв. (превышение на ${currentVolume - maxVolume})';
    }
  }

  String _analyzeMetaTag(String text, String requirement, String tagName) {
    if (requirement.toLowerCase() == "не найдено" || requirement.isEmpty) {
      return 'Требование для $tagName не найдено в ТЗ.';
    }
    if (text.toLowerCase().contains(requirement.toLowerCase().trim())) {
      return '✅ $tagName найден в тексте.';
    } else {
      return '❌ $tagName не найден в тексте.';
    }
  }

  String _analyzeStructure(String text, String requirement) {
    if (requirement.toLowerCase() == "не найдено" || requirement.isEmpty) {
      return 'Требование по структуре не найдено в ТЗ.';
    }
    final requiredHeadings = requirement
        .split('\n')
        .where((h) => h.trim().isNotEmpty)
        .map((h) => h.trim().toLowerCase().replaceAll(RegExp(r'^\d+\.\s*'), ''))
        .toList();
    int foundCount = 0;
    List<String> notFoundHeadings = [];
    for (var heading in requiredHeadings) {
      if (text
          .toLowerCase()
          .contains(heading.replaceAll(RegExp(r'[:\-—]'), ''))) {
        foundCount++;
      } else {
        notFoundHeadings.add(heading);
      }
    }
    final isOk = foundCount >= requiredHeadings.length;
    String result =
        '${isOk ? '✅' : '⚠️'} Найдено $foundCount из ${requiredHeadings.length} заголовков структуры.';
    if (notFoundHeadings.isNotEmpty) {
      result += '\nНе найдены: ${notFoundHeadings.join(", ")}';
    }
    return result;
  }

  bool _isWordBoundary(String text, int index) {
    if (index < 0 || index > text.length) return false;
    if (index == 0 || index == text.length) return true;
    final prevChar = text[index - 1];
    final nextChar = text[index];
    final boundaryChars = RegExp(r'[\s.,!?;:()\[\]"' '’]');
    return boundaryChars.hasMatch(prevChar) || boundaryChars.hasMatch(nextChar);
  }

  int _countOccurrences(
      String text, String phrase, bool exact, List<List<int>> consumedRanges) {
    if (phrase.isEmpty) return 0;
    int count = 0;

    final lowerText = text.toLowerCase();
    final lowerPhrase = phrase.toLowerCase();

    // Находим все потенциальные совпадения
    for (final match in lowerPhrase.allMatches(lowerText)) {
      bool isOverlapping = false;
      // Проверяем, не пересекается ли найденное совпадение с уже "занятыми"
      for (final range in consumedRanges) {
        if (match.start < range[1] && match.end > range[0]) {
          isOverlapping = true;
          break;
        }
      }

      if (isOverlapping) continue; // Если пересекается, пропускаем его

      // Если включен точный поиск, проверяем границы слов
      if (exact) {
        bool isStartBoundary =
            (match.start == 0) || _isWordBoundary(lowerText, match.start);
        bool isEndBoundary = (match.end == lowerText.length) ||
            _isWordBoundary(lowerText, match.end);
        if (isStartBoundary && isEndBoundary) {
          count++;
        }
      } else {
        count++;
      }
    }
    return count;
  }

  List<MapEntry<KeywordRequirement, int>> _analyzeKeywords(
    String text,
    List<KeywordRequirement> requirements,
    String type,
    SearchMode mode,
    List<List<int>> globalConsumedRanges, // Для режима "Уникальные"
  ) {
    List<MapEntry<KeywordRequirement, int>> results = [];

    // ИСПРАВЛЕНИЕ 1: Правильно определяем stopWords как Set<String>
    const stopWords = {
      'и',
      'в',
      'на',
      'с',
      'к',
      'по',
      'о',
      'у',
      'за',
      'из',
      'для',
      'от',
      'до',
      'без',
      'через'
    };

    // Создаем локальный список "занятых" диапазонов для режима "Разовые"
    List<List<int>> localConsumedRanges = [];
    // Выбираем, с каким списком работать, в зависимости от режима
    final activeRanges = (mode == SearchMode.uniquePass)
        ? globalConsumedRanges
        : localConsumedRanges;

    // Для режимов "Разовые" и "Уникальные" КРАЙНЕ ВАЖНО сначала искать длинные фразы
    if (mode != SearchMode.overlapping) {
      requirements.sort((a, b) => b.phrase.length.compareTo(a.phrase.length));
    }

    for (var req in requirements) {
      int count = 0;
      final lowerText = text.toLowerCase();
      final lowerPhrase = req.phrase.toLowerCase();

      // Простой режим "Пересечение" - работает как раньше, но с пустым списком диапазонов
      if (mode == SearchMode.overlapping) {
        if (type == 'exact' || type == 'thematic') {
          count = _countOccurrences(text, req.phrase, true, []);
        } else if (type == 'diluted') {
          final significantWords = req.phrase
              .toLowerCase()
              .replaceAll(RegExp(r'[,.!?]'), '')
              .split(' ')
              .where((w) => w.isNotEmpty && !stopWords.contains(w))
              .toList();
          if (significantWords.isEmpty) {
            results.add(MapEntry(req, 0));
            continue;
          }
          final sentences = text.split(RegExp(r'[.!?\n]'));
          for (var sentence in sentences) {
            final lowerSentence = sentence.toLowerCase();
            if (significantWords.every((word) =>
                _countOccurrences(lowerSentence, word, true, []) > 0)) {
              count++;
            }
          }
        }
      } else {
        // Логика для "Разовых" и "Уникальных"
        if (type == 'exact' || type == 'thematic') {
          // ИСПРАВЛЕНИЕ 2: Используем RegExp для поиска, чтобы получать правильный тип Match
          for (final match
              in RegExp(RegExp.escape(lowerPhrase)).allMatches(lowerText)) {
            bool isOverlapping = activeRanges
                .any((range) => match.start < range[1] && match.end > range[0]);
            if (isOverlapping) continue;

            bool isStartBoundary =
                (match.start == 0) || _isWordBoundary(lowerText, match.start);
            bool isEndBoundary = (match.end == lowerText.length) ||
                _isWordBoundary(lowerText, match.end);

            if (isStartBoundary && isEndBoundary) {
              count++;
              activeRanges.add([match.start, match.end]); // Блокируем диапазон
            }
          }
        } else if (type == 'diluted') {
          final significantWords = req.phrase
              .toLowerCase()
              .replaceAll(RegExp(r'[,.!?]'), '')
              .split(' ')
              .where((w) => w.isNotEmpty && !stopWords.contains(w))
              .toList();
          if (significantWords.isEmpty) {
            results.add(MapEntry(req, 0));
            continue;
          }
          final sentences = text.split(RegExp(r'[.!?\n]'));
          int sentenceOffset = 0;
          for (var sentence in sentences) {
            final lowerSentence = sentence.toLowerCase();

            // Проверяем, не пересекается ли все предложение с уже занятыми диапазонами
            bool sentenceOverlaps = activeRanges.any((range) =>
                sentenceOffset < range[1] &&
                (sentenceOffset + sentence.length) > range[0]);
            if (sentenceOverlaps) {
              sentenceOffset += sentence.length + 1;
              continue; // Пропускаем это предложение
            }

            bool allWordsFound = significantWords.every((word) {
              // ИСПРАВЛЕНИЕ 3: Используем RegExp для поиска, чтобы получать правильный тип Match
              final wordMatches =
                  RegExp(RegExp.escape(word)).allMatches(lowerSentence);
              return wordMatches.any((match) {
                bool isStartBoundary = (match.start == 0) ||
                    _isWordBoundary(lowerSentence, match.start);
                bool isEndBoundary = (match.end == lowerSentence.length) ||
                    _isWordBoundary(lowerSentence, match.end);
                return isStartBoundary && isEndBoundary;
              });
            });

            if (allWordsFound) {
              count++;
              // Блокируем весь диапазон предложения
              activeRanges
                  .add([sentenceOffset, sentenceOffset + sentence.length]);
            }
            sentenceOffset += sentence.length + 1; // +1 для разделителя
          }
        }
      }
      results.add(MapEntry(req, count));
    }
    return results;
  }

  List<TextSpan> _buildHighlightedText(String text,
      List<KeywordRequirement> exact, List<KeywordRequirement> thematic) {
    List<TextSpan> spans = [];

    Map<String, Color> phrasesToHighlight = {};
    for (var req in exact) {
      phrasesToHighlight[req.phrase.toLowerCase()] =
          // ignore: deprecated_member_use
          Colors.yellow.withOpacity(0.5);
    }
    for (var req in thematic) {
      if (!phrasesToHighlight.containsKey(req.phrase.toLowerCase())) {
        phrasesToHighlight[req.phrase.toLowerCase()] =
            Colors.lightBlue.withOpacity(0.4);
      }
    }

    if (phrasesToHighlight.isEmpty) {
      return [TextSpan(text: text)];
    }

    final pattern =
        phrasesToHighlight.keys.map((p) => RegExp.escape(p)).join('|');
    final regex = RegExp(pattern, caseSensitive: false);

    int lastIndex = 0;
    for (var match in regex.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
      }
      final matchedPhrase = match.group(0)!.toLowerCase();

      bool isStartBoundary = (match.start == 0) ||
          _isWordBoundary(text.toLowerCase(), match.start);
      bool isEndBoundary = (match.end == text.length) ||
          _isWordBoundary(text.toLowerCase(), match.end);

      if (isStartBoundary && isEndBoundary) {
        spans.add(TextSpan(
          text: match.group(0)!,
          style: TextStyle(backgroundColor: phrasesToHighlight[matchedPhrase]),
        ));
      } else {
        spans.add(TextSpan(text: match.group(0)!));
      }
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex)));
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),
      drawer: isMobile ? buildAppDrawer(context) : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: MaxWidthBox(
            maxWidth: 1600,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Breadcrumbs(items: [
                  BreadcrumbItem(text: "Главная", routeName: '/'),
                  BreadcrumbItem(text: "Полезное", routeName: '/useful'),
                  BreadcrumbItem(
                      text: "Инструменты SEO",
                      routeName: '/useful/instruments'),
                  BreadcrumbItem(
                      text: "SEO Анализатор текста", routeName: null),
                ]),
                const SizedBox(height: 40),
                Text("Анализатор текста на соответствие SEO ТЗ",
                    style: headlineTextStyle(context)),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    // Этот стиль будет применен ко всему тексту по умолчанию
                    style: subtitleTextStyle(context),
                    children: <TextSpan>[
                      const TextSpan(
                        text:
                            'Вставьте ваш текст и техническое задание, чтобы проверить соответствие ключевых параметров. Можно добавить до 5 пар для одновременного анализа.\n\n',
                      ),
                      TextSpan(
                        text: 'ПРИМЕР/ШАБЛОН ПОЛНОЦЕННОГО РАБОТАЮЩЕГО ТЗ',
                        // Стиль для самой ссылки (синий цвет и подчеркивание)
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .primary, // Используем основной цвет темы
                          decoration: TextDecoration.underline,
                        ),
                        // Обработчик нажатия на эту часть текста
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final url = Uri.parse(
                                'https://docs.google.com/document/d/1DAVnjwPHQGfa23KZN7SO71T5DeSRtcRB/edit?usp=sharing&ouid=114606455229993507775&rtpof=true&sd=true');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              // Можно добавить обработку ошибки, если ссылка не открылась
                              // например, показать SnackBar
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Не удалось открыть ссылку')),
                              );
                            }
                          },
                      ),
                    ],
                  ),
                ),
                // <<< БЛОК С КНОПКОЙ >>>
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    icon: const Icon(Icons.help_outline, size: 18),
                    label: const Text("Как это работает?"),
                    onPressed: () => _showHelpDialog(context),
                  ),
                ),
                const SizedBox(height: 40),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _pairs.length,
                  itemBuilder: (context, index) {
                    return _buildTextTzPairWidget(index, theme);
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_pairs.length < 5)
                      OutlinedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text("Добавить пару"),
                        onPressed: _addPair,
                      ),
                    if (_pairs.length > 1) ...[
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.remove),
                        label: const Text("Удалить последнюю"),
                        style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red),
                        onPressed: () => _removePair(_pairs.length - 1),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 40),
                _buildSearchModeSelector(),
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.analytics_outlined),
                    label: const Text("Запустить глобальный анализ"),
                    style: elevatedButtonStyle(context).copyWith(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.green[700]),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 48, vertical: 20)),
                      textStyle: MaterialStateProperty.all(const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    onPressed: _isLoading ? null : _runGlobalAnalysis,
                  ),
                ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (_pairs.any((p) => p.analysisResult != null)) ...[
                  const SizedBox(height: 40),
                  divider(context),
                  const SizedBox(height: 40),
                  Text("Результаты анализа", style: headlineTextStyle(context)),
                  const SizedBox(height: 24),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _pairs.length,
                    itemBuilder: (context, index) {
                      final pair = _pairs[index];
                      if (pair.analysisResult == null)
                        return const SizedBox.shrink();
                      return _buildResultSection(
                          context, pair.analysisResult!, index + 1);
                    },
                  )
                ],
                const SizedBox(height: 80),
                divider(context),
                const Footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextTzPairWidget(int index, ThemeData theme) {
    final pair = _pairs[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Пара №${index + 1}",
                style: headlineSecondaryTextStyle(context)),
            const SizedBox(height: 16),
            ResponsiveRowColumn(
              layout: ResponsiveBreakpoints.of(context).smallerThan(TABLET)
                  ? ResponsiveRowColumnType.COLUMN
                  : ResponsiveRowColumnType.ROW,
              rowSpacing: 24,
              columnSpacing: 24,
              children: [
                ResponsiveRowColumnItem(
                    rowFlex: 1,
                    child: _buildInputField(context, pair.textController,
                        "Текст", "Вставьте текст статьи...", 10)),
                ResponsiveRowColumnItem(
                    rowFlex: 1,
                    child: _buildInputField(context, pair.tzController,
                        "Техническое задание", "Вставьте ТЗ...", 10)),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () => _parseTzForPair(index),
                child: const Text("Распарсить это ТЗ"),
              ),
            ),
            if (pair.parsedTz != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: _buildEditableFieldsForPair(pair),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableFieldsForPair(TextTzPair pair) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Проверьте и скорректируйте данные из ТЗ",
            style: headlineSecondaryTextStyle(context)),
        const SizedBox(height: 16),
        // <<< ИЗМЕНЕНИЕ: ИСПОЛЬЗУЕМ КОНТРОЛЛЕРЫ ИЗ `pair` ВМЕСТО ГЛОБАЛЬНЫХ >>>
        _buildEditableField(context, pair.volumeController, "Объем текста"),
        const SizedBox(height: 16),
        _buildEditableField(context, pair.titleController, "Метатег Title"),
        const SizedBox(height: 16),
        _buildEditableField(
            context, pair.descriptionController, "Метатег Description"),
        const SizedBox(height: 16),
        _buildEditableField(
            context, pair.structureController, "Структура текста"),
        const SizedBox(height: 16),
        _buildEditableField(
            context, pair.exactKeywordsController, "Точное вхождение (Ключи)"),
        const SizedBox(height: 16),
        _buildEditableField(context, pair.dilutedKeywordsController,
            "Слова из подсветки в выдаче"),
        const SizedBox(height: 16),
        _buildEditableField(
            context, pair.thematicWordsController, "Тематические слова (LSI)"),
      ],
    );
  }

  Widget _buildInputField(BuildContext context,
      TextEditingController controller, String label, String hint, int lines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: headlineSecondaryTextStyle(context)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: lines,
          style: bodyTextStyle(context),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: subtitleTextStyle(context),
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 2.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableField(
      BuildContext context, TextEditingController controller, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: headlineSecondaryTextStyle(context)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          style: bodyTextStyle(context).copyWith(fontFamily: 'monospace'),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: "Если данные не нашлись, вы можете вписать их сюда...",
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 2.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultSection(
      BuildContext context, AnalysisResult result, int pairNumber) {
    return ExpansionTile(
      title: Text("Результаты анализа для Пары №$pairNumber",
          style: headlineTextStyle(context)),
      initiallyExpanded: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (result.highlightedText.isNotEmpty) ...[
                Text("Текст с подсветкой",
                    style: headlineSecondaryTextStyle(context)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText.rich(
                    TextSpan(
                      style: bodyTextStyle(context),
                      children: result.highlightedText,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              Text("Общие требования",
                  style: headlineSecondaryTextStyle(context)),
              const SizedBox(height: 8),
              ...result.generalResults.map((res) => Card(
                    child: ListTile(
                      title: Text(res.name),
                      subtitle: Text(
                          "Требование: ${res.requirement}, Факт: ${res.actual}"),
                      trailing: res.isSuccess
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.error, color: Colors.red),
                    ),
                  )),
              const SizedBox(height: 24),
              Text("Параметры из ТЗ",
                  style: headlineSecondaryTextStyle(context)),
              const SizedBox(height: 8),
              Card(
                  child: ListTile(
                      leading: const Icon(Icons.text_fields),
                      title: const Text("Объем текста (без пробелов)"),
                      subtitle: Text(result.volumeResult),
                      trailing: result.volumeResult.contains('✅')
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.error, color: Colors.red))),
              Card(
                  child: ListTile(
                      leading: const Icon(Icons.title),
                      title: const Text("Метатег Title"),
                      subtitle: Text(result.titleResult),
                      trailing: result.titleResult.contains('✅')
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.warning, color: Colors.orange))),
              Card(
                  child: ListTile(
                      leading: const Icon(Icons.description),
                      title: const Text("Метатег Description"),
                      subtitle: Text(result.descriptionResult),
                      trailing: result.descriptionResult.contains('✅')
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.warning, color: Colors.orange))),
              Card(
                  child: ListTile(
                      leading: const Icon(Icons.format_list_bulleted),
                      title: const Text("Структура текста"),
                      subtitle: Text(result.structureResult),
                      trailing: result.structureResult.contains('✅')
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.warning, color: Colors.orange))),
              const SizedBox(height: 24),
              _buildKeywordAnalysisSection(
                  context, "Точное вхождение", result.exactInclusion),
              const SizedBox(height: 24),
              _buildKeywordAnalysisSection(context,
                  "Слова из подсветки в выдаче", result.dilutedInclusion),
              const SizedBox(height: 24),
              _buildKeywordAnalysisSection(
                  context, "Тематические слова (LSI)", result.thematicWords),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildKeywordAnalysisSection(BuildContext context, String title,
      AnalysisCategoryResult categoryResult) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: headlineSecondaryTextStyle(context)),
        const SizedBox(height: 16),
        if (categoryResult.results.isEmpty)
          const Text("Требования для этой категории в ТЗ не найдены.")
        else ...[
          Text("Всего ключей в ТЗ: ${categoryResult.results.length}"),
          if (categoryResult.notFound > 0)
            Text(
                "❌ Нет вхождений: ${categoryResult.notFound} из ${categoryResult.results.length}",
                style: const TextStyle(color: Colors.red)),
          if (categoryResult.moreThanNeeded > 0)
            Text(
                "⚠️ Вхождений больше, чем нужно: ${categoryResult.moreThanNeeded} из ${categoryResult.results.length}",
                style: const TextStyle(color: Colors.orange)),
          if (categoryResult.lessThanNeeded > 0)
            Text(
                "⚠️ Вхождений меньше, чем нужно: ${categoryResult.lessThanNeeded} из ${categoryResult.results.length}",
                style: const TextStyle(color: Colors.orange)),
          if (categoryResult.perfectMatch > 0)
            Text(
                "✅ Требуемое кол-во вхождений: ${categoryResult.perfectMatch} из ${categoryResult.results.length}",
                style: const TextStyle(color: Colors.green)),
          const SizedBox(height: 8),
          ExpansionTile(
            title: const Text("Показать детальную таблицу"),
            children: [
              SizedBox(
                width: double.infinity,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Ключевая фраза")),
                    DataColumn(label: Text("Требуется"), numeric: true),
                    DataColumn(label: Text("Найдено"), numeric: true),
                  ],
                  rows: categoryResult.results.map((entry) {
                    final req = entry.key;
                    final count = entry.value;
                    Color rowColor = Colors.transparent;
                    if (count == 0)
                      rowColor = Colors.red.withOpacity(0.1);
                    else if (count < req.min || count > req.max)
                      rowColor = Colors.orange.withOpacity(0.1);
                    else
                      rowColor = Colors.green.withOpacity(0.1);

                    return DataRow(
                        color: MaterialStateProperty.all(rowColor),
                        cells: [
                          DataCell(Text(req.phrase)),
                          DataCell(Text(req.max >= 999
                              ? "≥ ${req.min}"
                              : (req.min == req.max
                                  ? "${req.min}"
                                  : "${req.min}-${req.max}"))),
                          DataCell(Text("$count")),
                        ]);
                  }).toList(),
                ),
              ),
            ],
          )
        ]
      ],
    );
  }
}
