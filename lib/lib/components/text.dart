// lib/components/text.dart

import 'package:flutter/material.dart';
import 'package:minimal/components/spacing.dart';
import 'package:minimal/components/typography.dart';

class TextBody extends StatelessWidget {
  final String text;

  const TextBody({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: marginBottom24,
      child: Text(
        text,
        // Вызываем функцию стиля с 'context', который доступен внутри build
        style: bodyTextStyle(context),
      ),
    );
  }
}

class TextBodySecondary extends StatelessWidget {
  final String text;

  const TextBodySecondary({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: marginBottom24,
      child: Text(
        text,
        style: subtitleTextStyle(context),
      ),
    );
  }
}

class TextHeadlineSecondary extends StatelessWidget {
  final String text;

  const TextHeadlineSecondary({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: marginBottom12,
      child: Text(
        text,
        style: headlineSecondaryTextStyle(context),
      ),
    );
  }
}

class TextBlockquote extends StatelessWidget {
  final String text;

  const TextBlockquote({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: marginBottom24,
      // <<< ИЗМЕНЕНИЕ: Адаптируем цвет рамки цитаты к теме >>>
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
                  width: 2, color: Theme.of(context).colorScheme.onSurface))),
      padding: const EdgeInsets.only(left: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: bodyTextStyle(context),
        ),
      ),
    );
  }
}

// <<< ИЗМЕНЕНИЕ: Возвращаем menuButtonStyle к его первоначальному виду как переменной.
// Текст стиля мы будем определять в месте его использования, где доступен context.
// Это самый чистый и правильный подход.
ButtonStyle menuButtonStyle = TextButton.styleFrom(
  foregroundColor: Colors.black, // Черный текст
  backgroundColor: Colors.transparent,
  // textStyle здесь можно временно убрать или оставить базовый,
  // так как он будет переопределен в месте вызова.
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18.0), // Скругленные углы
  ),
);
