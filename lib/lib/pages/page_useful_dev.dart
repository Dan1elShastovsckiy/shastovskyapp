// lib/pages/page_useful_dev.dart

import 'package:flutter/material.dart';
import 'package:minimal/pages/pages.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart';

class UsefulDevPage extends StatefulWidget {
  static const String name = 'useful-dev';
  const UsefulDevPage({super.key});

  @override
  State<UsefulDevPage> createState() => _UsefulDevPageState();
}

class _UsefulDevPageState extends State<UsefulDevPage> {
  final List<UsefulArticle> _allArticles = [
    UsefulArticle(
      title: "Flutter Web & SEO: Полное руководство по SSG",
      description:
          "Как настроить пререндеринг (SSG) для Flutter-сайта, чтобы он нравился поисковикам и быстро загружался...",
      imageUrl: "assets/images/dev_article_1.webp",
      tags: ["Flutter", "SEO"],
      routeName: PageUnderConstruction.name,
    ),
    UsefulArticle(
      title: "State Management в Flutter: Какой выбрать в 2025?",
      description:
          "Provider, BLoC, Riverpod, GetX... Разбираем плюсы и минусы каждого подхода на реальных примерах.",
      imageUrl: "assets/images/dev_article_2.webp",
      tags: ["Flutter", "Архитектура"],
      routeName: PageUnderConstruction.name,
    ),
  ];

  late List<UsefulArticle> _filteredArticles;
  String _selectedTag = "Все материалы";
  final List<String> _allTags = [
    "Все материалы",
    "Flutter",
    "Архитектура",
    "SEO"
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
            Text("Полезное / Разработка",
                style: headlineTextStyle, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Text("Статьи по Flutter, Dart и веб-технологиям",
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
