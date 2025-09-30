// /lib/components/article_model.dart

// Модель статьи для раздела "Полезное" и других разделов с статьями чтобы выводить их в блоке другие статьи
class Article {
  final String title;
  final String description;
  final String imageUrl;
  final String routeName;
  final String category; // 'dev' или 'seo'

  const Article({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.routeName,
    required this.category,
  });
}
