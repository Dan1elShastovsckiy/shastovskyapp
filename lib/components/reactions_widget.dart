// lib/components/reactions_widget.dart

import 'package:flutter/material.dart';
import 'package:minimal/models/article_interaction.dart';
import 'package:minimal/services/auth_service.dart';
import 'package:minimal/services/interaction_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Модель для удобства ---
class Reaction {
  final String id;
  final String emoji;
  Reaction(this.id, this.emoji);
}

class ReactionsWidget extends StatefulWidget {
  final String articleRouteName;
  const ReactionsWidget({super.key, required this.articleRouteName});

  @override
  State<ReactionsWidget> createState() => _ReactionsWidgetState();
}

class _ReactionsWidgetState extends State<ReactionsWidget> {
  final InteractionService _interactionService = InteractionService();

  // Добавляем новые реакции
  final List<Reaction> _availableReactions = [
    Reaction('thumbs_up', '👍'),
    Reaction('heart', '❤️'),
    Reaction('rocket', '🚀'),
    Reaction('fire', '🔥'),
    Reaction('laugh', '😂'),
    Reaction('love_eyes', '😍'),
    Reaction('dark_moon', '🌚'),
    Reaction('poop', '💩'),
  ];

  // <<< ИЗМЕНЕНИЕ 1: Заменяем String? на Set<String> >>>
  Set<String> _votedReactions = {};
  bool _isLoading = true;
  static const int maxReactions = 3; // Максимум 3 реакции
  // <<< ШАГ 1: Добавляем поле для хранения ссылки на сервис >>>
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    // <<< ШАГ 2: Получаем и сохраняем ссылку на AuthService >>>
    _authService = Provider.of<AuthService>(context, listen: false);

    _loadVoteStatus();
    // Подписываемся на изменения через сохраненную ссылку
    _authService.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    // <<< ШАГ 3: Используем сохраненную ссылку для отписки >>>
    // Теперь здесь нет обращения к 'context'
    _authService.removeListener(_onAuthStateChanged);
    super.dispose();
  }

  // Сбрасываем голоса при смене пользователя
  void _onAuthStateChanged() {
    // <<< ИСПРАВЛЕНИЕ: Проверяем, что виджет еще существует >>>
    if (mounted) {
      _loadVoteStatus();
    }
  }

  void _loadVoteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        // <<< ИСПРАВЛЕНИЕ: Добавляем ?? [] для обработки null >>>
        _votedReactions =
            (prefs.getStringList('voted_${widget.articleRouteName}') ?? [])
                .toSet();
        _isLoading = false;
      });
    }
  }

  // <<< ИЗМЕНЕНИЕ 2: Новая логика для нескольких голосов >>>
  void _onReactionTapped(String reactionId) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      if (_votedReactions.contains(reactionId)) {
        // --- Снимаем голос ---
        _interactionService.updateReaction(
            widget.articleRouteName, reactionId, false);
        _votedReactions.remove(reactionId);
      } else {
        // --- Ставим новый голос, если лимит не превышен ---
        if (_votedReactions.length < maxReactions) {
          _interactionService.updateReaction(
              widget.articleRouteName, reactionId, true);
          _votedReactions.add(reactionId);
        } else {
          // Показываем сообщение, что лимит достигнут
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Можно выбрать не более $maxReactions реакций.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    });

    // Сохраняем обновленный список в SharedPreferences
    await prefs.setStringList(
        'voted_${widget.articleRouteName}', _votedReactions.toList());
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return StreamBuilder<ArticleStats>(
      stream: _interactionService.getArticleStats(widget.articleRouteName),
      builder: (context, snapshot) {
        // Получаем актуальные счетчики из Firestore
        final reactionCounts = snapshot.data?.reactions ?? {};

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: _availableReactions.map((reaction) {
            final count = reactionCounts[reaction.id] ?? 0;
            // <<< ИЗМЕНЕНИЕ 3: Проверяем наличие в Set >>>
            final isSelected = _votedReactions.contains(reaction.id);

            return Material(
              color: isSelected
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withOpacity(0.5),
              shape: const StadiumBorder(), // Делает кнопку круглой/овальной
              elevation: isSelected ? 4 : 1,
              shadowColor: Colors.black.withOpacity(0.5),
              child: InkWell(
                onTap: () => _onReactionTapped(reaction.id),
                customBorder: const StadiumBorder(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(reaction.emoji,
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(count.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
