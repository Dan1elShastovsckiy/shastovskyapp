// lib/services/interaction_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minimal/models/article_interaction.dart';

class InteractionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // <<< НОВОЕ: Приватная функция для кодирования ID >>>
  // Она заменяет все '/' на '--' (два дефиса, чтобы избежать случайных совпадений)
  String _encodeArticleId(String routeName) {
    return routeName.replaceAll('/', '--');
  }

  // --- РЕАКЦИИ ---

  Stream<ArticleStats> getArticleStats(String articleRouteName) {
    // <<< ИЗМЕНЕНИЕ: Используем закодированный ID >>>
    final docId = _encodeArticleId(articleRouteName);
    return _db
        .collection('article_stats')
        .doc(docId) // Используем безопасный ID
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return ArticleStats.fromFirestore(snapshot);
      }
      return ArticleStats(reactions: {});
    });
  }

  Future<void> updateReaction(
      String articleRouteName, String reaction, bool increment) async {
    // <<< ИЗМЕНЕНИЕ: Используем закодированный ID >>>
    final docId = _encodeArticleId(articleRouteName);
    final docRef = _db.collection('article_stats').doc(docId);

    // Используем транзакцию, как и раньше, она надежна
    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        transaction.set(docRef, {
          'reactions': {reaction: 1}
        });
      } else {
        final currentReactions =
            Map<String, int>.from(snapshot.data()?['reactions'] ?? {});
        final currentCount = currentReactions[reaction] ?? 0;
        currentReactions[reaction] = currentCount + (increment ? 1 : -1);

        transaction.update(docRef, {'reactions': currentReactions});
      }
    });
  }

  // --- КОММЕНТАРИИ ---

  // <<< НОВЫЙ МЕТОД ДЛЯ ПАГИНАЦИИ >>>
  Future<Map<String, dynamic>> getCommentsPaginated({
    required String articleRouteName,
    DocumentSnapshot? startAfter,
    int limit = 10,
  }) async {
    //print('--- GETTING TOP-LEVEL COMMENTS for $articleRouteName ---');

    Query query = _db
        .collection('comments')
        .where('articleRouteName', isEqualTo: articleRouteName)
        // <<< ГЛАВНОЕ ИЗМЕНЕНИЕ: Фильтруем по isReply, а не parentId >>>
        .where('isReply', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final snapshot = await query.get();
    final comments =
        snapshot.docs.map((doc) => Comment.fromFirestore(doc)).toList();

    //print('Found ${comments.length} top-level comments.');

    return {
      'comments': comments,
      'lastDoc': snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
    };
  }

  Future<List<Comment>> getReplies(String parentId) async {
    // <<< ОТЛАДКА >>>
    //print('--- GETTING REPLIES for parent $parentId ---');

    final snapshot = await _db
        .collection('comments')
        .where('parentId', isEqualTo: parentId)
        .orderBy('createdAt')
        .get();

    final replies =
        snapshot.docs.map((doc) => Comment.fromFirestore(doc)).toList();

    // <<< ОТЛАДКА >>>
    //print('Found ${replies.length} replies.');

    return replies;
  }

  Future<void> postComment({
    required String articleRouteName,
    required String text,
    String? authorId,
    required String authorName,
    String? parentId,
  }) async {
    // 1. Создаем объект комментария с данными
    final newComment = {
      'articleRouteName': articleRouteName,
      'text': text,
      'createdAt': Timestamp.now(),
      'authorId': authorId,
      'authorName': authorName,
      'likes': 0,
      'parentId': parentId,
      'replyCount': 0,
      // <<< ГЛАВНОЕ ИЗМЕНЕНИЕ: Явно устанавливаем флаг isReply >>>
      'isReply': parentId != null,
    };

    // 2. Добавляем новый комментарий
    await _db.collection('comments').add(newComment);

    // 3. Если это был ответ, обновляем счетчик у родителя
    if (parentId != null) {
      final parentRef = _db.collection('comments').doc(parentId);
      await parentRef.update({'replyCount': FieldValue.increment(1)});
    }
  }

  Future<void> likeComment(String commentId, bool increment) async {
    final docRef = _db.collection('comments').doc(commentId);
    await docRef.update({'likes': FieldValue.increment(increment ? 1 : -1)});
  }
}
