// lib/components/color.dart

import 'package:flutter/material.dart';

class AppColors {
  static const LightThemeColors light = LightThemeColors();
  static const DarkThemeColors dark = DarkThemeColors();
}

class LightThemeColors {
  const LightThemeColors();
  // Основной цвет для элементов (кнопки, акценты)
  Color get primary => const Color(0xFF242424); 
  // Второстепенный цвет (менее важные элементы)
  Color get secondary => const Color(0xFF616161); 
  // Фон страниц
  Color get background => const Color(0xFFFFFFFF); 
  // Фон "поверхностей" (шапка, карточки)
  Color get surface => const Color(0xFFF5F5F5); 
  // Цвет текста/иконок НА primary
  Color get onPrimary => const Color(0xFFFFFFFF); 
  // Цвет текста/иконок НА secondary
  Color get onSecondary => const Color(0xFFFFFFFF);
  // Цвет основного текста НА background/surface
  Color get onSurface => const Color(0xFF242424); 
}

class DarkThemeColors {
  const DarkThemeColors();
  // Основной цвет в темной теме (светлый для контраста)
  Color get primary => const Color(0xFFFFFFFF);
  // Второстепенный
  Color get secondary => const Color(0xFFBDBDBD);
  // Фон страниц
  Color get background => const Color(0xFF121212);
  // Фон "поверхностей"
  Color get surface => const Color(0xFF1E1E1E);
  // Цвет текста/иконок НА primary (темный для контраста)
  Color get onPrimary => const Color(0xFF121212);
  // Цвет текста/иконок НА secondary
  Color get onSecondary => const Color(0xFF121212);
  // Цвет основного текста НА background/surface (светлый)
  Color get onSurface => const Color(0xFFFFFFFF);
}

// Удаляем старые константы, чтобы случайно их не использовать
// const Color textPrimary = Color(0xFF242424);
// const Color textSecondary = Color(0xFF616161);