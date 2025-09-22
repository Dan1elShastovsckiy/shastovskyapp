// lib/pages/page_useful_seo.dart

import 'package:flutter/material.dart';
import 'package:minimal/pages/pages.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/pages/page_under_construction.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
  static const String name = 'useful-seo';
  const UsefulSeoPage({super.key});

  @override
  State<UsefulSeoPage> createState() => _UsefulSeoPageState();
}

class _UsefulSeoPageState extends State<UsefulSeoPage> {
  // <<< ЗАМЕНИТЕ ЭТОТ СПИСОК ЦЕЛИКОМ >>>
  final List<UsefulArticle> _allArticles = [
    UsefulArticle(
      title: "SEO в Эпоху ИИ: Новые Правила Ранжирования",
      description:
          "Глубокое погружение в неочевидные факторы ранжирования, утечки Google и практические шаги для оптимизации в эру AI Overviews...",
      imageUrl: "assets/images/seo-ai-era/eeat_diagram.webp",
      tags: ["Ai Seoшка"], // <-- ИЗМЕНЕНИЕ ЗДЕСЬ
      routeName: PostSeoAiPage.name,
    ),
    UsefulArticle(
      title: "Полное руководство по E-E-A-T в 2025 году",
      description:
          "Как доказать Google свою экспертизу, опыт и авторитетность. Практические шаги и примеры...",
      imageUrl: "assets/images/seo_article_1.webp",
      tags: ["E-E-A-T", "Внутренняя оптимизация"],
      routeName: PageUnderConstruction.name,
    ),
    UsefulArticle(
      title: "Стратегии линкбилдинга для сложных ниш",
      description:
          "Где брать качественные ссылки, когда все конкуренты уже везде? Методы, которые работают сегодня...",
      imageUrl: "assets/images/seo_article_2.webp",
      tags: ["Внешняя оптимизация"],
      routeName: PageUnderConstruction.name,
    ),
    UsefulArticle(
      title: "Технический аудит сайта: пошаговый чек-лист",
      description:
          "От скорости загрузки до лог-файлов. Находим и исправляем ошибки, которые мешают росту...",
      imageUrl: "assets/images/seo_article_3.webp",
      tags: ["Техническое SEO", "Внутренняя оптимизация"],
      routeName: PageUnderConstruction.name,
    ),
  ];

  late List<UsefulArticle> _filteredArticles;
  String _selectedTag = "Все материалы";
  // <<< ЗАМЕНИТЕ ЭТОТ СПИСОК ЦЕЛИКОМ >>>
  final List<String> _allTags = [
    "Все материалы",
    "Ai Seoшка", // <-- ИЗМЕНЕНИЕ ЗДЕСЬ
    "Внутренняя оптимизация",
    "Внешняя оптимизация",
    "E-E-A-T",
    "Техническое SEO"
  ];

  @override
  void initState() {
    super.initState();
    _filteredArticles = _allArticles;
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

    return Scaffold(
      drawer: isMobile ? buildAppDrawer(context) : null,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),
      body: CustomScrollView(
        slivers: [
          ...[
            const SizedBox(height: 40),
            /*const Align(
              alignment: Alignment.centerLeft,
              child: Breadcrumbs(
                items: [
                  BreadcrumbItem(text: "Главная", routeName: '/'),
                  BreadcrumbItem(
                      text: "Полезное",
                      routeName: '/${UsefulPage.name}'), // Ссылка на разводящую
                  BreadcrumbItem(text: "SEO"), // Текущая страница
                ],
              ),
            ),*/
            Text("Полезное / SEO",
                style: headlineTextStyle, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Text("Статьи по поисковой оптимизации",
                style: subtitleTextStyle, textAlign: TextAlign.center),
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
                    backgroundColor: Colors.white,
                    selectedColor: textPrimary,
                    labelStyle: TextStyle(
                        color: isSelected ? Colors.white : textPrimary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: textPrimary)),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            divider,
          ].toMaxWidthSliver(),
          SliverList.list(
            children: [
              if (_filteredArticles.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 80.0),
                  child: Center(
                      child: Text(
                    "Материалов по этому тегу пока нет...",
                    style: subtitleTextStyle,
                  )),
                )
              else
                ..._filteredArticles.expand((article) => [
                      ListItem(
                        imageUrl: article.imageUrl,
                        title: article.title,
                        description:
                            Text(article.description, style: bodyTextStyle),
                        onReadMore: () => Navigator.pushNamed(
                          context,
                          '/${article.routeName}',
                          arguments: {'title': article.title},
                        ),
                      ),
                      divider,
                    ]),
              const SizedBox(height: 80),
            ].toMaxWidth(),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: MaxWidthBox(
                maxWidth: 1200,
                backgroundColor: Colors.white,
                child: Container()),
          ),
          ...[
            divider,
            const Footer(),
          ].toMaxWidthSliver(),
        ],
      ),
    );
  }
}
