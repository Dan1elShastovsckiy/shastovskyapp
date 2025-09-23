// lib/components/components.dart

import 'package:flutter/material.dart';

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
