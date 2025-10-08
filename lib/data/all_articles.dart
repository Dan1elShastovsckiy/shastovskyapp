// /lib/data/all_articles.dart

import 'package:minimal/components/article_model.dart';
import 'package:minimal/pages/pages.dart';

// Список всех статей на сайте для вывода в разделе "Полезное" и в блоке "Другие статьи"
final List<Article> allArticles = [
  // --- DEV СТАТЬИ ---
  const Article(
    title: "Под капотом SEO-анализатора: история разработки",
    description:
        "Путь от идеи и простого прототипа до асинхронного приложения.",
    imageUrl: "assets/images/dev/seo_analyzer_story/ui_thread_isolate.webp",
    routeName: PostSeoAnalyzerDevStory.name,
    category: 'dev',
  ),
  const Article(
    title: "Flutter Web & SEO: Полное руководство",
    description: "Как сделать ваш Flutter сайт видимым для поисковых систем.",
    imageUrl: "assets/images/dev_article_1.webp", // Указываем путь к картинкам
    routeName: PostFlutterSeoPage.name,
    category: 'dev',
  ),
  const Article(
    title: "State Management в Flutter",
    description: "Обзор популярных подходов к управлению состоянием.",
    imageUrl: "assets/images/dev_article_2.webp",
    routeName: PostStateManagementPage.name,
    category: 'dev',
  ),
  const Article(
    title: "Паттерны проектирования в Dart",
    description: "Примеры использования основных паттернов.",
    imageUrl: "assets/images/dev_article_3.webp",
    routeName: DesignPatternsPage.name,
    category: 'dev',
  ),

  // --- SEO СТАТЬИ ---
  const Article(
    title: "Как собирать семантическое ядро: современный подход",
    description:
        "Забудьте про перфекционизм. Узнайте, как быстро собрать рабочее ядро и запустить его в работу.",
    imageUrl: "assets/images/seo/semantic-core-main.webp",
    routeName: SemanticCoreGuidePage.name,
    category: 'seo',
  ),
  const Article(
    title: "Всё про sitemap.xml: Как ее видят 'роботы'",
    description: "Подробный гид по sitemap.xml для новичков и профессионалов.",
    imageUrl: "assets/images/seo-guides/sitemap-main.webp",
    routeName: SitemapGuidePage.name,
    category: 'seo',
  ),
  const Article(
    title: "Полезные SEO-сервисы",
    description: "Интерактивная таблица с инструментами для SEO оптимизации.",
    imageUrl: "assets/images/seo-guides/tools_preview.webp",
    routeName: SeoToolsPage.name,
    category: 'seo',
  ),
  const Article(
    title: "SEO и AI: Как использовать нейросети",
    description: "Практическое руководство по применению AI для SEO-задач.",
    imageUrl: "assets/images/seo-ai-era/eeat_diagram.webp",
    routeName: PostSeoAiPage.name,
    category: 'seo',
  ),
  const Article(
    title: "E-E-A-T: Гид для экспертов",
    description:
        "Как прокачать экспертность, авторитетность и доверие вашего сайта.",
    imageUrl: "assets/images/seo-guides/eeat_components.webp",
    routeName: PostEeatGuidePage.name,
    category: 'seo',
  ),
  const Article(
    title: "Стратегии линкбилдинга",
    description: "Безопасные и эффективные методы получения обратных ссылок.",
    imageUrl: "assets/images/seo-guides/skyscraper_technique_flowchart.webp",
    routeName: PostLinkbuildingPage.name,
    category: 'seo',
  ),
  const Article(
    title: "Технический аудит сайта",
    description: "Пошаговый чеклист для самостоятельной проверки сайта.",
    imageUrl: "assets/images/seo-guides/techcheck_website_seo.webp",
    routeName: PostTechnicalAuditPage.name,
    category: 'seo',
  ),
  // --- TRAVEL СТАТЬИ ---
  const Article(
    title: "МАРОККО: Заблудиться, чтобы найти себя в сердце пустоты",
    description:
        "История о том, как я потерялся в лабиринте улиц Марокко. Ароматы специй, крики зазывал, скрытые риады — и уроки таксистов, которые подарила мне эта страна. Внутри статьи можно найти ПОДАРОК! […]",
    imageUrl: "assets/images/me_sachara_desert.webp",
    routeName: PostPage.name, // Используем имя класса PostPage
    category: 'travel',
  ),
  const Article(
    title: "ГРУЗИЯ: Из Батуми в Кутаиси через горы",
    description:
        "Первое знакомство с Грузией: апокалиптическая посадка в Батуми, огненная шаурма и хоррор-квест по ночным дорогам в деревню над облаками […]",
    imageUrl: "assets/images/georgia_mountains.webp",
    routeName: PostGeorgiaPage.name, // Используем имя класса PostGeorgiaPage
    category: 'travel',
  ),
];
