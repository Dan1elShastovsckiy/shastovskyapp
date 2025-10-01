// /lib/pages/pages_useful/page_semantic_core_guide.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minimal/components/related_articles.dart';
import 'package:minimal/pages/pages.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart'
    hide MaxWidthBox;
import 'package:url_launcher/url_launcher.dart';
import 'package:minimal/utils/meta_tag_service.dart';
import 'package:minimal/components/feature_tile.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SemanticCoreGuidePage extends StatefulWidget {
  static const String name = 'useful/seo/semantic-core-guide';
  const SemanticCoreGuidePage({super.key});

  @override
  State<SemanticCoreGuidePage> createState() => _SemanticCoreGuidePageState();
}

class _SemanticCoreGuidePageState extends State<SemanticCoreGuidePage> {
  final List<String> _pageImages = [
    "assets/images/seo/semantic-core-main.webp",
    "assets/images/seo/wordstat-masks.webp",
    "assets/images/seo/seo-tools-collage.webp",
    "assets/images/seo/clustering-example.webp",
    "assets/images/seo/gsc-semantics-performance.webp",
    "assets/images/avatar_default.webp",
  ];

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
    MetaTagService().updateAllTags(
      title: "Как собирать семантическое ядро? Современный подход",
      description:
          "Практическое руководство по быстрому сбору семантики. Зачем нужны маски, какие инструменты использовать и почему идеальное ядро — это миф.",
      imageUrl:
          "https://shastovsky.ru/assets/assets/images/seo/semantic-core-main.webp",
    );
  }

  @override
  Widget build(BuildContext context) {
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
                BreadcrumbItem(text: "Сбор семантики"),
              ]),
            ),
            const SizedBox(height: 40),
            Text("Как собирать семантическое ядро: современный подход",
                style: headlineTextStyle(context), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Text(
              "Забудьте про многонедельный перфекционизм. Узнайте, как быстро собрать рабочее ядро, запустить его в работу и дорабатывать на основе реальных данных.",
              style: subtitleTextStyle(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            const ImageWrapper(
                image: "assets/images/seo/semantic-core-main.webp"),
            const SizedBox(height: 20),
            const TextHeadlineSecondary(
                text: "Что такое семантическое ядро (и чем оно НЕ является)"),
            const TextBody(
              text:
                  "Если коротко, семантическое ядро (СЯ) — это упорядоченный набор поисковых запросов, описывающих вашу тематику. Но в 2025 году такой подход устарел. Давайте смотреть на СЯ проще и прагматичнее.",
            ),
            MarkdownBody(
              data:
                  "Сегодня семантическое ядро — это, в первую очередь, **инструмент для проектирования структуры сайта**. Его главная задача — помочь нам понять, какие страницы нужны пользователям, чтобы ответить на их вопросы и решить их проблемы. Это не самоцель, а средство.\n",
              selectable: true,
              styleSheet:
                  MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                p: bodyTextStyle(context),
              ),
            ),
            const TextBlockquote(
              text:
                  "Я считаю, что ядро должно собираться максимум за 1 день. Его цель — дать нам достаточно данных для контент-плана на ближайшие полгода. Всё остальное дошлифовывается в процессе.",
            ),
            const ImageWrapper(image: "assets/images/seo/wordstat-masks.webp"),
            const SizedBox(height: 20),
            const TextHeadlineSecondary(
                text: "Шаг 1: Маски — фундамент для быстрого сбора"),
            const TextBody(
              text:
                  "Чтобы не утонуть в тысячах мусорных запросов, мы не парсим широкие ключи (вроде «ремонт квартир»). Вместо этого мы используем «маски» — сочетания базового запроса с коммерческими или уточняющими добавками.",
            ),
            const FeatureTile(
              icon: Icons.vpn_key,
              title: "Формула и примеры эффективных масок",
              content: """
Для коммерческих сайтов формула проста: **[Товар/Услуга] + [Добавка]**.

**Примеры добавок:**
*   **Транзакционные:** `купить`, `цена`, `стоимость`, `заказать`, `недорого`
*   **Гео-добавки:** `спб`, `в петербурге` (или ваш город)
*   **Уточняющие:** `клиника`, `магазин`, `отзывы`, `рейтинг`

**Пример для медицинской клиники:**
Вместо парсинга «эрозия шейки матки», используем маски:
*   `эрозия матки цена`
*   `лечение эрозии спб`
*   `эрозия шейки матки клиника`
*   `прижигание эрозии матки`

**Пример для интернет-магазина:**
Вместо «швейная машинка», используем:
*   `швейная машинка janome купить`
*   `швейная машинка brother цена`
*   `оверлок спб`
*   `janome clio 200` (точное название модели — тоже маска)
""",
            ),
            const FeatureTile(
              icon: Icons.lightbulb_outline,
              title: "Где брать идеи для масок?",
              content: """
*   **Мозговой штурм:** Подумайте, как бы вы сами искали этот товар/услугу.
*   **Сайт клиента:** Изучите каталог, названия услуг и товаров.
*   **Сайты конкурентов:** Посмотрите, какие слова они используют в заголовках `<h1>`, `<h2>` и в меню.
*   **Яндекс.Вордстат:** Вбейте самый общий запрос (например, «швейная машинка») и посмотрите в правую колонку «Что еще искали» — там кладезь идей для добавок («janome», «brother», «оверлок», «компьютерная»).
""",
            ),
            const ImageWrapper(
                image: "assets/images/seo/seo-tools-collage.webp"),
            const SizedBox(height: 20),
            const TextHeadlineSecondary(text: "Шаг 2: Инструменты и парсинг"),
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  const TextSpan(
                      text:
                          "Для сбора и обработки семантики существует множество сервисов. Классический Яндекс.Вордстат — отправная точка. Для автоматизации и анализа конкурентов используются более мощные инструменты, такие как Pixel Tools, Topvisor, Rush Analytics и Semtools. Подробный список с описанием вы можете найти на моей странице "),
                  TextSpan(
                    text: "Полезные SEO-сервисы",
                    style: bodyTextStyle(context).copyWith(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () =>
                          Navigator.pushNamed(context, '/${SeoToolsPage.name}'),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const TextBody(
                text:
                    "Десктопные программы вроде Key Collector теряют актуальность, так как облачные сервисы предлагают более быстрый и комплексный анализ, включая данные по конкурентам, которые не нужно собирать вручную."),
            const ImageWrapper(
                image: "assets/images/seo/clustering-example.webp"),
            const SizedBox(height: 20),
            const TextHeadlineSecondary(
                text: "Шаг 3: Кластеризация и быстрая чистка"),
            const TextBody(
                text:
                    "Кластеризация — это группировка запросов по смыслу (пользовательскому интенту). Современные сервисы делают это автоматически, анализируя топ-10 поисковой выдачи. Если по запросам «купить диван» и «диван цена» в топе находятся одни и те же страницы, значит, эти запросы можно вести на одну страницу."),
            const FeatureTile(
              icon: Icons.cleaning_services,
              title: "Чек-лист по быстрой чистке ядра",
              content: """
1.  **Сбор очевидных стоп-слов:** Пройдитесь по 200-300 самым частотным запросам. Выпишите в отдельный файл слова, которые однозначно делают запрос нецелевым: `бесплатно`, `форум`, `своими руками`, `реферат`, `скачать`, `бу`, названия других городов и стран.
2.  **Применение списка:** Загрузите этот список стоп-слов в инструмент (например, в Key Collector или онлайн-сервисы) и удалите все фразы, содержащие эти слова.
3.  **Анализ неявного мусора:** Отсортируйте оставшиеся фразы по алфавиту. Это поможет быстро найти и удалить целые группы неявного мусора (например, запросы с артикулами конкурентов, названия брендов, которые вы не продаете).
4.  **Не увлекайтесь!** На этом этапе основная чистка закончена. Не нужно вручную просматривать тысячи низкочастотных запросов. Вы отсеете их позже.
""",
            ),
            const TextBlockquote(
              text:
                  "Не нужно вымучивать ядро до стерильного состояния. Если в кластере из 100 запросов 10 — мусорные, не тратьте время. Вы отсеете их на этапе написания ТЗ. Ваша задача — быстро получить готовые группы для создания страниц.",
            ),
            const ImageWrapper(
                image: "assets/images/seo/gsc-semantics-performance.webp"),
            const SizedBox(height: 20),
            const TextHeadlineSecondary(
                text: "Шаг 4: Доработка на основе реальных данных"),
            const TextBody(
                text:
                    "Самый ценный источник семантики — это отчеты «Эффективность» в Google Search Console и «Поисковые запросы» в Яндекс.Вебмастере. Через месяц после запуска новых страниц вы увидите сотни реальных запросов, по которым пользователи вас находят."),
            const FeatureTile(
              icon: Icons.analytics,
              title: "Почему это важнее «идеального» ядра?",
              content: """
*   **Google и Интент:** Google давно ушел от точного соответствия ключам к пониманию намерения. Ваша страница будет ранжироваться по множеству синонимов и «хвостов», которые вы никогда бы не собрали вручную. Посмотрите отчет в Google Search Console по любой вашей странице — вы увидите в 10 раз больше запросов, чем кластеризировали.
*   **Реальный спрос:** Данные из панелей вебмастеров показывают не гипотетический, а реальный спрос вашей аудитории. Расширять семантику на основе этих данных — самый эффективный путь.
*   **Экономия времени:** Время, сэкономленное на многодневной чистке ядра, лучше потратить на создание нового полезного контента или на более глубокую проработку одной конкретной страницы.
""",
            ),
            const TextHeadlineSecondary(
                text: "Выводы: новый цикл работы с семантикой"),
            // Оборачиваем MarkdownBody в тот же декоратор, что и ваш TextBlockquote
            Container(
              margin: const EdgeInsets.symmetric(vertical: 24.0),
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.5),
                border: Border(
                  left: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 4.0,
                  ),
                ),
              ),
              child: MarkdownBody(
                data:
                    "**1. Собрали максимум масок → 2. Быстро спарсили → 3. Сделали базовую чистку → 4. Сформировали контент-план (список страниц) → 5. Запустили в работу (написание ТЗ, текстов) → 6. Параллельно дорабатываем семантику для конкретных страниц → 7. Через 2-3 месяца обновляем ядро на основе реальных данных из GSC и Вебмастера.**\n\nЭтот подход позволяет получать результаты для бизнеса гораздо быстрее, что в современном SEO является ключевым фактором успеха.",
                selectable: true,
                styleSheet:
                    MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                  p: bodyTextStyle(context)
                      .copyWith(fontStyle: FontStyle.italic),
                  strong: bodyTextStyle(context).copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight:
                          FontWeight.bold), // Для жирного текста внутри цитаты
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  const TextSpan(
                      text:
                          "Подробнее про актуальные инструменты для работы с семантикой можно прочитать на странице "),
                  TextSpan(
                    text: "Полезные SEO-сервисы",
                    style: bodyTextStyle(context).copyWith(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () =>
                          Navigator.pushNamed(context, '/${SeoToolsPage.name}'),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const TagWrapper(tags: [
              Tag(tag: "SEO"),
              Tag(tag: "Семантическое ядро"),
              Tag(tag: "Key Collector"),
              Tag(tag: "Яндекс.Вордстат"),
              Tag(tag: "Стратегия"),
            ]),
            const RelatedArticles(
              currentArticleRouteName: SemanticCoreGuidePage.name,
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
                  BreadcrumbItem(text: "Сбор семантики"),
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
