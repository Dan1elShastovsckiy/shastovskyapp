// lib/components/components.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:minimal/components/typography.dart';

// Экспортируем все остальные компоненты, как и раньше
export 'image_carousel.dart';
export 'blog.dart';
export 'color.dart';
export 'spacing.dart';
export 'text.dart';
export 'typography.dart';

// <<< КЛЮЧЕВОЕ ИСПРАВЛЕНИЕ: Превращаем переменную в функцию, чтобы она могла принимать context >>>
// Это единственный стиль кнопки, который должен здесь остаться.
ButtonStyle elevatedButtonStyle(BuildContext context) {
  final theme = Theme.of(context);
  return ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.surface,
    foregroundColor: theme.colorScheme.onSurface,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    side: BorderSide(color: theme.colorScheme.onSurface),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18.0),
    ),
    elevation: 0,
  );
}

class CodeBlock extends StatelessWidget {
  final String code;
  const CodeBlock({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final codeTheme = isDark ? atomOneDarkTheme : atomOneLightTheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: codeTheme['root']?.backgroundColor ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SelectableText(
              code.trim(),
              style: TextStyle(
                fontFamily: 'monospace',
                color: codeTheme['root']?.color,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.copy,
                  size: 18, color: codeTheme['root']?.color?.withOpacity(0.5)),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: code.trim()));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Код скопирован в буфер обмена!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Вспомогательный виджет для пунктов "Чем полезно?"
class InfoPoint extends StatelessWidget {
  final IconData icon;
  final String text;
  const InfoPoint({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2.0, right: 12.0),
          child: Icon(icon,
              size: 20, color: Theme.of(context).colorScheme.primary),
        ),
        Expanded(
          child: Text(text, style: bodyTextStyle(context)),
        ),
      ],
    );
  }
}

// <<< (класс для статей в lib/components/components.dart) >>>
class UsefulArticle {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> tags;
  final String routeName;
  final DateTime publicationDate;
  final int readingTime;

  UsefulArticle({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.tags,
    required this.routeName,
    required this.publicationDate,
    required this.readingTime,
  });
}
