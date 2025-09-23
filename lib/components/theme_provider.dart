// lib/providers/theme_provider.dart

import 'package:flutter/material.dart';
// <<< ИЗМЕНЕНИЕ: Добавляем необходимый импорт для PlatformDispatcher >>>
import 'dart:ui'; 

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode;

  // Конструктор остается без изменений, но логика внутри _init изменится
  ThemeProvider() : _themeMode = ThemeMode.system {
    _init();
  }

  ThemeMode get themeMode => _themeMode;

  void _init() {
    // <<< ИЗМЕНЕНИЕ: Используем PlatformDispatcher вместо устаревшего window >>>
    final brightness = PlatformDispatcher.instance.platformBrightness;
    _themeMode = brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      // <<< ИЗМЕНЕНИЕ: Используем PlatformDispatcher и здесь >>>
      final brightness = PlatformDispatcher.instance.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return _themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}