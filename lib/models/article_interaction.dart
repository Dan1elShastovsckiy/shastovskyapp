// lib/models/article_interaction.dart

import 'package:cloud_firestore/cloud_firestore.dart';

// --- Модель для статистики статьи (реакции и просмотры) ---
class ArticleStats {
  final int viewCount;
  final Map<String, int> reactions;

  ArticleStats({this.viewCount = 0, required this.reactions});

  factory ArticleStats.fromFirestore(DocumentSnapshot doc) {
    // Безопасно получаем данные, даже если документ пустой
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};
    return ArticleStats(
      viewCount: data['viewCount'] ?? 0,
      // Преобразуем Map<dynamic, dynamic> в Map<String, int>
      reactions: Map<String, int>.from(data['reactions'] ?? {}),
    );
  }
}

// --- Модель для комментария ---
class Comment {
  final String id; // ID документа в Firestore
  final String articleRouteName;
  final String text;
  final DateTime createdAt;
  final String? authorId;
  final String authorName;
  final int likes;

  // Поля для ответов
  final String? parentId; // ID родительского комментария
  final int replyCount; // Количество ответов
  final bool isReply; // Является ли комментарий ответом

  Comment({
    required this.id,
    required this.articleRouteName,
    required this.text,
    required this.createdAt,
    this.authorId,
    required this.authorName,
    this.likes = 0,
    this.parentId,
    this.replyCount = 0,
    this.isReply = false,
  });

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};
    return Comment(
      id: doc.id,
      articleRouteName: data['articleRouteName'] ?? '',
      text: data['text'] ?? '',
      // Используем DateTime.now() как запасной вариант, если поле отсутствует
      createdAt: (data['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
      authorId: data['authorId'],
      authorName: data['authorName'] ?? 'Аноним',
      likes: data['likes'] ?? 0,
      parentId: data['parentId'],
      replyCount: data['replyCount'] ?? 0,
      isReply: data['isReply'] ?? false,
    );
  }
}
