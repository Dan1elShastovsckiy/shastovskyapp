// /lib/components/feature_tile.dart

import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart'; // Для bodyTextStyle и divider
import 'package:flutter_markdown/flutter_markdown.dart';

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const FeatureTile({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ExpansionTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title,
            style: headlineSecondaryTextStyle(context).copyWith(fontSize: 18)),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        backgroundColor: theme.colorScheme.surface.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: MarkdownBody(
              data: content, // Передаем текст с Markdown-разметкой
              selectable: true, // Делаем текст выделяемым
              styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                p: bodyTextStyle(context), // Применяем ваш стиль к параграфам
                listBullet: bodyTextStyle(context), // И к элементам списка
                // Вы можете настроить и другие теги, если понадобится
              ),
            ),
          ),
        ],
      ),
    );
  }
}
