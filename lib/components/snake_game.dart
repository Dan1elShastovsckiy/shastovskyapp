// lib/components/snake_game.dart

import 'package:flutter/material.dart';

// Направления движения
enum SnakeDirection { up, down, left, right }

// Модель для сегмента змейки
class SnakeSegment {
  Offset position;
  SnakeSegment(this.position);
}

// Виджет для отрисовки одного сегмента змейки
class SnakeSegmentPainter extends CustomPainter {
  final Color color;
  SnakeSegmentPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Рисуем кружок с небольшой тенью для объема
    canvas.drawShadow(
        Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height)),
        Colors.black.withOpacity(0.3),
        2.0,
        true);
    canvas.drawOval(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Виджет для еды
class FoodPainter extends CustomPainter {
  final Color color;
  FoodPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Рисуем "пульсирующую" еду с тенью
    canvas.drawShadow(
        Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height)),
        color.withOpacity(0.8),
        4.0,
        true);
    canvas.drawOval(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Виджет для препятствий
class ObstaclePainter extends CustomPainter {
  final Color color; // <<< Добавляем цвет в конструктор
  ObstaclePainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color // <<< Используем переданный цвет
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = color.withAlpha(150) // <<< Делаем рамку чуть темнее/светлее
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Рисуем квадрат с рамкой
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);
    canvas.drawRect(rect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
