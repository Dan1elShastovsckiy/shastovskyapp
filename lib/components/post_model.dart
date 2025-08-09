class Post {
  final String id;
  final String title;
  final String previewText;
  final String imageUrl;
  final String category;
  final String content;
  final List<String> tags;
  final DateTime publishDate;

  Post({
    required this.id,
    required this.title,
    required this.previewText,
    required this.imageUrl,
    required this.category,
    required this.content,
    required this.tags,
    required this.publishDate,
  });

  // Метод для преобразования в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'previewText': previewText,
      'imageUrl': imageUrl,
      'category': category,
      'content': content,
      'tags': tags,
      'publishDate': publishDate.toIso8601String(),
    };
  }

  // Метод для создания из JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      previewText: json['previewText'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      content: json['content'],
      tags: List<String>.from(json['tags']),
      publishDate: DateTime.parse(json['publishDate']),
    );
  }
}