// lib/models/service_model.dart

class SeoToolService {
  final String name; // Название для лого
  final String url;
  final String comment;

  SeoToolService(
      {required this.name, required this.url, required this.comment});

  // <<< КЛЮЧЕВОЕ ИСПРАВЛЕНИЕ: Логика генерации пути теперь основана на URL >>>
  String get logoPath {
    try {
      // 1. Парсим URL, чтобы безопасно извлечь домен
      final uri = Uri.parse(url);

      // 2. Убираем 'www.', если он есть
      String host = uri.host.replaceAll('www.', '');

      // 3. Заменяем все точки на дефисы
      String fileName = host.replaceAll('.', '-');

      // 4. Возвращаем правильный путь
      return 'assets/images/service-logos/$fileName.webp';
    } catch (e) {
      // Если URL некорректный, возвращаем путь к картинке-заглушке
      print('Error parsing URL for logo: $url -> $e');
      return 'assets/images/service-logos/placeholder.webp'; // Создайте картинку-заглушку
    }
  }
}

class SeoToolCategory {
  final String name;
  final List<SeoToolService> services;

  SeoToolCategory({required this.name, required this.services});
}

class SeoToolSection {
  final String name;
  final List<SeoToolCategory> categories;

  SeoToolSection({required this.name, required this.categories});
}
