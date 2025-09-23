// lib/components/typography.dart

import 'package:flutter/material.dart';

// <<< ИЗМЕНЕНИЕ: Вместо глобальных переменных теперь функции, принимающие BuildContext >>>
// Эти функции обращаются к текущей теме (Theme.of(context)) и берут из нее
// предопределенные стили, которые мы зададим в файле theme.dart.

/// Стиль для главных заголовков (бывший headlineTextStyle)
TextStyle headlineTextStyle(BuildContext context) =>
    Theme.of(context).textTheme.displayLarge!;

/// Стиль для подзаголовков (бывший headlineSecondaryTextStyle)
TextStyle headlineSecondaryTextStyle(BuildContext context) =>
    Theme.of(context).textTheme.displayMedium!;

/// Стиль для второстепенного текста, подписей (бывший subtitleTextStyle)
TextStyle subtitleTextStyle(BuildContext context) =>
    Theme.of(context).textTheme.bodyMedium!;

/// Стиль для основного текста (бывший bodyTextStyle)
TextStyle bodyTextStyle(BuildContext context) =>
    Theme.of(context).textTheme.bodyLarge!;

/// Стиль для кнопок (бывший buttonTextStyle)
TextStyle buttonTextStyle(BuildContext context) =>
    Theme.of(context).textTheme.labelLarge!;
