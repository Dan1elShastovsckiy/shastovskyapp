// lib/utils/meta_tag_service.dart

import 'package:flutter/foundation.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class MetaTagService {
  void updateTitle(String title) {
    if (kIsWeb) {
      html.document.title = title;
    }
  }

  void updateMetaTag(String name, String content) {
    if (kIsWeb) {
      html.document
          .querySelector('meta[name="$name"]')
          ?.setAttribute('content', content);
    }
  }

  void updateOpenGraphTag(String property, String content) {
    if (kIsWeb) {
      html.document
          .querySelector('meta[property="$property"]')
          ?.setAttribute('content', content);
    }
  }

  void updateAllTags({
    required String title,
    required String description,
    String? imageUrl,
  }) {
    if (kIsWeb) {
      // Обновляем базовые теги
      updateTitle(title);
      updateMetaTag('title', title);
      updateMetaTag('description', description);

      // Обновляем Open Graph
      updateOpenGraphTag('og:title', title);
      updateOpenGraphTag('og:description', description);
      if (imageUrl != null) {
        // Убедитесь, что URL абсолютный (начинается с https://)
        updateOpenGraphTag('og:image', imageUrl);
      }
    }
  }
}
