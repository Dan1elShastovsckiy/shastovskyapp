// lib/utils/url_provider_web.dart

// ignore: deprecated_member_use
import 'dart:html' as html;

/// Возвращает URL текущей страницы для веб-платформы.
String getCurrentUrl() {
  return html.window.location.href;
}
