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
    // <<< ЗАМЕНИТЕ ЭТОТ БЛОК >>>
    MetaTagService().updateAllTags(
      title: "Песочница HTML & CSS | Интерактивный редактор кода",
      description:
          "Тестируйте верстку и стили в реальном времени. Встроенный справочник и готовые примеры для быстрого старта в веб-разработке.",
      imageUrl:
          "https://shastovsky.ru/assets/assets/images/seo-guides/techcheck_website_seo.webp", // <-- Добавлена картинка
    );

    _htmlController =
        CodeController(language: lang_xml.xml, text: _initialHtml);
    _cssController = CodeController(language: lang_css.css, text: _initialCss);
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
      // <<< ИЗМЕНЕНИЕ: ВЫЗЫВАЕМ НОВУЮ ФУНКЦИЮ ДЛЯ ГЕНЕРАЦИИ ЗАГЛУШКИ >>>
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

  // <<< НАЧАЛО БЛОКА ХЕЛПЕР-МЕТОДОВ >>>

  Widget _HighlightedTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color.fromARGB(255, 248, 211, 255).withOpacity(0.15),
            const Color.fromARGB(255, 255, 198, 217).withOpacity(0.25),
          ],
          stops: const [0.0, 1.0],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: headlineSecondaryTextStyle(context),
        textAlign: TextAlign.center,
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
                                  Uri.parse('https://t.me/switchleveler'))),
                          ElevatedButton.icon(
                              icon: Icon(Icons.campaign,
                                  color: theme.colorScheme.onSurface),
                              label: const Text('Telegram канал'),
                              style: elevatedButtonStyle(context),
                              onPressed: () => launchUrl(
                                  Uri.parse('https://t.me/shastovscky'))),
                          ElevatedButton.icon(
                              icon: Icon(Icons.camera_alt,
                                  color: theme.colorScheme.onSurface),
                              label: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Instagram'),
                                    const SizedBox(height: 2),
                                    Text('Запрещенная в РФ организация',
                                        style: TextStyle(
                                            fontSize: 9,
                                            color: theme.colorScheme.secondary))
                                  ]),
                              style: elevatedButtonStyle(context),
                              onPressed: () => launchUrl(Uri.parse(
                                  'https://instagram.com/yellolwapple'))),
                          ElevatedButton.icon(
                              icon: Icon(Icons.work,
                                  color: theme.colorScheme.onSurface),
                              label: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('LinkedIn'),
                                    const SizedBox(height: 2),
                                    Text('Запрещенная в РФ организация',
                                        style: TextStyle(
                                            fontSize: 9,
                                            color: theme.colorScheme.secondary))
                                  ]),
                              style: elevatedButtonStyle(context),
                              onPressed: () => launchUrl(Uri.parse(
                                  'https://hh.ru/resume/b94af167ff049031c70039ed1f746c61797571'))),
                          ElevatedButton.icon(
                              icon: Icon(Icons.smart_display_outlined,
                                  color: theme.colorScheme.onSurface),
                              label: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('YouTube'),
                                    const SizedBox(height: 2),
                                    Text('Запрещенная в РФ организация',
                                        style: TextStyle(
                                            fontSize: 9,
                                            color: theme.colorScheme.secondary))
                                  ]),
                              style: elevatedButtonStyle(context),
                              onPressed: () => launchUrl(Uri.parse(
                                  'https://www.youtube.com/@itsmyadv'))),
                          ElevatedButton.icon(
                              icon: Icon(Icons.article_outlined,
                                  color: theme.colorScheme.onSurface),
                              label: const Text('VC.RU'),
                              style: elevatedButtonStyle(context),
                              onPressed: () => launchUrl(
                                  Uri.parse('https://vc.ru/id1145025'))),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ...authorSection(
                    context: context, // Передаем контекст для ссылки
                    imageUrl: "assets/images/avatar_default.webp",
                    name: "Автор: Я, Шастовский Даниил",
                    bio:
                        "Автор этого сайта, аналитик, фотограф, путешественник и просто хороший человек. Я люблю делиться своими впечатлениями и фотографиями из поездок по всему миру."),
                //нерабочие кнопки навигации
                const SizedBox(height: 40),
                divider(context),

                const Footer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// <<< НАЧАЛО БЛОКА С ДАННЫМИ ДЛЯ ПРИМЕРОВ И ЗАГЛУШКИ >>>

// <<< ФИНАЛЬНОЕ ИСПРАВЛЕНИЕ ДЛЯ КАРТИНКИ >>>
// HTML-код для страницы-заглушки.
const String _scriptsDisabledPage = '''
  <!DOCTYPE html>
  <html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
      body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0; background-color: #fef2f2; }
      .container { text-align: center; padding: 20px; color: #7f1d1d; }
      img { max-width: 150px; margin-bottom: 20px; border-radius: 8px; }
      h2 { color: #b91c1c; }
    </style>
  </head>
  <body>
    <div class="container">
      <img src="data:image/webp;base64,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" alt="JavaScript Disabled">
      <h2>Выполнение JavaScript отключено</h2>
      <p>Для обеспечения стабильности, использование тега &lt;script&gt; в этой песочнице не поддерживается.<br>Пожалуйста, используйте только HTML и CSS.</p>
    </div>
  </body>
  </html>
''';

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

// <<< УДАЛЕНА КОНСТАНТА _scriptsDisabledPage, ТАК КАК ОНА ПЕРЕМЕЩЕНА В ФУНКЦИЮ >>>
