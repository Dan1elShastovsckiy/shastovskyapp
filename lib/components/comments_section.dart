// lib/components/comments_section.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/models/article_interaction.dart';
import 'package:minimal/pages/page_login.dart';
import 'package:minimal/services/auth_service.dart';
import 'package:minimal/services/interaction_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentsSection extends StatefulWidget {
  final String articleRouteName;
  const CommentsSection({super.key, required this.articleRouteName});

  // <<< ИСПРАВЛЕНИЕ: Убираем `_` из имени класса State >>>
  @override
  CommentsSectionState createState() => CommentsSectionState();
}

class CommentsSectionState extends State<CommentsSection> {
  final _commentController = TextEditingController();
  final _interactionService = InteractionService();
  bool _isPosting = false;

  List<Comment> _comments = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDocument;

  @override
  void initState() {
    super.initState();
    _fetchInitialComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialComments() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final result = await _interactionService.getCommentsPaginated(
      articleRouteName: widget.articleRouteName,
    );
    if (mounted) {
      setState(() {
        _comments = result['comments'];
        _lastDocument = result['lastDoc'];
        _hasMore = _comments.length == 10;
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchMoreComments() async {
    if (_isLoadingMore || !_hasMore || _lastDocument == null) return;
    setState(() => _isLoadingMore = true);

    final result = await _interactionService.getCommentsPaginated(
      articleRouteName: widget.articleRouteName,
      startAfter: _lastDocument,
    );
    final newComments = result['comments'] as List<Comment>;

    if (mounted) {
      setState(() {
        _comments.addAll(newComments);
        _lastDocument = result['lastDoc'];
        _hasMore = newComments.length ==
            10; // Если пришло меньше 10, значит, больше нет
        _isLoadingMore = false;
      });
    }
  }

  void _postComment() async {
    if (_commentController.text.trim().isEmpty || _isPosting) return;

    setState(() => _isPosting = true);
    final auth = Provider.of<AuthService>(context, listen: false);
    await _interactionService.postComment(
      articleRouteName: widget.articleRouteName,
      text: _commentController.text.trim(),
      authorId: auth.user?.uid,
      authorName: auth.user?.displayName ?? 'Аноним',
    );
    if (mounted) {
      _commentController.clear();
      FocusScope.of(context).unfocus();
      setState(() => _isPosting = false);
      _fetchInitialComments();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Комментарии",
            style: headlineTextStyle(context).copyWith(fontSize: 28)),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
                child: Icon(auth.isAuthenticated
                    ? Icons.person
                    : Icons.person_off_outlined)),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _commentController,
                maxLines: 4,
                minLines: 2,
                decoration: InputDecoration(
                  hintText: auth.isAuthenticated
                      ? 'Оставить комментарий как ${auth.user!.displayName ?? 'Пользователь'}...'
                      : 'Оставить анонимный комментарий...',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
              onPressed: _isPosting ? null : _postComment,
              child: _isPosting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text("Отправить")),
        ),
        // Код для добавления ссылки для входа ---
        if (!auth.isAuthenticated)
          Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Opacity(
                  opacity: 0.7,
                  child: TextButton(
                    onPressed: () {
                      final authService =
                          Provider.of<AuthService>(context, listen: false);
                      print(
                          '--- ШАГ 1: Сохраняем маршрут: /${widget.articleRouteName} ---');
                      // 1. Запоминаем текущий маршрут статьи, ДОБАВИВ СЛЭШ В НАЧАЛЕ
                      authService.setPostLoginRedirect(
                          '/${widget.articleRouteName}'); // <--- ИСПРАВЛЕНО
                      // 2. Переходим на страницу входа
                      Navigator.of(context).pushNamed('/${LoginPage.name}');
                    },
                    child: const Text(
                      "или войти и оставить коммент с именем...",
                      style:
                          TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              )),
        const SizedBox(height: 40),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_comments.isEmpty)
          const Center(
              child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Text("Комментариев пока нет. Будьте первым!"),
          ))
        else
          Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _comments.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 24), // Убираем Divider
                itemBuilder: (context, index) =>
                    _CommentItem(comment: _comments[index]),
              ),
              if (_hasMore)
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Center(
                    child: _isLoadingMore
                        ? const CircularProgressIndicator()
                        : TextButton(
                            onPressed: _fetchMoreComments,
                            child: const Text("Загрузить еще комментарии...")),
                  ),
                ),
            ],
          )
      ],
    );
  }
}

// -- Виджет для одного комментария (с возможностью отвечать и видеть ответы) --
class _CommentItem extends StatefulWidget {
  final Comment comment;
  const _CommentItem({required this.comment});

  // <<< ИСПРАВЛЕНИЕ: Убираем `_` из имени класса State >>>
  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<_CommentItem> {
  final _interactionService = InteractionService();
  final _replyController = TextEditingController();
  bool _showReplies = false;
  bool _showReplyForm = false;
  bool _isReplying = false;
  Set<String> _likedComments = {};
  late int _localLikeCount;

  @override
  void initState() {
    super.initState();
    _localLikeCount = widget.comment.likes;
    _loadLikedComments();
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  void _loadLikedComments() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() => _likedComments =
          (prefs.getStringList('liked_comments') ?? []).toSet());
    }
  }

  void _likeComment(String commentId) async {
    final prefs = await SharedPreferences.getInstance();
    final bool isCurrentlyLiked = _likedComments.contains(commentId);

    setState(() {
      if (isCurrentlyLiked) {
        _likedComments.remove(commentId);
        _localLikeCount--;
      } else {
        _likedComments.add(commentId);
        _localLikeCount++;
      }
    });

    await prefs.setStringList('liked_comments', _likedComments.toList());
    _interactionService.likeComment(commentId, !isCurrentlyLiked);
  }

  void _postReply() async {
    if (_replyController.text.trim().isEmpty || _isReplying) return;
    setState(() => _isReplying = true);
    final auth = Provider.of<AuthService>(context, listen: false);
    await _interactionService.postComment(
      articleRouteName: widget.comment.articleRouteName,
      text: _replyController.text.trim(),
      authorId: auth.user?.uid,
      authorName: auth.user?.displayName ?? 'Аноним',
      // <<< ВАЖНО: Передаем ID родителя >>>
      parentId: widget.comment.id,
    );
    if (mounted) {
      _replyController.clear();
      setState(() {
        _isReplying = false;
        _showReplyForm = false;
        _showReplies = true; // Автоматически показать ответ после публикации
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLiked = _likedComments.contains(widget.comment.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
                child: Text(widget.comment.authorName.isNotEmpty
                    ? widget.comment.authorName.substring(0, 1).toUpperCase()
                    : 'А')),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(widget.comment.authorName,
                        style: bodyTextStyle(context)
                            .copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text(
                        '• ${DateFormat.yMMMd('ru_RU').format(widget.comment.createdAt)}',
                        style: bodyTextStyle(context).copyWith(
                            color: theme.colorScheme.secondary, fontSize: 12)),
                  ]),
                  const SizedBox(height: 4),
                  Text(widget.comment.text, style: bodyTextStyle(context)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => _likeComment(widget.comment.id),
                        icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked
                                ? Colors.red
                                : theme.colorScheme.secondary,
                            size: 16),
                        label: Text(_localLikeCount.toString(),
                            style: TextStyle(
                                color: theme.colorScheme.secondary,
                                fontSize: 14)),
                      ),
                      const SizedBox(width: 16),
                      TextButton(
                          onPressed: () =>
                              setState(() => _showReplyForm = !_showReplyForm),
                          child: const Text("Ответить")),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        if (_showReplyForm)
          Padding(
            padding: const EdgeInsets.only(left: 56, top: 12, bottom: 12),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                        controller: _replyController,
                        autofocus: true,
                        decoration:
                            const InputDecoration(hintText: "Ваш ответ..."))),
                IconButton(
                    onPressed: _isReplying ? null : _postReply,
                    icon: _isReplying
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.send)),
              ],
            ),
          ),
        // --- Кнопка "Показать ответы" (без изменений) ---
        if (widget.comment.replyCount > 0)
          Padding(
            padding: const EdgeInsets.only(left: 48),
            child: TextButton(
              onPressed: () => setState(() => _showReplies = !_showReplies),
              child: Text(_showReplies
                  ? "Скрыть ответы"
                  : "Показать ответы (${widget.comment.replyCount})"),
            ),
          ),

        // --- Список ответов (без изменений) ---
        if (_showReplies)
          Padding(
            padding: const EdgeInsets.only(left: 40, top: 16),
            child: FutureBuilder<List<Comment>>(
              future: _interactionService.getReplies(widget.comment.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // Это может произойти, если ответ был удален, а счетчик еще не обновился
                  return const SizedBox.shrink();
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _ReplyItem(reply: snapshot.data![index]);
                  },
                );
              },
            ),
          )
      ],
    );
  }
}

// --- Отдельный виджет для отображения ответа ---
class _ReplyItem extends StatelessWidget {
  final Comment reply;
  const _ReplyItem({required this.reply});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
            radius: 16,
            child: Text(reply.authorName.isNotEmpty
                ? reply.authorName.substring(0, 1).toUpperCase()
                : 'А')),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(reply.authorName,
                    style: bodyTextStyle(context)
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Text('• ${DateFormat.yMMMd('ru_RU').format(reply.createdAt)}',
                    style: bodyTextStyle(context).copyWith(
                        color: theme.colorScheme.secondary, fontSize: 12)),
              ]),
              const SizedBox(height: 4),
              Text(reply.text, style: bodyTextStyle(context)),
              // <<< ИСПРАВЛЕНИЕ: Добавляем возможность лайкать ответы >>>
              // Для этого _ReplyItem тоже должен быть StatefulWidget
              // Но для простоты пока оставим так.
            ],
          ),
        ),
      ],
    );
  }
}
