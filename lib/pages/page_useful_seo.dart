// lib/pages/page_useful_seo.dart

import 'package:flutter/material.dart';
import 'package:minimal/pages/pages.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:minimal/utils/meta_tag_service.dart'; // <<< ИМПОРТ ДЛЯ МЕТА-ТЕГОВ

class UsefulArticle {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> tags;
  final String routeName;

  UsefulArticle({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.tags,
    required this.routeName,
  });
}

class UsefulSeoPage extends StatefulWidget {
  static const String name = 'useful/seo';
  const UsefulSeoPage({super.key});

  @override
  State<UsefulSeoPage> createState() => _UsefulSeoPageState();
}

class _UsefulSeoPageState extends State<UsefulSeoPage> {
  final List<UsefulArticle> _allArticles = [
    UsefulArticle(
      title: "Как собирать семантическое ядро: современный подход",
      description:
          "Забудьте про перфекционизм. Узнайте, как быстро собрать рабочее ядро, запустить его в работу и дорабатывать на основе реальных данных...",
      imageUrl: "assets/images/seo/semantic-core-main.webp",
      tags: ["Внутренняя оптимизация", "Семантика"],
      routeName: SemanticCoreGuidePage.name,
    ),
    UsefulArticle(
      title: "Всё про sitemap.xml: Как ее видят 'роботы'",
      description:
          "Что такое XML-карта сайта, как ее создать, настроить и проверить на ошибки. Подробный гид по sitemap.xml для новичков и профессионалов...",
      imageUrl: "assets/images/seo-guides/sitemap-main.webp",
      tags: ["Техническое SEO", "Индексация"],
      routeName: SitemapGuidePage.name,
    ),
    UsefulArticle(
      title: "Полезные SEO-сервисы",
      description:
          "Интерактивная таблица с инструментами для внутренней, внешней и технической оптимизации, которые я использую в работе каждый день...",
      imageUrl: "assets/images/seo-guides/tools_preview.webp",
      tags: ["Инструменты"],
      routeName: SeoToolsPage.name,
    ),
    UsefulArticle(
      title: "SEO в эпоху ИИ: Новые правила ранжирования",
      description:
          "Глубокое погружение в неочевидные факторы ранжирования, утечки Google и практические шаги для оптимизации в эру AI Overviews...",
      imageUrl: "assets/images/seo-ai-era/eeat_diagram.webp",
      tags: ["Ai Seoшка", "E-E-A-T", "Внутренняя оптимизация"],
      routeName: PostSeoAiPage.name,
    ),
    UsefulArticle(
      title: "Полное руководство по E-E-A-T в 2025 году",
      description:
          "Как доказать Google свою экспертизу, опыт и авторитетность. Практические шаги и примеры...",
      imageUrl: "assets/images/seo-guides/eeat_components.webp",
      tags: ["E-E-A-T", "Внутренняя оптимизация"],
      routeName: PostEeatGuidePage.name,
    ),
    UsefulArticle(
      title: "Стратегии линкбилдинга для сложных ниш",
      description:
          "Где брать качественные ссылки, когда все конкуренты уже везде? Методы, которые работают сегодня...",
      imageUrl: "assets/images/seo-guides/skyscraper_technique_flowchart.webp",
      tags: ["Внешняя оптимизация"],
      routeName: PostLinkbuildingPage.name,
    ),
    UsefulArticle(
      title: "Технический аудит сайта: пошаговый чек-лист",
      description:
          "От скорости загрузки до лог-файлов. Находим и исправляем ошибки, которые мешают росту...",
      imageUrl: "assets/images/seo-guides/techcheck_website_seo.webp",
      tags: ["Техническое SEO", "Внутренняя оптимизация"],
      routeName: PostTechnicalAuditPage.name,
    ),
  ];

  late List<UsefulArticle> _filteredArticles;
  String _selectedTag = "Все материалы";
  final List<String> _allTags = [
    "Все материалы",
    "Инструменты",
    "Ai Seoшка",
    "Внутренняя оптимизация",
    "Внешняя оптимизация",
    "E-E-A-T",
    "Техническое SEO",
    "Индексация",
    "Семантика"
  ];

  @override
  void initState() {
    super.initState();
    _filteredArticles = _allArticles;

    // <<< ДОБАВЛЕН БЛОК С МЕТА-ТЕГАМИ >>>
    MetaTagService().updateAllTags(
      title: "SEO | Статьи о поисковой оптимизации",
      description:
          "Все о SEO: технический аудит, линкбилдинг, работа с семантикой, E-E-A-T и влияние AI на поисковые системы. Практические руководства и чек-листы.",
      imageUrl:
          "https://shastovsky.ru/assets/assets/images/seo_main.webp", // Убедитесь, что картинка существует
    );
  }

  void _filterArticles(String tag) {
    setState(() {
      _selectedTag = tag;
      if (tag == "Все материалы") {
        _filteredArticles = _allArticles;
      } else {
        _filteredArticles = _allArticles
            .where((article) => article.tags.contains(tag))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
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
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Breadcrumbs(
                items: [
                  BreadcrumbItem(text: "Главная", routeName: '/'),
                  BreadcrumbItem(
                      text: "Полезное", routeName: '/${UsefulPage.name}'),
                  BreadcrumbItem(text: "SEO"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text("Статьи по поисковой оптимизации",
                style: subtitleTextStyle(context), textAlign: TextAlign.center),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: _allTags.map((tag) {
                  final isSelected = _selectedTag == tag;
                  return ChoiceChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (selected) => _filterArticles(tag),
                    backgroundColor: theme.colorScheme.surface,
                    selectedColor: theme.colorScheme.primary,
                    labelStyle: TextStyle(
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: theme.colorScheme.primary)),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            divider(context),
          ].toMaxWidthSliver(),
          SliverList.list(
            children: [
              if (_filteredArticles.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 80.0),
                  child: Center(
                      child: Text(
                    "Материалов по этому тегу пока нет...",
                    style: subtitleTextStyle(context),
                  )),
                )
              else
                ..._filteredArticles.expand((article) => [
                      ListItem(
                        imageUrl: article.imageUrl,
                        title: article.title,
                        description: Text(article.description,
                            style: bodyTextStyle(context)),
                        onReadMore: () => Navigator.pushNamed(
                          context,
                          '/${article.routeName}',
                          arguments: {'title': article.title},
                        ),
                      ),
                      divider(context),
                    ]),
              const SizedBox(height: 80),
            ].toMaxWidth(),
          ),
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
