// prerender_tool/hydrate_prerender.dart
/*
  Этот скрипт выполняет продвинутый пререндеринг для "гидратации".
  Он генерирует полный визуальный HTML-слепок каждой страницы и вставляет его
  в специальный контейнер <div id="flutter-target"> в шаблоне index.html.
  Это позволяет браузеру мгновенно отрисовать контент, пока в фоне
  загружается основное Flutter-приложение.

  Порядок запуска:
  1. flutter build web или flutter build web --no-web-resources-cdn
  2. cd prerender_tool
  3. dart run hydrate_prerender.dart
*/

import 'dart:io';
import 'package:puppeteer/puppeteer.dart';
import 'package:path/path.dart' as path;
import 'meta_tags.dart';

// --- НАСТРОЙКИ ---

const routes = [
  '/about',
  '/portfolio',
];

const baseUrl = 'http://localhost:8080';
const productionUrl = 'https://shastovsky.com'; // URL вашего сайта
const buildDir = '../build/web'; // Папка со сборкой
const waitSeconds = 200; // Увеличенное время ожидания для сложных страниц

// --- ОСНОВНАЯ ЛОГИКА ---

Future<void> main() async {
  print('Запускаем сервер для пререндеринга на $baseUrl...');
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  _serveBuildDirectory(server);

  print('Запускаем Headless Chrome...');
  final browser = await puppeteer.launch(
    headless: true,
    args: [
      '--no-sandbox',
      '--disable-setuid-sandbox',
      // Используем новый режим headless, он стабильнее
      '--headless=new',
      // Эти флаги больше не критичны, но и не мешают
      '--disable-gpu',
      '--use-gl=angle',
      '--use-angle=gl',
    ],
  );

  final templateFile = File('../web/index.html');
  if (!await templateFile.exists()) {
    print('ОШИБКА: Файл-шаблон web/index.html не найден.');
    await browser.close();
    await server.close(force: true);
    throw StateError('Не найден шаблон web/index.html для пререндеринга.');
  }
  final templateContent = await templateFile.readAsString();
  final allRoutes = ['/', ...routes];
  final failedRoutes = <String>[];

  for (final route in allRoutes) {
    print('Рендерим роут: $route');
    final context = await browser.createIncognitoBrowserContext();
    final page = await context.newPage();

    page.onConsole.listen((msg) {
      if (msg.type != ConsoleMessageType.warning &&
          !msg.text!.contains('Download the Flutter DevTools')) {
        print('CONSOLE BROWSER [${msg.type}]: ${msg.text}');
      }
    });

    try {
      await page.goto('$baseUrl$route', wait: Until.networkIdle);
      print('Ждем $waitSeconds секунд на полную отрисовку Flutter...');
      await Future.delayed(const Duration(seconds: waitSeconds));

      // --- ИЗМЕНЕНИЕ: ИЗВЛЕКАЕМ СЕМАНТИЧЕСКОЕ ДЕРЕВО ---
      final prerenderedBodyContent = await page.evaluate<String>(r'''() => {
        // Ищем контейнер семантики, который не зависит от WebGL.
        const semanticsHost = document.querySelector("flt-semantics-host");
        return semanticsHost ? semanticsHost.innerHTML : '<!-- Semantics Host Not Found -->';
      }''');
      final pageMetadataJson =
          await page.evaluate<String>(r'''() => JSON.stringify({
        title: document.title,
        metaTitle: document.querySelector('meta[name="title"]')?.content ?? '',
        description: document.querySelector('meta[name="description"]')?.content ?? '',
        openGraphTitle: document.querySelector('meta[property="og:title"]')?.content ?? '',
        openGraphDescription: document.querySelector('meta[property="og:description"]')?.content ?? '',
        openGraphImage: document.querySelector('meta[property="og:image"]')?.content ?? '',
      })''');

      if (prerenderedBodyContent.contains('Semantics Host Not Found') ||
          prerenderedBodyContent.trim().isEmpty) {
        throw StateError('На странице $route не найден семантический HTML.');
      }
      print('✅ Семантический HTML успешно извлечен для $route.');

      // =================== НОВАЯ ЛОГИКА СБОРКИ HTML ===================
      // Создаем HTML-блок, который заменит #flutter-target в шаблоне.
      // Внутрь этого блока мы помещаем наш "снимок" рендера.
      final replacementBlock = '''
<div id="flutter-target" style="width: 100%; height: 100%;">
  $prerenderedBodyContent
</div>
''';

      var finalContent = templateContent;

      const startMarker = '<!-- PRERENDER_TARGET_START -->';
      const endMarker = '<!-- PRERENDER_TARGET_END -->';
      finalContent = _replaceBetweenMarkers(
        finalContent,
        startMarker,
        endMarker,
        replacementBlock,
      );

      final depth = route.split('/').where((s) => s.isNotEmpty).length;
      final baseHref = route == '/' ? '/' : '../' * depth;
      const baseHrefTemplate = r'<base href="$FLUTTER_BASE_HREF">';
      if (!finalContent.contains(baseHrefTemplate)) {
        throw StateError('В web/index.html не найден base href Flutter.');
      }
      finalContent = finalContent.replaceFirst(
          baseHrefTemplate, '<base href="$baseHref">');
      finalContent = applyPrerenderedMetadata(
        finalContent,
        pageMetadataJson,
        canonicalUrl: '$productionUrl$route',
      );
      // ===============================================================

      print('Заменяем $baseUrl на $productionUrl...');
      finalContent = finalContent.replaceAll(baseUrl, productionUrl);

      final dirPath = path.join(buildDir, route.substring(1));
      final directory = Directory(dirPath);
      if (!await directory.exists()) await directory.create(recursive: true);

      final filePath = path.join(dirPath, 'index.html');
      await File(filePath).writeAsString(finalContent);
      print('Сохранено в: $filePath');
    } catch (e) {
      print('ОШИБКА при обработке роута $route: $e');
      failedRoutes.add(route);
    } finally {
      await page.close();
      await context.close();
    }
  }

  print('Пререндеринг для гидратации завершен!');
  await browser.close();
  await server.close(force: true);
  if (failedRoutes.isNotEmpty) {
    throw StateError(
        'Не удалось пререндерить маршруты: ${failedRoutes.join(', ')}');
  }
}

String _replaceBetweenMarkers(
  String content,
  String startMarker,
  String endMarker,
  String replacement,
) {
  final startMarkerIndex = content.indexOf(startMarker);
  if (startMarkerIndex < 0) {
    throw StateError('В web/index.html не найден маркер $startMarker.');
  }

  final contentStart = startMarkerIndex + startMarker.length;
  final contentEnd = content.indexOf(endMarker, contentStart);
  if (contentEnd < contentStart) {
    throw StateError('В web/index.html не найден маркер $endMarker.');
  }

  return content.replaceRange(contentStart, contentEnd, '\n$replacement\n');
}

// --- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ (без изменений) ---

void _serveBuildDirectory(HttpServer server) {
  server.listen((request) async {
    final cleanPath =
        request.uri.path == '/' ? '/index.html' : request.uri.path;
    final decodedPath = Uri.decodeComponent(cleanPath);
    final filePath =
        path.join(Directory.current.path, buildDir, decodedPath.substring(1));
    final file = File(filePath);

    if (await file.exists()) {
      try {
        request.response.headers.contentType = _getContentType(filePath);
        await file.openRead().pipe(request.response);
      } catch (e) {
        print("Ошибка при отдаче файла: $e");
        request.response.statusCode = HttpStatus.internalServerError;
        await request.response.close();
      }
    } else {
      final indexFile =
          File(path.join(Directory.current.path, buildDir, 'index.html'));
      if (await indexFile.exists()) {
        request.response.headers.contentType = ContentType.html;
        await indexFile.openRead().pipe(request.response);
      } else {
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
      }
    }
  });
}

ContentType _getContentType(String filePath) {
  final extension = path.extension(filePath).toLowerCase();
  switch (extension) {
    case '.js':
      return ContentType('application', 'javascript', charset: 'utf-8');
    case '.css':
      return ContentType('text', 'css', charset: 'utf-8');
    case '.html':
      return ContentType.html;
    case '.webp':
      return ContentType('image', 'webp');
    case '.svg':
      return ContentType('image', 'svg+xml');
    case '.json':
      return ContentType.json;
    case '.ttf':
    case '.otf':
      return ContentType('application', 'font-sfnt');
    default:
      return ContentType('application', 'octet-stream');
  }
}
