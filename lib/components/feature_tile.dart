// /lib/components/feature_tile.dart

import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
// <<< ИЗМЕНЕНИЕ 1: Добавляем импорт для открытия ссылок >>>
import 'package:url_launcher/url_launcher.dart';

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? content;
  final Widget? actionButton;
  final List<Widget>? children;

  const FeatureTile({
    super.key,
    required this.icon,
    required this.title,
    this.content,
    this.actionButton,
    this.children,
  }) : assert(content != null || children != null,
            'Должен быть предоставлен либо content, либо children');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // <<< ИЗМЕНЕНИЕ 2: Создаем функцию-обработчик для нажатия на ссылку >>>
    void onLinkTapped(String text, String? href, String title) {
      if (href != null) {
        launchUrl(Uri.parse(href));
      }
    }

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
          if (children != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children!,
            )
          else
            Align(
              alignment: Alignment.centerLeft,
              child: MarkdownBody(
                data: content!,
                selectable: true,
                // <<< ИЗМЕНЕНИЕ 3: Передаем наш обработчик в MarkdownBody >>>
                onTapLink: onLinkTapped,
                styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                  p: bodyTextStyle(context),
                  listBullet: bodyTextStyle(context),
                  strong: bodyTextStyle(context)
                      .copyWith(fontWeight: FontWeight.bold),
                  code: bodyTextStyle(context).copyWith(
                    fontFamily: 'monospace',
                    backgroundColor: theme.colorScheme.surface.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          if (actionButton != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: actionButton!,
              ),
            ),
        ],
      ),
    );
  }
}
