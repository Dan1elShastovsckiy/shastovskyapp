// lib/pages/page_html_sandbox.dart

import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:highlight/languages/xml.dart' as lang_xml;
import 'package:highlight/languages/css.dart' as lang_css;
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:minimal/utils/meta_tag_service.dart';
import 'package:minimal/pages/pages.dart';
import 'package:responsive_framework/responsive_framework.dart'
    hide MaxWidthBox;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Условный импорт для веб-специфичного кода
import 'package:webview_flutter_web/webview_flutter_web.dart'
    if (dart.library.io) 'dart:io';

class HtmlSandboxPage extends StatefulWidget {
  static const String name = '${TryCodingPage.name}/html-css-sandbox';
  const HtmlSandboxPage({super.key});

  @override
  State<HtmlSandboxPage> createState() => _HtmlSandboxPageState();
}

class _HtmlSandboxPageState extends State<HtmlSandboxPage> {
  late CodeController _htmlController;
  late CodeController _cssController;
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    MetaTagService().updateAllTags(
      title: "Песочница HTML & CSS | Блог Даниила Шастовского",
      description:
          "Интерактивная песочница для верстки. Тестируйте HTML и CSS в реальном времени.",
    );

    _htmlController = CodeController(
      language: lang_xml.xml,
      text: _initialHtml,
    );
    _cssController = CodeController(
      language: lang_css.css,
      text: _initialCss,
    );

    _webViewController = WebViewController();

    if (!kIsWeb) {
      _webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    }

    _updatePreview();
    _htmlController.addListener(_updatePreview);
    _cssController.addListener(_updatePreview);
  }

  void _updatePreview() {
    final hasScriptTag =
        RegExp(r'<script', caseSensitive: false).hasMatch(_htmlController.text);

    if (hasScriptTag) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Использование <script> тегов в этой песочнице отключено.'),
          backgroundColor: Colors.orange,
        ),
      );
      _loadContent(_scriptsDisabledPage);
      return;
    }

    final fullHtml = '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>${_cssController.text}</style>
      </head>
      <body>
        ${_htmlController.text}
      </body>
      </html>
    ''';
    _loadContent(fullHtml);
  }

  void _loadContent(String htmlContent) {
    if (kIsWeb) {
      final platformController =
          _webViewController.platform as WebWebViewController;
      platformController.loadHtmlString(htmlContent);
    } else {
      _webViewController.loadRequest(
        Uri.dataFromString(
          htmlContent,
          mimeType: 'text/html',
          encoding: Encoding.getByName('utf-8'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _htmlController.dispose();
    _cssController.dispose();
    super.dispose();
  }

  void _applyExample(String html, String css) {
    _htmlController.text = html;
    _cssController.text = css;
    _updatePreview();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Пример кода применен!'),
          backgroundColor: Colors.green),
    );
  }

  // <<< НАЧАЛО БЛОКА ХЕЛПЕР-МЕТОДОВ (ПЕРЕМЕЩЕНЫ ВВЕРХ) >>>

  // Внутри класса _HtmlSandboxPageState

  Widget _HighlightedTitle(String title) {
    return Container(
      // Отступы, чтобы маркер не прилипал к краям
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        // Создаем градиент "маркера"
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color.fromARGB(255, 248, 211, 255).withOpacity(0.15),
            const Color.fromARGB(255, 255, 198, 217).withOpacity(0.25),
          ],
          stops: const [0.0, 1.0],
        ),
        borderRadius: BorderRadius.circular(8), // Скругляем углы
      ),
      child: Text(
        title,
        style: headlineSecondaryTextStyle(context),
        textAlign: TextAlign.center, // Текст внутри маркера тоже по центру
      ),
    );
  }

  Widget _buildCodeEditor(
      CodeController controller, String title, IconData icon, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(title, style: headlineSecondaryTextStyle(context)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            child: CodeTheme(
              data: CodeThemeData(
                  styles: isDark ? atomOneDarkTheme : atomOneLightTheme),
              child: CodeField(
                controller: controller,
                textStyle:
                    bodyTextStyle(context).copyWith(fontFamily: 'monospace'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    String? htmlExample,
    String? cssExample,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final codeTheme = isDark ? atomOneDarkTheme : atomOneLightTheme;
    final codeStyle = bodyTextStyle(context).copyWith(
        fontFamily: 'monospace',
        color: codeTheme['root']?.color,
        backgroundColor: Colors.transparent);
    final labelStyle =
        bodyTextStyle(context).copyWith(color: Colors.grey[500], fontSize: 12);

    void copyToClipboard(String text, String type) {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$type код скопирован в буфер обмена!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ExpansionTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title,
            style: headlineSecondaryTextStyle(context).copyWith(fontSize: 18)),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        // ignore: deprecated_member_use
        backgroundColor: theme.colorScheme.surface.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text(content, style: bodyTextStyle(context))),
          if (htmlExample != null || cssExample != null) ...[
            const SizedBox(height: 16),
            divider(context),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child:
                  Text("Пример:", style: headlineSecondaryTextStyle(context)),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: codeTheme['root']?.backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (htmlExample != null) ...[
                      Text("HTML", style: labelStyle),
                      const SizedBox(height: 4),
                      SelectableText(htmlExample, style: codeStyle),
                    ],
                    if (htmlExample != null && cssExample != null)
                      const SizedBox(height: 12),
                    if (cssExample != null) ...[
                      Text("CSS", style: labelStyle),
                      const SizedBox(height: 4),
                      SelectableText(cssExample, style: codeStyle),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (htmlExample != null)
                  TextButton.icon(
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text("HTML"),
                    onPressed: () => copyToClipboard(htmlExample, "HTML"),
                  ),
                if (cssExample != null)
                  TextButton.icon(
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text("CSS"),
                    onPressed: () => copyToClipboard(cssExample, "CSS"),
                  ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => _applyExample(
                      htmlExample ?? _htmlController.text,
                      cssExample ?? _cssController.text),
                  child: const Text("Применить"),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExampleCard({
    required BuildContext context,
    required String title,
    required String description,
    required String htmlCode,
    required String cssCode,
  }) {
    final theme = Theme.of(context);

    void copyToClipboard(String text, String type) {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$type код скопирован в буфер обмена!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    void applyCode() {
      _applyExample(htmlCode, cssCode);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  bodyTextStyle(context).copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(description, style: subtitleTextStyle(context)),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              bool useWrapLayout = constraints.maxWidth < 450;
              if (useWrapLayout) {
                return Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 8.0,
                  runSpacing: 4.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    TextButton.icon(
                        icon: const Icon(Icons.copy_all_outlined, size: 16),
                        label: const Text("HTML"),
                        onPressed: () => copyToClipboard(htmlCode, "HTML")),
                    TextButton.icon(
                        icon: const Icon(Icons.copy_all_outlined, size: 16),
                        label: const Text("CSS"),
                        onPressed: () => copyToClipboard(cssCode, "CSS")),
                    ElevatedButton(
                        onPressed: applyCode, child: const Text("Применить")),
                  ],
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                        icon: const Icon(Icons.copy_all_outlined, size: 16),
                        label: const Text("HTML"),
                        onPressed: () => copyToClipboard(htmlCode, "HTML")),
                    const SizedBox(width: 8),
                    TextButton.icon(
                        icon: const Icon(Icons.copy_all_outlined, size: 16),
                        label: const Text("CSS"),
                        onPressed: () => copyToClipboard(cssCode, "CSS")),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: applyCode, child: const Text("Применить")),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // <<< КОНЕЦ БЛОКА ХЕЛПЕР-МЕТОДОВ >>>

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 800;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),
      drawer: isMobile ? buildAppDrawer(context) : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: MaxWidthBox(
            maxWidth: 1600,
            child: Column(
              children: [
                const Breadcrumbs(items: [
                  BreadcrumbItem(text: "Главная", routeName: '/'),
                  BreadcrumbItem(text: "Полезное", routeName: '/useful'),
                  BreadcrumbItem(
                      text: "Попробуй кодить",
                      routeName: '/${TryCodingPage.name}'),
                  BreadcrumbItem(text: "Песочница HTML/CSS"),
                ]),
                const SizedBox(height: 24),
                Text("Песочница: HTML & CSS",
                    style: headlineTextStyle(context)),
                const SizedBox(height: 24),
                ResponsiveRowColumn(
                  layout: ResponsiveBreakpoints.of(context).largerThan(TABLET)
                      ? ResponsiveRowColumnType.ROW
                      : ResponsiveRowColumnType.COLUMN,
                  rowCrossAxisAlignment: CrossAxisAlignment.start,
                  rowSpacing: 24,
                  columnSpacing: 24,
                  children: [
                    ResponsiveRowColumnItem(
                      rowFlex: 1,
                      child: Column(
                        children: [
                          _buildCodeEditor(
                              _htmlController, "HTML", Icons.code, isDark),
                          const SizedBox(height: 24),
                          _buildCodeEditor(
                              _cssController, "CSS", Icons.color_lens, isDark),
                        ],
                      ),
                    ),
                    ResponsiveRowColumnItem(
                      rowFlex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Превью:",
                              style: headlineSecondaryTextStyle(context)),
                          const SizedBox(height: 8),
                          Container(
                            height: 624,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: theme.dividerColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: WebViewWidget(
                              controller: _webViewController,
                              gestureRecognizers: {
                                Factory<VerticalDragGestureRecognizer>(
                                    () => VerticalDragGestureRecognizer()),
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                divider(context),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Интерактивный справочник с примерами",
                      style: headlineTextStyle(context)),
                ),
                const SizedBox(height: 16),
                _buildFeatureTile(context,
                    icon: Icons.code,
                    title: "Что такое HTML?",
                    content:
                        "HTML (HyperText Markup Language) — это язык разметки, который определяет структуру веб-страницы. Он использует 'теги' для описания элементов, таких как заголовки, параграфы и изображения.",
                    htmlExample:
                        '<h1>Главный заголовок</h1>\n<p>Это параграф текста.</p>'),
                _buildFeatureTile(context,
                    icon: Icons.color_lens,
                    title: "Что такое CSS?",
                    content:
                        "CSS (Cascading Style Sheets) — это язык стилей, который описывает внешний вид HTML-документа. Он отвечает за цвета, шрифты, отступы и расположение элементов.",
                    htmlExample:
                        '<p class="highlight">Этот текст будет стилизован.</p>',
                    cssExample:
                        ".highlight {\n  color: tomato;\n  font-size: 20px;\n}"),
                _buildFeatureTile(context,
                    icon: Icons.home_work_outlined,
                    title: "Структура HTML-документа",
                    content:
                        "Любой HTML-документ имеет базовую структуру: `<html>`, `<head>` для мета-информации (стили, заголовок вкладки) и `<body>` для всего видимого контента.",
                    htmlExample:
                        '<html>\n  <head>\n    <title>Моя страница</title>\n  </head>\n  <body>\n    Привет, мир!\n  </body>\n</html>'),
                _buildFeatureTile(context,
                    icon: Icons.title,
                    title: "Заголовки (<h1> - <h6>)",
                    content:
                        "Заголовки используются для структурирования текста. `<h1>` — самый главный заголовок (должен быть один на странице), `<h2>` — подзаголовки, и так далее по иерархии.",
                    htmlExample:
                        '<h1>Тема статьи</h1>\n<h2>Подтема 1</h2>\n<p>Текст...</p>\n<h2>Подтема 2</h2>'),
                _buildFeatureTile(context,
                    icon: Icons.short_text,
                    title: "Текст и списки (<p>, <ul>, <ol>)",
                    content:
                        "Для текста используется тег `<p>`. Списки бывают маркированные (`<ul>`) и нумерованные (`<ol>`). Каждый элемент списка помещается в тег `<li>`.",
                    htmlExample:
                        '<ul>\n  <li>Пункт 1</li>\n  <li>Пункт 2</li>\n</ul>'),
                _buildFeatureTile(context,
                    icon: Icons.link,
                    title: "Ссылки (<a>) и Изображения (<img>)",
                    content:
                        "Ссылка создается тегом `<a>` с атрибутом `href`. Изображение — тегом `<img>` с атрибутом `src`. Атрибут `alt` (альтернативный текст) очень важен для доступности.",
                    htmlExample:
                        '<a href="#">Это ссылка</a>\n<img src="https://via.placeholder.com/150" alt="Пример изображения">'),
                _buildFeatureTile(context,
                    icon: Icons.view_quilt,
                    title: "Блочные и строчные элементы",
                    content:
                        "Блочные элементы (`<div>`, `<p>`, `<h1>`) занимают всю доступную ширину и начинаются с новой строки. Строчные (`<span>`, `<a>`, `<strong>`) занимают только необходимое пространство.",
                    htmlExample:
                        '<div style="background: lightblue;">Блочный</div>\n<span style="background: lightpink;">Строчный</span>'),
                _buildFeatureTile(context,
                    icon: Icons.interests,
                    title: "CSS Селекторы (классы и ID)",
                    content:
                        "CSS находит HTML-элементы с помощью селекторов. Классы (`.my-class`) можно использовать много раз. ID (`#unique-id`) должен быть уникальным на странице.",
                    htmlExample:
                        '<p class="info">Инфо</p>\n<p id="error">Ошибка</p>',
                    cssExample:
                        ".info { color: blue; }\n#error { color: red; font-weight: bold; }"),
                _buildFeatureTile(context,
                    icon: Icons.format_paint,
                    title: "Основные свойства CSS",
                    content:
                        "Самые базовые свойства: `color` (цвет текста), `background-color` (цвет фона), `font-size` (размер шрифта), `font-weight` (жирность), `margin` (внешний отступ) и `padding` (внутренний отступ).",
                    htmlExample: '<div class="box">Текст внутри блока</div>',
                    cssExample:
                        ".box {\n  background-color: #f0f0f0;\n  padding: 20px;\n  margin: 10px;\n  border: 1px solid grey;\n}"),
                _buildFeatureTile(context,
                    icon: Icons.border_all,
                    title: "Блочная модель (Box Model)",
                    content:
                        "Каждый HTML-элемент — это прямоугольный блок, состоящий из контента, внутренних отступов (padding), рамки (border) и внешних отступов (margin). Понимание этой модели — ключ к верстке.",
                    htmlExample: '<div class="box-model">Контент</div>',
                    cssExample:
                        ".box-model {\n  width: 100px;\n  padding: 10px; /* Внутренний отступ */\n  border: 5px solid navy; /* Рамка */\n  margin: 20px; /* Внешний отступ */\n  background: lightblue;\n}"),
                _buildFeatureTile(context,
                    icon: Icons.view_carousel,
                    title: "Flexbox: Гибкое выравнивание",
                    content:
                        "Flexbox — это мощный инструмент CSS для выравнивания и распределения элементов в контейнере. `display: flex;` на родительском элементе активирует его.",
                    htmlExample:
                        '<div class="container">\n  <div>1</div>\n  <div>2</div>\n  <div>3</div>\n</div>',
                    cssExample:
                        ".container {\n  display: flex;\n  justify-content: space-around; /* Выравнивание по горизонтали */\n  align-items: center; /* Выравнивание по вертикали */\n  background: #eee;\n  height: 100px;\n}\n.container > div { background: dodgerblue; color: white; padding: 10px; }"),
                _buildFeatureTile(context,
                    icon: Icons.layers,
                    title: "Позиционирование (Position)",
                    content:
                        "Свойство `position` управляет расположением элемента. Основные значения: `static` (по умолчанию), `relative` (относительно себя), `absolute` (относительно родителя), `fixed` (относительно окна браузера).",
                    htmlExample:
                        '<div class="parent">\n  <div class="child"></div>\n</div>',
                    cssExample:
                        ".parent {\n  position: relative; /* Родитель должен быть не-static */\n  width: 150px; height: 150px; background: lightgrey;\n}\n.child {\n  position: absolute;\n  bottom: 10px; right: 10px;\n  width: 50px; height: 50px; background: tomato;\n}"),
                _buildFeatureTile(context,
                    icon: Icons.devices,
                    title: "Адаптивность (Media Queries)",
                    content:
                        "Media Queries позволяют применять разные стили в зависимости от размера экрана, делая сайт адаптивным для мобильных устройств и ПК.",
                    htmlExample:
                        '<div class="responsive-box">Меняет цвет</div>',
                    cssExample:
                        ".responsive-box {\n  background: lightblue;\n  padding: 20px;\n}\n/* Если ширина экрана 600px или меньше */\n@media (max-width: 600px) {\n  .responsive-box {\n    background: lightgreen;\n  }\n}"),
                _buildFeatureTile(context,
                    icon: Icons.animation,
                    title: "Псевдоклассы и переходы",
                    content:
                        "Псевдоклассы стилизуют элементы в определенном состоянии. Самый известный — `:hover` (при наведении курсора). В сочетании со свойством `transition` можно создавать плавные анимации.",
                    htmlExample:
                        '<button class="animated-button">Наведи на меня</button>',
                    cssExample:
                        ".animated-button {\n  background-color: dodgerblue;\n  color: white;\n  padding: 15px;\n  border: none;\n  border-radius: 5px;\n  transition: all 0.3s ease; /* Плавный переход */\n}\n.animated-button:hover {\n  background-color: royalblue;\n  transform: scale(1.1);\n  cursor: pointer;\n}"),

                const SizedBox(height: 40),
                divider(context),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Готовые примеры для песочницы",
                      style: headlineTextStyle(context)),
                ),
                const SizedBox(height: 24),
                _HighlightedTitle("Базовые элементы"),
                const SizedBox(height: 16),
                _buildExampleCard(
                    context: context,
                    title: "Стилизованная таблица",
                    description:
                        "Пример создания читаемой и аккуратной таблицы с разделителями и hover-эффектом строк.",
                    htmlCode: _example3Html,
                    cssCode: _example3Css),
                const SizedBox(height: 16),
                _buildExampleCard(
                    context: context,
                    title: "Форма входа",
                    description:
                        "Базовая разметка и стилизация для полей ввода и кнопки, создающие простую форму.",
                    htmlCode: _example4Html,
                    cssCode: _example4Css),
                const SizedBox(height: 16),
                _buildExampleCard(
                    context: context,
                    title: "Цитата (Blockquote)",
                    description:
                        "Как правильно оформлять цитаты для визуального выделения в тексте.",
                    htmlCode: _example5Html,
                    cssCode: _example5Css),
                const SizedBox(height: 16),
                _buildExampleCard(
                    context: context,
                    title: "Карточки с иконками",
                    description:
                        "Создание карточек услуг или преимуществ с использованием иконок FontAwesome.",
                    htmlCode: _example6Html,
                    cssCode: _example6Css),
                const SizedBox(height: 24),
                _HighlightedTitle("Интерактивность и анимация"),
                const SizedBox(height: 16),
                _buildExampleCard(
                    context: context,
                    title: "Карточка с тенью и анимацией",
                    description:
                        "Простой пример создания интерактивной карточки, которая 'приподнимается' при наведении.",
                    htmlCode: _example1Html,
                    cssCode: _example1Css),
                const SizedBox(height: 16),
                _buildExampleCard(
                    context: context,
                    title: "Кнопка с градиентом",
                    description:
                        "Как создать стильную кнопку с плавным переходом цвета и изменением при наведении.",
                    htmlCode: _example2Html,
                    cssCode: _example2Css),
                const SizedBox(height: 16),
                _buildExampleCard(
                    context: context,
                    title: "Пульсирующая точка",
                    description:
                        "Создание анимированного индикатора 'онлайн' или уведомления с помощью CSS-анимации.",
                    htmlCode: _example7Html,
                    cssCode: _example7Css),
                const SizedBox(height: 16),
                _buildExampleCard(
                    context: context,
                    title: "Эффект 'стекла' (Glassmorphism)",
                    description:
                        "Популярный эффект полупрозрачного размытого фона, создающий ощущение матового стекла.",
                    htmlCode: _example8Html,
                    cssCode: _example8Css),
                const SizedBox(height: 16),
                _buildExampleCard(
                    context: context,
                    title: "3D-кнопка при нажатии",
                    description:
                        "Создание кнопки с псевдо-3D эффектом, которая 'вдавливается' при клике.",
                    htmlCode: _example11Html,
                    cssCode: _example11Css),
                const SizedBox(height: 24),
                _HighlightedTitle("Макеты и позиционирование"),
                const SizedBox(height: 16),
                _buildExampleCard(
                    context: context,
                    title: "Flexbox-галерея",
                    description:
                        "Простая адаптивная галерея изображений, которая автоматически переносит элементы.",
                    htmlCode: _example9Html,
                    cssCode: _example9Css),
                const SizedBox(height: 16),
                _buildExampleCard(
                    context: context,
                    title: "Карточка товара (Flexbox)",
                    description:
                        "Классический макет карточки товара с изображением, текстом и кнопкой внизу.",
                    htmlCode: _example10Html,
                    cssCode: _example10Css),
                const SizedBox(height: 16),
                _buildExampleCard(
                    context: context,
                    title: "Центрирование элемента",
                    description:
                        "Самый надежный способ идеально отцентрировать элемент по горизонтали и вертикали.",
                    htmlCode: _example12Html,
                    cssCode: _example12Css),

                const SizedBox(height: 40),
                divider(context),

                // <<< НАЧАЛО БЛОКА АВТОРА И ФУТЕРА >>>
                const SizedBox(height: 24),
                const Breadcrumbs(items: [
                  BreadcrumbItem(text: "Главная", routeName: '/'),
                  BreadcrumbItem(text: "Полезное", routeName: '/useful'),
                  BreadcrumbItem(
                      text: "Попробуй кодить",
                      routeName: '/${TryCodingPage.name}'),
                  BreadcrumbItem(text: "Песочница HTML/CSS"),
                ]),
                const SizedBox(height: 40),
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
                const SizedBox(height: 40),
                ...authorSection(
                  context: context, // Передаем контекст для ссылки
                  imageUrl: "assets/images/avatar_default.webp",
                  name: "Автор: Шастовский Даниил",
                  bio:
                      "SEO-специалист, автор этого сайта. Помогаю проектам расти в поисковой выдаче, используя данные, опыт и немного магии AI.",
                ),
                const SizedBox(height: 40),
                divider(context),
                // <<< КОНЕЦ БЛОКА АВТОРА И ФУТЕРА >>>

                const Footer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// <<< ДАННЫЕ ДЛЯ ПРИМЕРОВ >>>

const _initialHtml = '''<h1>Заголовок H1</h1>
<p>Это обычный параграф текста.</p>
<p class="custom-style">А это параграф с кастомным CSS классом.</p>
<button>Кнопка</button>
''';

const _initialCss = '''.custom-style {
  color: #007BFF;
  font-size: 20px;
  font-weight: bold;
  border-left: 3px solid #007BFF;
  padding-left: 10px;
}
button {
  padding: 10px 20px;
  border-radius: 8px;
  border: 1px solid grey;
  cursor: pointer;
  background-color: #f0f0f0;
}
''';

// -- Существующие примеры --
const _example1Html = '''<div class="card">
  <h2>Карточка товара</h2>
  <p>Это описание товара. При наведении курсора карточка немного увеличится.</p>
</div>
''';
const _example1Css = '''.card {
  background-color: white;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
  transition: all 0.3s ease-in-out;
  border: 1px solid #eee;
}

.card:hover {
  transform: scale(1.05);
  box-shadow: 0 8px 16px rgba(0,0,0,0.2);
}
''';

const _example2Html = '''<button class="gradient-button">
  Градиентная кнопка
</button>
''';
const _example2Css = '''.gradient-button {
  background-image: linear-gradient(to right, #DA4453 0%, #89216B 51%, #DA4453 100%);
  padding: 15px 45px;
  text-align: center;
  text-transform: uppercase;
  transition: 0.5s;
  background-size: 200% auto;
  color: white;
  box-shadow: 0 0 20px #eee;
  border-radius: 10px;
  border: none;
  cursor: pointer;
}

.gradient-button:hover {
  background-position: right center;
  color: #fff;
  text-decoration: none;
}
''';

// -- Новые примеры --

const _example3Html = '''<table>
  <thead>
    <tr>
      <th>Имя</th>
      <th>Должность</th>
      <th>Город</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Анна</td>
      <td>Дизайнер</td>
      <td>Москва</td>
    </tr>
    <tr>
      <td>Иван</td>
      <td>Разработчик</td>
      <td>Санкт-Петербург</td>
    </tr>
  </tbody>
</table>
''';
const _example3Css = '''table {
  width: 100%;
  border-collapse: collapse;
  font-family: sans-serif;
}
th, td {
  border: 1px solid #ddd;
  padding: 12px;
  text-align: left;
}
th {
  background-color: #f2f2f2;
  font-weight: bold;
}
tbody tr:hover {
  background-color: #f5f5f5;
}
''';

const _example4Html = '''<form class="login-form">
  <h2>Вход</h2>
  <div class="form-group">
    <label for="email">Email:</label>
    <input type="email" id="email" required>
  </div>
  <div class="form-group">
    <label for="password">Пароль:</label>
    <input type="password" id="password" required>
  </div>
  <button type="submit">Войти</button>
</form>
''';
const _example4Css = '''.login-form {
  max-width: 300px;
  margin: 20px auto;
  padding: 20px;
  border: 1px solid #ccc;
  border-radius: 8px;
}
.form-group { margin-bottom: 15px; }
label { display: block; margin-bottom: 5px; }
input { width: 100%; padding: 8px; box-sizing: border-box; }
button { width: 100%; padding: 10px; background-color: #007BFF; color: white; border: none; border-radius: 4px; cursor: pointer; }
''';

const _example5Html = '''<blockquote class="styled-quote">
  <p>"Лучший способ предсказать будущее — это создать его."</p>
  <footer>— Питер Друкер</footer>
</blockquote>
''';
const _example5Css = '''.styled-quote {
  border-left: 5px solid #007BFF;
  margin: 20px;
  padding: 15px;
  background-color: #f9f9f9;
  font-style: italic;
}
.styled-quote footer {
  margin-top: 10px;
  text-align: right;
  font-style: normal;
  font-weight: bold;
}
''';

const _example6Html =
    '''<!-- Подключаем иконки Font Awesome (требуется интернет) -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<div class="features">
  <div class="feature-card">
    <i class="fas fa-rocket"></i>
    <h3>Скорость</h3>
    <p>Быстрая загрузка и работа.</p>
  </div>
  <div class="feature-card">
    <i class="fas fa-shield-alt"></i>
    <h3>Надежность</h3>
    <p>Защита ваших данных.</p>
  </div>
  <div class="feature-card">
    <i class="fas fa-headset"></i>
    <h3>Поддержка</h3>
    <p>Помощь 24/7.</p>
  </div>
</div>
''';
const _example6Css = '''.features {
  display: flex;
  justify-content: space-around;
  gap: 20px;
  text-align: center;
}
.feature-card {
  padding: 20px;
  border: 1px solid #eee;
  border-radius: 8px;
  flex: 1;
}
.feature-card i {
  font-size: 36px;
  color: #007BFF;
  margin-bottom: 15px;
}
''';

const _example7Html = '''<div class="status-indicator"></div>''';
const _example7Css = '''@keyframes pulse {
  0% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(25, 118, 210, 0.7); }
  70% { transform: scale(1); box-shadow: 0 0 0 10px rgba(25, 118, 210, 0); }
  100% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(25, 118, 210, 0); }
}
.status-indicator {
  width: 15px;
  height: 15px;
  background-color: #1976D2;
  border-radius: 50%;
  animation: pulse 2s infinite;
}
''';

const _example8Html = '''<div class="background-image">
  <div class="glass-card">
    <h2>Glassmorphism</h2>
    <p>Это эффект матового стекла.</p>
  </div>
</div>
''';
const _example8Css = '''.background-image {
  background-image: url('https://images.unsplash.com/photo-1554147090-e1221a04a025?auto=format&fit=crop&w=800&q=60');
  background-size: cover;
  padding: 50px;
  border-radius: 10px;
}
.glass-card {
  background: rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border-radius: 15px;
  padding: 20px;
  border: 1px solid rgba(255, 255, 255, 0.3);
  color: white;
  text-shadow: 0 0 5px black;
}
''';

const _example9Html = '''<div class="gallery">
  <img src="https://via.placeholder.com/150/FF0000/FFFFFF?text=1" alt="Image 1">
  <img src="https://via.placeholder.com/150/00FF00/FFFFFF?text=2" alt="Image 2">
  <img src="https://via.placeholder.com/150/0000FF/FFFFFF?text=3" alt="Image 3">
  <img src="https://via.placeholder.com/150/FFFF00/000000?text=4" alt="Image 4">
  <img src="https://via.placeholder.com/150/FF00FF/FFFFFF?text=5" alt="Image 5">
</div>
''';
const _example9Css = '''.gallery {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}
.gallery img {
  flex: 1 1 150px;
  max-width: 100%;
  height: auto;
  border-radius: 5px;
}
''';

const _example10Html = '''<div class="product-card">
  <img src="https://via.placeholder.com/300x200" alt="Product Image">
  <div class="product-info">
    <h3>Название товара</h3>
    <p>Краткое описание товара, его основные преимущества и особенности.</p>
    <button>В корзину</button>
  </div>
</div>
''';
const _example10Css = '''.product-card {
  display: flex;
  flex-direction: column;
  width: 300px;
  border: 1px solid #ddd;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
  font-family: sans-serif;
}
.product-card img { width: 100%; height: auto; }
.product-info {
  padding: 15px;
  display: flex;
  flex-direction: column;
  flex-grow: 1;
}
.product-info h3 { margin-top: 0; }
.product-info p { flex-grow: 1; }
.product-info button {
  margin-top: auto;
  padding: 10px;
  border: none;
  background: #007BFF;
  color: white;
  border-radius: 4px;
}
''';

const _example11Html = '''<button class="pushable">
  <span class="shadow"></span>
  <span class="edge"></span>
  <span class="front">
    Нажми!
  </span>
</button>
''';
const _example11Css = '''.pushable {
  position: relative; background: transparent; border: none; padding: 0; cursor: pointer;
}
.shadow { position: absolute; top: 0; left: 0; width: 100%; height: 100%; border-radius: 12px; background: hsl(0deg 0% 0% / 0.25); transform: translateY(2px); }
.edge { position: absolute; top: 0; left: 0; width: 100%; height: 100%; border-radius: 12px; background: linear-gradient(to left, hsl(340deg 100% 32%) 0%, hsl(340deg 100% 16%) 8%, hsl(340deg 100% 16%) 92%, hsl(340deg 100% 32%) 100%); }
.front { display: block; position: relative; padding: 12px 42px; border-radius: 12px; font-size: 1.25rem; color: white; background: hsl(345deg 100% 47%); transform: translateY(-4px); transition: transform 600ms cubic-bezier(.3, .7, .4, 1); }
.pushable:hover .front { transform: translateY(-6px); }
.pushable:active .front { transform: translateY(-2px); }
''';

const _example12Html = '''<div class="parent-container">
  <div class="centered-child">
    Я в центре!
  </div>
</div>
''';
const _example12Css = '''.parent-container {
  display: grid;
  place-items: center;
  height: 200px;
  background-color: #f0f0f0;
  border-radius: 8px;
}
.centered-child {
  padding: 20px;
  background-color: #007BFF;
  color: white;
  border-radius: 4px;
}
''';

const String _scriptsDisabledPage = '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0; background-color: #fffbe6; }
    .container { text-align: center; padding: 20px; color: #78350f; }
    .icon { font-size: 48px; }
  </style>
</head>
<body>
  <div class="container">
    <div class="icon">✋</div>
    <h2>Использование JavaScript отключено</h2>
    <p>Для обеспечения стабильности, выполнение скриптов в этой песочнице пока не поддерживается. Пожалуйста, используйте только HTML и CSS.</p>
  </div>
</body>
</html>
''';
