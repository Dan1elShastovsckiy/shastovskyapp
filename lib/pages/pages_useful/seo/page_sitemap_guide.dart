// /lib/pages/pages_useful/page_sitemap_guide.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:minimal/components/comments_section.dart';
import 'package:minimal/components/reactions_widget.dart';
import 'package:minimal/components/related_articles.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/components/share_buttons_block.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart'
    hide MaxWidthBox;
import 'package:url_launcher/url_launcher.dart';
import 'package:minimal/utils/meta_tag_service.dart';
import 'package:minimal/components/feature_tile.dart';
import 'package:intl/intl.dart';
// <<< ШАГ 1: Добавляем импорт семантических виджетов >>>
import 'package:minimal/components/semantic_widgets.dart';

class SitemapGuidePage extends StatefulWidget {
  static const String name = 'useful/seo/sitemap-guide';
  const SitemapGuidePage({super.key});

  @override
  State<SitemapGuidePage> createState() => _SitemapGuidePageState();
}

class _SitemapGuidePageState extends State<SitemapGuidePage> {
  // Список изображений для предварительного кэширования
  final List<String> _pageImages = [
    "assets/images/seo-guides/sitemap-main.webp",
    "assets/images/seo-guides/sitemap-structure.webp",
    "assets/images/seo-guides/sitemap-tools.webp",
    "assets/images/seo-guides/sitemap-index.webp",
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
      title: "Всё про sitemap.xml: Как ее видят 'роботы'",
      description:
          "Что такое XML-карта сайта, как ее создать, настроить и проверить на ошибки. Подробный гид по sitemap.xml для новичков и профессионалов.",
      imageUrl:
          "https://shastovsky.com/assets/assets/images/seo-guides/sitemap-main.webp",
    );
  }

  // <<< ШАГ 4: Новый метод для генерации семантического контента >>>
  Widget _buildPrerenderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SemanticH1("Всё про sitemap.xml: Полное руководство"),
        SemanticP(
            "Пошаговый гид по созданию, настройке и проверке XML-карты сайта для улучшения индексации поисковыми системами."),
        SemanticImg(
            src: "assets/images/seo-guides/sitemap-main.webp",
            alt: "Карта сайта sitemap.xml"),
        SemanticH2("Что такое sitemap.xml и зачем он нужен?"),
        SemanticP(
            "Представьте, что ваш сайт — это большой город, а поисковый робот (например, Googlebot) — это турист, который хочет посетить все интересные места. XML-карта сайта (sitemap) — это подробная карта этого города, которую вы вручаете туристу на входе. Она содержит прямые ссылки на все важные страницы, которые вы хотите, чтобы он посетил и добавил в свой путеводитель (поисковый индекс).\n\nХотя поисковые системы могут найти ваши страницы и без карты, sitemap помогает им сделать это быстрее, эффективнее и не пропустить ничего важного, особенно на больших и сложных сайтах."),
        SemanticImg(
            src: "assets/images/seo-guides/sitemap-structure.webp",
            alt: "Структура файла sitemap.xml"),
        SemanticH2("Из чего состоит XML-карта?"),
        SemanticP(
            "Файл sitemap.xml имеет строгую структуру. Разбор тегов: <urlset> - обертка, <url> - контейнер для страницы, <loc> - ссылка на страницу, <lastmod> - дата изменения, <changefreq> - частота обновления, <priority> - важность страницы. Для небольших сайтов достаточно указывать только <loc>."),
        SemanticH2("Технические требования и частые ошибки"),
        SemanticP(
            "Чтобы ваша карта сайта работала правильно, она должна соответствовать ряду технических правил. Ошибки в этих правилах — самая частая причина, по которой поисковики игнорируют sitemap."),
        SemanticP(
            "Чек-лист: 11 правил для идеального Sitemap:\n1. Формат: XML в кодировке UTF-8.\n2. Лимит страниц: Не более 50 000 URL в одном файле.\n3. Лимит размера: Не более 50 МБ.\n4. Расположение: В корне сайта.\n5. Абсолютные URL: Все ссылки должны быть полными.\n6. Код ответа 200: Все страницы должны открываться.\n7. Только канонические URL.\n8. Никаких noindex.\n9. Никаких блокировок в robots.txt.\n10. Сам sitemap должен быть открыт в robots.txt.\n11. Никакого мусора: без страниц пагинации, поиска, корзины."),
        SemanticImg(
            src: "assets/images/seo-guides/sitemap-tools.webp",
            alt: "Инструменты для создания sitemap"),
        SemanticH2("Как создать, внедрить и проверить Sitemap?"),
        SemanticP(
            "1. Создание карты сайта: Используйте плагины CMS (лучший способ), онлайн-генераторы для небольших сайтов, или десктопные парсеры, как Netpeak Spider или Screaming Frog."),
        SemanticP(
            "2. Внедрение на сайт: Загрузите файл в корень сайта. Добавьте директиву `Sitemap: https://example.com/sitemap.xml` в файл robots.txt. Добавьте ссылку на sitemap в панели вебмастеров Google и Яндекс."),
        SemanticP(
            "Проверка на ошибки: И Google Search Console, и Яндекс.Вебмастер имеют встроенные инструменты для анализа sitemap. Они покажут ошибки и помогут их исправить."),
        SemanticImg(
            src: "assets/images/seo-guides/sitemap-index.webp",
            alt: "Индексный файл sitemap"),
        SemanticH2("Особые случаи: картинки, языки и большие сайты"),
        SemanticP(
            "Карта сайта для изображений: Помогает улучшить индексацию картинок и получить дополнительный трафик из поиска по изображениям."),
        SemanticP(
            "Карта для мультиязычных сайтов: Помогает Google правильно показывать пользователям нужную языковую версию с помощью тега xhtml:link."),
        SemanticP(
            "Индексный sitemap для больших сайтов: Если на сайте больше 50 000 страниц, их нужно разбить на несколько файлов sitemap и объединить в одном индексном файле."),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // <<< ШАГ 5: Добавляем условную логику в метод build >>>
    if (_isPrerendering) {
      return Material(
          child: SingleChildScrollView(child: _buildPrerenderContent()));
    }

    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final theme = Theme.of(context);

    return Scaffold(
      drawer: isMobile ? buildAppDrawer(context) : null,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),
      body: CustomScrollView(
        slivers: [
          ...[
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Breadcrumbs(items: [
                BreadcrumbItem(text: "Главная", routeName: '/'),
                BreadcrumbItem(text: "Полезное", routeName: '/useful'),
                BreadcrumbItem(text: "SEO", routeName: '/useful/seo'),
                BreadcrumbItem(text: "Всё про sitemap.xml"),
              ]),
            ),
            const SizedBox(height: 40),
            // <<< НОВЫЙ БЛОК ЗАГОЛОВКА >>>
            Center(
              child: Text(
                DateFormat.yMMMMd('ru_RU')
                    .format(DateTime(2025, 09, 28)), // Укажите вашу дату
                style: bodyTextStyle(context).copyWith(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text("Всё про sitemap.xml: Полное руководство",
                style: headlineTextStyle(context), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  "~12 минут чтения", // Укажите ваше время
                  style: subtitleTextStyle(context)
                      .copyWith(fontStyle: FontStyle.italic, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Пошаговый гид по созданию, настройке и проверке XML-карты сайта для улучшения индексации поисковыми системами.",
              style: subtitleTextStyle(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            const ImageWrapper(
                image: "assets/images/seo-guides/sitemap-main.webp"),
            const SizedBox(height: 20),
            const TextHeadlineSecondary(
                text: "Что такое sitemap.xml и зачем он нужен?"),
            const TextBody(
              text:
                  "Представьте, что ваш сайт — это большой город, а поисковый робот (например, Googlebot) — это турист, который хочет посетить все интересные места. XML-карта сайта (sitemap) — это подробная карта этого города, которую вы вручаете туристу на входе. Она содержит прямые ссылки на все важные страницы, которые вы хотите, чтобы он посетил и добавил в свой путеводитель (поисковый индекс).\n\nХотя поисковые системы могут найти ваши страницы и без карты, sitemap помогает им сделать это быстрее, эффективнее и не пропустить ничего важного, особенно на больших и сложных сайтах.",
            ),
            const ImageWrapper(
                image: "assets/images/seo-guides/sitemap-structure.webp"),
            const SizedBox(height: 20),
            const TextHeadlineSecondary(text: "Из чего состоит XML-карта?"),
            const TextBody(
              text:
                  "Файл sitemap.xml имеет строгую структуру. Давайте разберем его на примере одной страницы:",
            ),
            const CodeBlock(code: '''
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
     <loc>https://example.com/page-1</loc>
     <lastmod>2025-09-30</lastmod>
     <changefreq>weekly</changefreq>
     <priority>0.8</priority>
  </url>
</urlset>
'''),
            const FeatureTile(
              icon: Icons.code,
              title: "Разбор тегов",
              content:
                  "• `<urlset>`: Обязательная обертка для всего файла.\n• `<url>`: Контейнер для информации об одной странице.\n• `<loc>`: Самое важное — прямая, полная ссылка на страницу.\n• `<lastmod>`: (Необязательно) Дата последнего изменения. Помогает роботам понять, нужно ли пересканировать страницу.\n• `<changefreq>`: (Необязательно) Подсказка, как часто страница обновляется (daily, weekly, monthly).\n• `<priority>`: (Необязательно) Важность страницы от 0.0 до 1.0. Помогает роботу определить приоритет сканирования.",
            ),
            const FeatureTile(
              icon: Icons.help_outline,
              title: "Нужны ли мне все эти теги?",
              content:
                  "Для небольших сайтов (до 500 страниц) достаточно указывать только `<loc>`. Поисковые системы и так отлично справятся.\n\nДля крупных сайтов (интернет-магазины, новостные порталы) теги `<lastmod>`, `<changefreq>` и `<priority>` становятся важными инструментами. Они помогают направить краулинговый бюджет (лимит страниц, которые робот сканирует за один визит) на самые важные и свежие страницы.",
            ),
            const TextHeadlineSecondary(
                text: "Технические требования и частые ошибки"),
            const TextBody(
              text:
                  "Чтобы ваша карта сайта работала правильно, она должна соответствовать ряду технических правил. Ошибки в этих правилах — самая частая причина, по которой поисковики игнорируют sitemap.",
            ),
            const FeatureTile(
              icon: Icons.rule,
              title: "Чек-лист: 11 правил для идеального Sitemap",
              content:
                  "1.  **Формат:** XML в кодировке UTF-8. Допускается и простой .txt со списком URL.\n"
                  "2.  **Лимит страниц:** Не более 50 000 URL в одном файле.\n"
                  "3.  **Лимит размера:** Не более 50 МБ в несжатом виде.\n"
                  "4.  **Расположение:** Файл должен лежать в корне сайта (`https://example.com/sitemap.xml`).\n"
                  "5.  **Абсолютные URL:** Все ссылки должны быть полными, с `https://`.\n"
                  "6.  **Код ответа 200:** Все страницы в карте должны открываться и отдавать код 200 OK.\n"
                  "7.  **Только канонические URL:** Включайте только основные версии страниц, без дублей.\n"
                  "8.  **Никаких `noindex`:** Страницы не должны быть закрыты от индексации в мета-тегах.\n"
                  "9.  **Никаких `robots.txt`:** Страницы не должны быть заблокированы в файле `robots.txt`.\n"
                  "10. **Сам sitemap открыт:** Убедитесь, что сам файл `sitemap.xml` не закрыт в `robots.txt`.\n"
                  "11. **Никакого мусора:** Не включайте страницы пагинации, поиска, корзины, личного кабинета.",
            ),
            const ImageWrapper(
                image: "assets/images/seo-guides/sitemap-tools.webp"),
            // НОВЫЙ КОД:
            const SizedBox(height: 20),
            const TextHeadlineSecondary(
                text: "Как создать, внедрить и проверить Sitemap?"),
            const SizedBox(height: 16),

// Используем один MarkdownBody для всей секции
            MarkdownBody(
              data: """
### 1. Создание карты сайта

• **Плагины CMS:** Лучший способ. Для WordPress, Joomla, Tilda и др. существуют плагины, которые создают и автоматически обновляют sitemap при добавлении новых страниц.

• **Онлайн-генераторы:** Подойдут для небольших статичных сайтов. Популярные сервисы: `xml-sitemaps.com`, `mysitemapgenerator.com`.

• **Десктопные парсеры:** Программы вроде Netpeak Spider или Screaming Frog могут просканировать сайт и сгенерировать sitemap на основе найденных страниц.

### 2. Внедрение на сайт
  
  
1.  **Загрузите** файл `sitemap.xml` в корневую папку вашего сайта.

2.  **Добавьте** директиву в файл `robots.txt`, указав путь к карте:
    ```
    Sitemap: https://example.com/sitemap.xml
    ```

3.  **Добавьте** ссылку на sitemap в панели вебмастеров (Google Search Console и Яндекс.Вебмастер). Это самый надежный способ сообщить поисковикам о вашей карте.
""",
              selectable: true,
              styleSheet:
                  MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                p: bodyTextStyle(
                    context), // Стиль для обычного текста (параграфов)
                h3: headlineSecondaryTextStyle(context)
                    .copyWith(fontSize: 20), // Стиль для подзаголовков ###
                listBullet:
                    bodyTextStyle(context), // Стиль для маркеров списка • и 1.
                code: bodyTextStyle(context).copyWith(
                  // Стиль для `кода`
                  fontFamily: 'monospace',
                  backgroundColor:
                      Theme.of(context).colorScheme.surface.withOpacity(0.8),
                ),
                codeblockDecoration: BoxDecoration(
                  // Стиль для блока кода ```
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                codeblockPadding: const EdgeInsets.all(16),
              ),
            ),
            const FeatureTile(
              icon: Icons.check_circle_outline,
              title: "Проверка на ошибки",
              content:
                  "И Google Search Console, и Яндекс.Вебмастер имеют встроенные инструменты для анализа sitemap. Они покажут, смог ли робот прочитать файл, сколько URL он нашел и какие ошибки обнаружил (например, ссылки на 404 страницы или заблокированные URL). Регулярно проверяйте эти отчеты!",
            ),
            const ImageWrapper(
                image: "assets/images/seo-guides/sitemap-index.webp"),
            const SizedBox(height: 20),
            const TextHeadlineSecondary(
                text: "Особые случаи: картинки, языки и большие сайты"),
            const FeatureTile(
              icon: Icons.collections,
              title: "Карта сайта для изображений",
              content:
                  "Для Google можно создать отдельный sitemap для изображений. Это помогает улучшить индексацию картинок и получить дополнительный трафик из поиска по изображениям. Особенно актуально для фотографов, интернет-магазинов и сайтов о дизайне.",
            ),
            const FeatureTile(
              icon: Icons.translate,
              title: "Карта для мультиязычных сайтов",
              content:
                  "Если у вашего сайта есть версии на разных языках (например, example.com/en/ и example.com/ru/), в sitemap можно указать связи между ними с помощью тега `xhtml:link`. Это помогает Google правильно показывать пользователям нужную языковую версию.",
            ),
            const FeatureTile(
              icon: Icons.splitscreen,
              title: "Индексный sitemap для больших сайтов",
              content:
                  "Если на вашем сайте больше 50 000 страниц, вы должны разбить их на несколько файлов sitemap (например, по категориям). Затем создается один главный, индексный sitemap, который содержит ссылки на все остальные. Это как оглавление для ваших карт.",
            ),
            const SizedBox(height: 40),
            // <<< НОВЫЙ БЛОК: Реакции >>>
            const Align(
              alignment: Alignment.center,
              child: Text("Как вам статья?", style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 16),
            const Center(
              child: ReactionsWidget(
                articleRouteName: SitemapGuidePage.name,
              ),
            ),
            const SizedBox(height: 60),
            divider(context),
            const SizedBox(height: 20),
            const TagWrapper(tags: [
              Tag(tag: "SEO"),
              Tag(tag: "Индексация"),
              Tag(tag: "Google"),
              Tag(tag: "Яндекс"),
              Tag(tag: "Техническое SEO"),
            ]),
            const SizedBox(height: 20),
            const ShareButtonsBlock(), // <<< ДОБАВЛЕН ВИДЖЕТ ДЛЯ КНОПОК ПОДЕЛИТЬСЯ >>>
            const SizedBox(height: 40),
            // <<< НОВЫЙ БЛОК: Комментарии >>>
            const CommentsSection(
              articleRouteName: SitemapGuidePage.name,
            ),
            const SizedBox(height: 60),
            // <<< ВИДЖЕТ ДЛЯ ПОКАЗА СВЯЗАННЫХ СТАТЕЙ >>>
            const RelatedArticles(
              currentArticleRouteName: SitemapGuidePage.name,
              category: 'seo',
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
                            "Если вам понравилась эта статья или то, что я делаю - вы можете поддержать меня в моем телеграм канале ",
                      ),
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
                                        color: theme.colorScheme.secondary))
                              ]),
                          style: elevatedButtonStyle(context),
                          onPressed: () => launchUrl(
                              Uri.parse('https://instagram.com/yellolwapple'))),
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
                          onPressed: () => launchUrl(
                              Uri.parse('https://www.youtube.com/@itsmyadv'))),
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
              child: Breadcrumbs(
                items: [
                  BreadcrumbItem(text: "Главная", routeName: '/'),
                  BreadcrumbItem(text: "Полезное", routeName: '/useful'),
                  BreadcrumbItem(text: "SEO", routeName: '/useful/seo'),
                  BreadcrumbItem(text: "Всё про sitemap.xml"),
                ],
              ),
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
            child: MaxWidthBox(
              maxWidth: 1200,
              child: Container(),
            ),
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
