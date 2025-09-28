// /lib/pages/safe_webview_controller.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Условный импорт для веб-специфичного кода
import 'package:webview_flutter_web/webview_flutter_web.dart'
    if (dart.library.io) 'dart:io';

class SafeWebViewController {
  late final WebViewController _controller;
  final Function(String) onError;
  final Function(String) onLog;

  WebViewController get controller => _controller;

  SafeWebViewController({required this.onError, required this.onLog}) {
    _initializeController();
  }

  void _initializeController() {
    _controller = WebViewController();

    // Выполняем платформо-зависимую настройку
    if (!kIsWeb) {
      _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    }

    _controller
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(NavigationDelegate(
        onWebResourceError: (error) {
          final errorMessage =
              'Ошибка загрузки ресурса: ${error.errorCode} - ${error.description}';
          onError(errorMessage);
          onLog(errorMessage);
        },
        onNavigationRequest: (request) {
          // Разрешаем начальную загрузку на всех платформах
          if (kIsWeb || request.url.startsWith('data:text/html')) {
            return NavigationDecision.navigate;
          }
          // Блокируем любые другие переходы
          onError('Переходы по ссылкам в песочнице отключены.');
          return NavigationDecision.prevent;
        },
      ))
      ..addJavaScriptChannel(
        'JsErrorHandler', // Канал для получения ошибок из JS
        onMessageReceived: (JavaScriptMessage message) {
          onError('JS Ошибка: ${message.message}');
        },
      );
  }

  Future<void> loadHtml(String html) async {
    // Внедряем наш скрипт-перехватчик ошибок в <head>
    final fullHtml = _embedErrorReporter(html);

    try {
      if (kIsWeb) {
        // Надежный метод для ВЕБА
        final platformController = _controller.platform as WebWebViewController;
        await platformController.loadHtmlString(fullHtml);
      } else {
        // Надежный метод для МОБИЛЬНЫХ
        await _controller.loadRequest(
          Uri.dataFromString(
            fullHtml,
            mimeType: 'text/html',
            encoding: Encoding.getByName('utf-8'),
          ),
        );
      }
    } catch (e) {
      final errorMessage = 'Критическая ошибка загрузки HTML: $e';
      onError(errorMessage);
      onLog(errorMessage);
      await _loadErrorPage(errorMessage);
    }
  }

  String _embedErrorReporter(String html) {
    // Этот скрипт будет ловить JS-ошибки внутри WebView и отправлять их во Flutter
    const String jsErrorReporter = '''
      <script>
        window.onerror = function(message, source, lineno, colno, error) {
          if (window.JsErrorHandler) {
            window.JsErrorHandler.postMessage(message);
          }
          return true; // Предотвращаем показ стандартного окна ошибки браузера
        };
      </script>
    ''';
    // Безопасно вставляем скрипт после тега <head>
    final headTag = RegExp(r'<head>', caseSensitive: false);
    if (html.contains(headTag)) {
      return html.replaceFirst(headTag, '<head>$jsErrorReporter');
    } else {
      // Если тега <head> нет, добавляем его
      return html.replaceFirst('<html>', '<html><head>$jsErrorReporter</head>');
    }
  }

  Future<void> _loadErrorPage(String errorMessage) async {
    final errorPage = '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
          body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen-Sans, Ubuntu, Cantarell, "Helvetica Neue", sans-serif; margin: 0; padding: 20px; background-color: #fef2f2; color: #374151; display: flex; align-items: center; justify-content: center; min-height: 100vh; box-sizing: border-box; }
          .container { background-color: white; border-radius: 8px; padding: 24px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.1); width: 100%; max-width: 600px; border-left: 5px solid #ef4444; }
          h2 { color: #b91c1c; margin-top: 0; }
          p { line-height: 1.6; }
          code { background-color: #fee2e2; color: #991b1b; padding: 2px 6px; border-radius: 4px; font-family: "SFMono-Regular", Consolas, "Liberation Mono", Menlo, Courier, monospace; }
        </style>
      </head>
      <body>
        <div class="container">
          <h2>Произошла критическая ошибка</h2>
          <p>Не удалось загрузить ваш код. Это может быть связано с серьезной синтаксической ошибкой или проблемой с загрузкой.</p>
          <p><strong>Сообщение:</strong></p>
          <code>$errorMessage</code>
        </div>
      </body>
      </html>
    ''';

    // Для загрузки страницы с ошибкой используем тот же платформо-зависимый подход
    if (kIsWeb) {
      final platformController = _controller.platform as WebWebViewController;
      await platformController.loadHtmlString(errorPage);
    } else {
      await _controller.loadRequest(
        Uri.dataFromString(
          errorPage,
          mimeType: 'text/html',
          encoding: Encoding.getByName('utf-8'),
        ),
      );
    }
  }
}
