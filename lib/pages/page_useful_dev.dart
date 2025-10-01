// lib/pages/page_useful_dev.dart

import 'package:flutter/material.dart';
import 'package:minimal/pages/pages.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:minimal/utils/meta_tag_service.dart'; // <<< ИМПОРТ ДЛЯ МЕТА-ТЕГОВ

class UsefulDevPage extends StatefulWidget {
  static const String name = 'useful/dev';
  const UsefulDevPage({super.key});

  @override
  State<UsefulDevPage> createState() => _UsefulDevPageState();
}

class _UsefulDevPageState extends State<UsefulDevPage> {
  final List<UsefulArticle> _allArticles = [
    UsefulArticle(
      title: "Паттерны проектирования: Интерактивная галерея",
      description:
          "Изучайте паттерны в игровом стиле. Тапните на Singleton, Factory или Observer, чтобы увидеть код и простое объяснение...",
      imageUrl: "assets/images/dev_article_3.webp",
      tags: ["Flutter", "Архитектура", "Паттерны"],
      routeName: DesignPatternsPage.name,
    ),
    UsefulArticle(
      title: "Flutter Web & SEO: Полное руководство по SSG",
      description:
          "Как настроить пререндеринг (SSG) для Flutter-сайта, чтобы он нравился поисковикам и быстро загружался...",
      imageUrl: "assets/images/dev_article_1.webp",
      tags: ["Flutter", "SEO"],
      routeName: PostFlutterSeoPage.name,
    ),
    UsefulArticle(
      title: "State Management в Flutter: Какой выбрать в 2025?",
      description:
          "Provider, BLoC, Riverpod, GetX... Разбираем плюсы и минусы каждого подхода на реальных примерах.",
      imageUrl: "assets/images/dev_article_2.webp",
      tags: ["Flutter", "Архитектура"],
      routeName: PostStateManagementPage.name,
    ),
  ];

  late List<UsefulArticle> _filteredArticles;
  String _selectedTag = "Все материалы";
  final List<String> _allTags = [
    "Все материалы",
    "Flutter",
    "Архитектура",
    "SEO",
    "Паттерны"
  ];

  @override
  void initState() {
    super.initState();
    _filteredArticles = _allArticles;

    // <<< ДОБАВЛЕН БЛОК С МЕТА-ТЕГАМИ >>>
    MetaTagService().updateAllTags(
      title: "Разработка | Статьи о Flutter, Dart и веб-технологиях",
      description:
          "Гайды, обзоры и практические советы по веб-разработке. Фокус на Flutter Web, Dart, SEO-аспектах и лучших практиках.",
      imageUrl:
          "https://shastovsky.ru/assets/assets/images/flutter_logo.webp", // Убедитесь, что картинка существует
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
                  BreadcrumbItem(text: "Разработка"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text("Статьи по Flutter, Dart и веб-технологиям",
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
