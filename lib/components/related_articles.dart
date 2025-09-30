// /lib/components/related_articles.dart

import 'package:flutter/material.dart';
import 'package:minimal/components/article_model.dart';
import 'package:minimal/data/all_articles.dart';
import 'package:minimal/components/components.dart'; // Для headlineSecondaryTextStyle
import 'package:responsive_framework/responsive_framework.dart';

class RelatedArticles extends StatelessWidget {
  final String currentArticleRouteName;
  final String category; // 'dev' или 'seo'

  const RelatedArticles({
    super.key,
    required this.currentArticleRouteName,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Фильтруем статьи:
    //    - Оставляем только статьи из нужной категории
    //    - Исключаем текущую открытую статью
    // 1. Фильтруем статьи по категории и исключаем текущую
    final filteredArticles = allArticles
        .where((article) =>
            article.category == category &&
            article.routeName != currentArticleRouteName)
        .toList(); // Преобразуем в изменяемый список

// 2. Перемешиваем отфильтрованный список
    filteredArticles.shuffle();

// 3. Берем первые 3 статьи из перемешанного списка
    final related = filteredArticles.take(3).toList();

    if (related.isEmpty) {
      return const SizedBox
          .shrink(); // Если нет других статей, ничего не показываем
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        divider(context),
        const SizedBox(height: 40),
        Text("Другие полезные статьи",
            style: headlineSecondaryTextStyle(context)),
        const SizedBox(height: 24),
        ResponsiveRowColumn(
          layout: ResponsiveBreakpoints.of(context).smallerThan(TABLET)
              ? ResponsiveRowColumnType.COLUMN
              : ResponsiveRowColumnType.ROW,
          rowSpacing: 24,
          columnSpacing: 24,
          children: related.map((article) {
            return ResponsiveRowColumnItem(
              rowFlex: 1,
              child: _ArticleCard(article: article),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// Внутренний виджет для отображения одной карточки статьи
class _ArticleCard extends StatelessWidget {
  final Article article;
  const _ArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/${article.routeName}'),
      hoverColor: theme.colorScheme.surface.withAlpha(50),
      borderRadius: BorderRadius.circular(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                article.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: Colors.grey[200]),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            article.title,
            style: bodyTextStyle(context).copyWith(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            article.description,
            style: subtitleTextStyle(context),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
