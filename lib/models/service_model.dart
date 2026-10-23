// lib/models/service_model.dart

class SeoToolService {
  final String name; // Название для лого
  final String url;
  final String comment;

  SeoToolService(
      {required this.name, required this.url, required this.comment});

  String get logoPath {
    final host = Uri.tryParse(url)?.host.replaceFirst(RegExp(r'^www\.'), '');
    if (host == null || host.isEmpty) return '';
    return 'assets/images/service-logos/${host.replaceAll('.', '-')}.webp';
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
