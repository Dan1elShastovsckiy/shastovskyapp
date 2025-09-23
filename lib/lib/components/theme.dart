// lib/components/theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal/components/color.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    // <<< КЛЮЧЕВОЕ ИСПРАВЛЕНИЕ: Используем AppColors >>>
    scaffoldBackgroundColor: AppColors.light.background,
    colorScheme: ColorScheme.light(
      primary: AppColors.light.primary,
      secondary: AppColors.light.secondary,
      surface: AppColors.light.surface,
      background: AppColors.light.background,
      onPrimary: AppColors.light.onPrimary,
      onSecondary: AppColors.light.onSecondary,
      onSurface: AppColors.light.onSurface,
      // У onBackground теперь тот же цвет, что и у onSurface
      onBackground: AppColors.light.onSurface,
    ),
    textTheme: TextTheme(
      // Главный заголовок использует основной цвет текста
      displayLarge: GoogleFonts.montserrat(color: AppColors.light.onSurface, fontSize: 26, letterSpacing: 1.5, fontWeight: FontWeight.w300),
      displayMedium: GoogleFonts.montserrat(color: AppColors.light.onSurface, fontSize: 20, fontWeight: FontWeight.w300),
      // Основной текст тоже использует основной цвет
      bodyLarge: GoogleFonts.openSans(color: AppColors.light.onSurface, fontSize: 14),
      // А вот второстепенный текст использует secondary цвет
      bodyMedium: GoogleFonts.openSans(color: AppColors.light.secondary, fontSize: 14, letterSpacing: 1),
      labelLarge: GoogleFonts.montserrat(color: AppColors.light.onSurface, fontSize: 14, letterSpacing: 1),
    ),
    dividerColor: const Color(0xFFEEEEEE),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    // <<< КЛЮЧЕВОЕ ИСПРАВЛЕНИЕ: Используем AppColors >>>
    scaffoldBackgroundColor: AppColors.dark.background,
    colorScheme: ColorScheme.dark(
      primary: AppColors.dark.primary,
      secondary: AppColors.dark.secondary,
      surface: AppColors.dark.surface,
      background: AppColors.dark.background,
      onPrimary: AppColors.dark.onPrimary,
      onSecondary: AppColors.dark.onSecondary,
      onSurface: AppColors.dark.onSurface,
      onBackground: AppColors.dark.onSurface,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.montserrat(color: AppColors.dark.onSurface, fontSize: 26, letterSpacing: 1.5, fontWeight: FontWeight.w300),
      displayMedium: GoogleFonts.montserrat(color: AppColors.dark.onSurface, fontSize: 20, fontWeight: FontWeight.w300),
      bodyLarge: GoogleFonts.openSans(color: AppColors.dark.onSurface, fontSize: 14),
      bodyMedium: GoogleFonts.openSans(color: AppColors.dark.secondary, fontSize: 14, letterSpacing: 1),
      labelLarge: GoogleFonts.montserrat(color: AppColors.dark.onSurface, fontSize: 14, letterSpacing: 1),
    ),
    dividerColor: const Color(0xFF333333),
  );
}