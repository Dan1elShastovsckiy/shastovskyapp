// lib/services/view_counter_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class ViewCounterService {
  // Ключ для хранения уникальных просмотров
  static const String _viewedArticlesKey = 'viewed_articles';

  // Метод для увеличения счетчика, если статья еще не просмотрена
  Future<void> incrementViewCount(String articleRouteName) async {
    final prefs = await SharedPreferences.getInstance();

    // Получаем список уже просмотренных статей
    List<String> viewedArticles = prefs.getStringList(_viewedArticlesKey) ?? [];

    // Проверяем, есть ли текущая статья в списке
    if (!viewedArticles.contains(articleRouteName)) {
      // Если нет, добавляем ее в список "просмотренных"
      viewedArticles.add(articleRouteName);
      await prefs.setStringList(_viewedArticlesKey, viewedArticles);

      // И увеличиваем ее счетчик (для простоты будем хранить каждый счетчик под своим ключом)
      int currentViews = prefs.getInt(articleRouteName) ?? 0;
      await prefs.setInt(articleRouteName, currentViews + 1);
    }
  }

  // Метод для получения текущего количества просмотров
  Future<int> getViewCount(String articleRouteName) async {
    final prefs = await SharedPreferences.getInstance();
    // Добавим небольшую случайность для имитации "живого" счетчика
    int baseViews = 100 + articleRouteName.hashCode % 150; // Базовое число, чтобы не начинать с нуля
    return prefs.getInt(articleRouteName) ?? baseViews;
  }
}
