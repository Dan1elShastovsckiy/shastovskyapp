// lib/pages/page_flutter_seo_post.dart

import 'package:flutter/gestures.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:minimal/components/comments_section.dart';
import 'package:minimal/components/reactions_widget.dart';
import 'package:minimal/components/related_articles.dart';
import 'package:minimal/components/share_buttons_block.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:minimal/utils/meta_tag_service.dart';
import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
// <<< ШАГ 1: Добавляем импорт семантических виджетов >>>
import 'package:minimal/components/semantic_widgets.dart';

class PostFlutterSeoPage extends StatefulWidget {
  static const String name = 'useful/dev/flutter-web-seo';

  const PostFlutterSeoPage({super.key});

  @override
  State<PostFlutterSeoPage> createState() => _PostFlutterSeoPageState();
}

class _PostFlutterSeoPageState extends State<PostFlutterSeoPage> {
  final List<String> _pageImages = [
    "assets/images/dev-guides/flutter_ssg_flowchart.webp",
    "assets/images/dev-guides/nginx_config_snippet.webp",
    "assets/images/avatar_default.webp",
  ];

  // <<< ШАГ 2: Добавляем флаг для определения режима рендеринга >>>
  bool _isPrerendering = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final imagePath in _pageImages) {
      precacheImage(AssetImage(imagePath), context);
    }
  }

  @override
  void initState() {
    super.initState();
    // <<< ШАГ 3: Проверяем URL на наличие параметра пререндеринга >>>
    final uri = Uri.base;
    if (uri.queryParameters['prerender'] == 'true') {
      setState(() {
        _isPrerendering = true;
      });
    }

    MetaTagService().updateAllTags(
      title:
          "Flutter Web и SEO: Реализация SSG на shastovsky.com | Блог Даниила Шастовского",
      description:
          "Глубокое погружение в то, как этот сайт добивается SEO-дружелюбности. Разбор реального кода Dart-скрипта для пререндеринга, семантических виджетов и 'двухрежимной' логики.",
      imageUrl:
          "https://shastovsky.com/assets/assets/images/dev-guides/flutter_ssg_flowchart.webp",
    );
  }

  // <<< ШАГ 4: Новый метод для генерации семантического контента >>>
  Widget _buildPrerenderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SemanticH1("Flutter Web и SEO: Как это сделано на shastovsky.com"),
        SemanticP(
            "Flutter Web по умолчанию создает Single Page Application (SPA), отрисовывая весь интерфейс на одном HTML-элементе <canvas>. Для поисковых роботов это «черный ящик». Эта статья — подробный разбор того, как именно этот сайт решает проблему SEO с помощью собственного механизма генерации статических сайтов (SSG)."),
        SemanticImg(
            src: "assets/images/dev-guides/flutter_ssg_flowchart.webp",
            alt: "Схема работы пререндеринга для Flutter Web"),

        SemanticH2("Проблема: Canvas-рендеринг и поисковые роботы"),
        SemanticP(
            "Когда поисковый робот заходит на стандартный Flutter Web сайт, он видит почти пустой HTML-файл. Весь контент — текст, заголовки, ссылки, картинки — скрыт внутри <canvas>. Робот не может это проанализировать, и с точки зрения SEO страница пуста. Наша задача — отдать ему чистый, структурированный HTML, который он поймет."),

        SemanticH2("Стратегия: «Два режима» — умный рендеринг для всех"),
        SemanticP(
            "В основе решения лежит принцип «двух режимов». Каждая страница сайта умеет рендериться двумя способами:"),
        SemanticP(
            "1. Для пользователя: Запускается полноценное интерактивное Flutter-приложение с красивым UI, анимациями и CanvasKit-рендерингом."),
        SemanticP(
            "2. Для пререндеринга (и поисковых роботов): Страница отрисовывает только специальный набор невидимых виджетов, которые генерируют семантически верное дерево HTML-элементов (<h1>, <p>, <img>)."),
        SemanticP(
            "Сигналом для переключения в режим пререндеринга служит GET-параметр в URL: ?prerender=true."),

        SemanticH2("Компонент №1: Семантические виджеты"),
        SemanticP(
            "Чтобы Flutter мог генерировать HTML-теги, были созданы специальные виджеты-обертки, такие как SemanticH1, SemanticP, SemanticImg. Их задача — используя Dart-библиотеки для веба, создать реальный HTML-элемент и добавить его в DOM-дерево. Сами виджеты имеют нулевой размер и не видны пользователю."),
        SemanticA(
            href: "#",
            text:
                "Посмотреть код SemanticWidget"), // Заглушка, т.к. нет pop-up в HTML

        SemanticH2("Компонент №2: Dart-скрипт для пререндеринга"),
        SemanticP(
            "Это сердце всей системы. После каждой сборки (`flutter build web`) запускается скрипт на Dart, который автоматизирует весь процесс:"),
        SemanticP(
            "1. Запускает локальный веб-сервер для раздачи собранного приложения."),
        SemanticP(
            "2. Запускает headless-браузер (Chrome) с помощью пакета Puppeteer."),
        SemanticP(
            "3. В цикле обходит все заданные роуты сайта, добавляя к каждому URL параметр ?prerender=true."),
        SemanticP(
            "4. На каждой странице ждет, пока Flutter сгенерирует и наполнит специальный HTML-контейнер."),
        SemanticP(
            "5. Извлекает сгенерированный HTML, а также актуальные мета-теги из <head>."),
        SemanticP(
            "6. Вставляет полученный контент в шаблонный index.html и сохраняет результат в нужную папку (например, /build/web/marocco/index.html)."),
        SemanticA(href: "#", text: "Посмотреть ключевую часть prerender.dart"),

        SemanticH2("Компонент №3: «Двухрежимная» логика на страницах"),
        SemanticP(
            "Каждая страница, которую нужно пререндерить, содержит простую условную логику. В методе initState она проверяет URL. Если параметр ?prerender=true найден, устанавливается внутренний флаг. Метод build затем использует этот флаг, чтобы решить, что рендерить: полноценный Scaffold с Flutter-виджетами или простую Column с семантическими HTML-виджетами."),
        SemanticA(href: "#", text: "Посмотреть пример кода страницы"),

        SemanticH2("Финальный штрих: Конфигурация Nginx"),
        SemanticP(
            "Последний шаг — научить веб-сервер правильно отдавать сгенерированные файлы. Nginx настраивается так, чтобы любой запрос к странице (например, shastovsky.com/marocco) он внутренне перенаправлял на соответствующий статический файл (shastovsky.com/marocco/index.html)."),
        SemanticImg(
            src: "assets/images/dev-guides/nginx_config_snippet.webp",
            alt: "Пример конфигурации Nginx"),

        SemanticH2("Результат и выводы"),
        SemanticP(
            "Этот подход, хоть и требует ручной работы по дублированию контента в семантические виджеты, дает полный контроль над HTML, который увидят поисковые роботы. В результате сайт на Flutter Web становится полностью SEO-дружелюбным, сохраняя при этом всю мощь и красоту интерактивного SPA для реальных пользователей."),
      ],
    );
  }

  // Вспомогательная функция для показа всплывающих окон
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
                    code: bodyTextStyle(context).copyWith(
                      fontFamily: 'monospace',
                      backgroundColor:
                          theme.colorScheme.onSurface.withOpacity(0.1),
                    ),
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

  @override
  Widget build(BuildContext context) {
    // <<< ШАГ 5: Добавляем условную логику в метод build >>>
    if (_isPrerendering) {
      return Material(
          child: SingleChildScrollView(child: _buildPrerenderContent()));
    }

    final isMobile = MediaQuery.of(context).size.width < 800;
    final theme = Theme.of(context);
    return Scaffold(
      drawer: isMobile ? buildAppDrawer(context) : null,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),
      body: CustomScrollView(
        slivers: [
          ...[
            const SizedBox(height: 24),
            Center(
              child: Text(
                DateFormat.yMMMMd('ru_RU').format(DateTime(2025, 7, 20)),
                style: bodyTextStyle(context).copyWith(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Flutter Web и SEO: Как это сделано на shastovsky.com",
              style: headlineTextStyle(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  "~18 минут чтения",
                  style: subtitleTextStyle(context)
                      .copyWith(fontStyle: FontStyle.italic, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Breadcrumbs(
                items: [
                  BreadcrumbItem(text: "Главная", routeName: '/'),
                  BreadcrumbItem(text: "Полезное", routeName: '/useful'),
                  BreadcrumbItem(text: "Разработка", routeName: '/useful/dev'),
                  BreadcrumbItem(text: "Flutter Web & SEO"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const TextBody(
              text:
                  "Flutter Web по умолчанию создает Single Page Application (SPA), отрисовывая весь интерфейс на одном HTML-элементе <canvas>. Для поисковых роботов это «черный ящик», который они не могут проиндексировать. Эта статья — подробный разбор того, как именно этот сайт решает проблему SEO с помощью собственного механизма генерации статических сайтов (SSG).",
            ),
            const TextHeadlineSecondary(
                text: "Проблема: Canvas-рендеринг и поисковые роботы"),
            const TextBody(
              text:
                  "Когда поисковый робот (краулер) Google или Яндекс заходит на стандартный Flutter Web сайт, он видит почти пустой HTML-файл. Весь ваш контент — текст, заголовки, ссылки, картинки — скрыт внутри <canvas>. Робот не может это проанализировать, и с точки зрения SEO ваша страница пуста. Наша задача — при визите робота отдать ему чистый, структурированный HTML, который он поймет.",
            ),
            const TextHeadlineSecondary(
                text: "Стратегия: «Два режима» — умный рендеринг для всех"),
            const ImageWrapper(
                image: "assets/images/dev-guides/flutter_ssg_flowchart.webp"),
// <<< ИСПРАВЛЕНИЕ: Заменяем TextBody на RichText >>>
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 24.0), // Добавляем стандартный отступ, как у TextBody
              child: RichText(
                text: TextSpan(
                  // Устанавливаем базовый стиль для всего текста, чтобы он выглядел как TextBody
                  style: bodyTextStyle(context),
                  children: <TextSpan>[
                    const TextSpan(
                        text:
                            'В основе решения лежит принцип «двух режимов». Каждая страница сайта умеет рендериться двумя способами:\n\n1.  '),
                    TextSpan(
                        text: 'Для пользователя:',
                        style: bodyTextStyle(context)
                            .copyWith(fontWeight: FontWeight.bold)),
                    const TextSpan(
                        text:
                            ' Запускается полноценное интерактивное Flutter-приложение с красивым UI, анимациями и CanvasKit-рендерингом.\n2.  '),
                    TextSpan(
                        text: 'Для пререндеринга (и поисковых роботов):',
                        style: bodyTextStyle(context)
                            .copyWith(fontWeight: FontWeight.bold)),
                    const TextSpan(
                        text:
                            ' Страница отрисовывает только специальный набор невидимых виджетов, которые генерируют семантически верное HTML-дерево (<h1>, <p>, <img> и т.д.).\n\nСигналом для переключения в режим пререндеринга служит GET-параметр в URL: '),
                    TextSpan(
                      text: '?prerender=true',
                      style: bodyTextStyle(context).copyWith(
                        fontFamily: 'monospace',
                        backgroundColor:
                            theme.colorScheme.onSurface.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const TextHeadlineSecondary(
                text: "Компонент №1: Семантические виджеты"),
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  const TextSpan(
                      text:
                          "Чтобы Flutter мог генерировать HTML-теги, были созданы специальные виджеты-обертки (`SemanticH1`, `SemanticP`, `SemanticImg`). Их задача — используя Dart-библиотеки для веба, создать реальный HTML-элемент и добавить его в DOM-дерево. Сами виджеты имеют нулевой размер и не видны пользователю. "),
                  TextSpan(
                    text: "Посмотреть код.",
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _showInfoDialog(context,
                          title: "Код SemanticWidget",
                          markdownContent:
                              "Вся магия происходит в `registerViewFactory`, который создает HTML-элемент и добавляет его клон в специальный контейнер в DOM."),
                  ),
                ],
              ),
            ),
            const CodeBlock(code: '''
// lib/components/semantic_widgets.dart
import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;
import 'dart:ui_web' as ui_web;

abstract class SemanticWidget extends StatelessWidget {
  // ... конструктор ...

  @override
  Widget build(BuildContext context) {
    if (Uri.base.queryParameters['prerender'] != 'true') {
      return const SizedBox.shrink();
    }
    // ...
    ui_web.platformViewRegistry.registerViewFactory(
      viewId,
      (int viewId) {
        final element = web.document.createElement(tag);
        element.textContent = text;
        attributes.forEach((key, value) => element.setAttribute(key, value));

        // Клонируем элемент в видимый для Puppeteer контейнер
        web.document.getElementById('prerender-container')?.append(element.cloneNode(true));

        return element;
      },
    );
    // ...
  }
}
'''),
            const TextHeadlineSecondary(
                text: "Компонент №2: Dart-скрипт для пререндеринга"),
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  const TextSpan(
                      text:
                          "Это сердце всей системы. После каждой сборки (`flutter build web`) запускается скрипт на Dart, который автоматизирует весь процесс: обходит все роуты, запускает headless-браузер, ждет генерации контента и сохраняет результат. "),
                  TextSpan(
                    text: "Посмотреть код.",
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _showInfoDialog(context,
                          title: "Ключевая часть prerender.dart",
                          markdownContent:
                              "Скрипт использует пакет `puppeteer` для управления Chrome, открывает каждую страницу с параметром `?prerender=true` и извлекает `innerHTML` из нашего специального контейнера."),
                  ),
                ],
              ),
            ),
            const CodeBlock(code: '''
// prerender_tool/prerender.dart
import 'package:puppeteer/puppeteer.dart';

// ...
await page.goto('\$baseUrl\$route?prerender=true', wait: Until.domContentLoaded);

await Future.delayed(const Duration(seconds: 5));

final prerenderedHtml = await page.evaluate<String>(r"""() => {
  const container = document.getElementById('prerender-container');
  return container ? container.innerHTML : '<!-- Container not found -->';
}""");

// ...
'''),
            const TextHeadlineSecondary(
                text: "Компонент №3: «Двухрежимная» логика на страницах"),
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  const TextSpan(
                      text:
                          "Каждая страница, которую нужно пререндерить, содержит простую условную логику. В `initState` она проверяет URL, а `build` решает, что рендерить: полноценный UI или блок с семантическими виджетами. "),
                  TextSpan(
                    text: "Посмотреть код.",
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _showInfoDialog(context,
                          title: "Пример кода страницы",
                          markdownContent:
                              "Простая, но эффективная логика, которая разделяет рендеринг для роботов и для пользователей."),
                  ),
                ],
              ),
            ),
            const CodeBlock(code: '''
// lib/pages/my_article_page.dart

class _MyArticlePageState extends State<MyArticlePage> {
  bool _isPrerendering = false;

  @override
  void initState() {
    super.initState();
    if (Uri.base.queryParameters['prerender'] == 'true') {
      setState(() => _isPrerendering = true);
    }
    // ...
  }

  Widget _buildPrerenderContent() {
    return Column(
      children: [
        SemanticH1("Мой заголовок"),
        SemanticP("Мой текст..."),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isPrerendering) {
      return _buildPrerenderContent();
    }

    return Scaffold(
      // ... Ваш обычный UI ...
    );
  }
}
'''),
            const TextHeadlineSecondary(
                text: "Финальный штрих: Конфигурация Nginx"),
            const TextBody(
                text:
                    "Последний шаг — научить веб-сервер правильно отдавать сгенерированные файлы. Nginx настраивается так, чтобы любой запрос к странице (например, `shastovsky.com/marocco`) он внутренне перенаправлял на соответствующий статический файл (`shastovsky.com/marocco/index.html`). Это делается с помощью директивы `try_files`."),
            const ImageWrapper(
                image: "assets/images/dev-guides/nginx_config_snippet.webp"),
            const TextHeadlineSecondary(text: "Результат и выводы"),
            const TextBody(
              text:
                  "Этот подход, хоть и требует ручной работы по дублированию контента в семантические виджеты, дает полный контроль над HTML, который увидят поисковые роботы. \n\nВ результате сайт на Flutter Web становится полностью SEO-дружелюбным, сохраняя при этом всю мощь и красоту интерактивного SPA для реальных пользователей. Инвестиции в настройку SSG окупаются сторицей за счет улучшения позиций в поиске и ускорения первоначальной загрузки для пользователей.",
            ),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.center,
              child: Text("Как вам статья?", style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 16),
            const Center(
                child:
                    ReactionsWidget(articleRouteName: PostFlutterSeoPage.name)),
            const SizedBox(height: 60),
            divider(context),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: TagWrapper(tags: [
                Tag(tag: "Flutter"),
                Tag(tag: "SEO"),
                Tag(tag: "Web"),
                Tag(tag: "SSG"),
                Tag(tag: "Dart"),
              ]),
            ),
            const SizedBox(height: 20),
            const ShareButtonsBlock(),
            const SizedBox(height: 40),
            const CommentsSection(articleRouteName: PostFlutterSeoPage.name),
            const SizedBox(height: 60),
            const RelatedArticles(
              currentArticleRouteName: PostFlutterSeoPage.name,
              category: 'dev',
            ),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: marginBottom40,
                child: RichText(
                  text: TextSpan(
                    style: bodyTextStyle(context),
                    children: [
                      const TextSpan(
                          text:
                              "Если вам понравился этот сайт или то, что я делаю - вы можете поддержать меня в моем телеграм канале "),
                      TextSpan(
                        text: "@shastovscky",
                        style: bodyTextStyle(context).copyWith(
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () =>
                              launchUrl(Uri.parse('https://t.me/shastovscky')),
                      ),
                      const TextSpan(
                          text: " или подписаться на меня в инстаграм "),
                      TextSpan(
                        text: "@yellolwapple",
                        style: bodyTextStyle(context).copyWith(
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchUrl(
                              Uri.parse('https://instagram.com/yellolwapple')),
                      ),
                      const TextSpan(
                          text:
                              " в нем я делюсь фото и видео из своих поездок."),
                    ],
                  ),
                ),
              ),
            ),
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
                          onPressed: () =>
                              launchUrl(Uri.parse('https://t.me/shastovscky'))),
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
                                    color: theme.colorScheme.secondary)),
                          ],
                        ),
                        style: elevatedButtonStyle(context),
                        onPressed: () => launchUrl(
                            Uri.parse('https://instagram.com/yellolwapple')),
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
                            Text('Запрещенная в РФ организация',
                                style: TextStyle(
                                    fontSize: 9,
                                    color: theme.colorScheme.secondary)),
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
                            Text('Запрещенная в РФ организация',
                                style: TextStyle(
                                    fontSize: 9,
                                    color: theme.colorScheme.secondary)),
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
                              launchUrl(Uri.parse('https://vc.ru/id1145025'))),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Breadcrumbs(items: [
                BreadcrumbItem(text: "Главная", routeName: '/'),
                BreadcrumbItem(text: "Полезное", routeName: '/useful'),
                BreadcrumbItem(text: "Разработка", routeName: '/useful/dev'),
                BreadcrumbItem(text: "Flutter Web & SEO"),
              ]),
            ),
            const SizedBox(height: 20),
            ...authorSection(
              context: context,
              imageUrl: "assets/images/avatar_default.webp",
              name: "Автор: Шастовский Даниил",
              bio:
                  "SEO-специалист, автор этого сайта. Помогаю проектам расти в поисковой выдаче, используя данные, опыт и немного магии AI.",
            ),
          ].toMaxWidthSliver(),
          SliverFillRemaining(
            hasScrollBody: false,
            child: MaxWidthBox(maxWidth: 1200, child: Container()),
          ),
          ...[
            divider(context),
            const Footer(),
          ].toMaxWidthSliver(),
        ],
      ),
    );
  }
}
