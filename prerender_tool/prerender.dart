// prerender_tool/prerender.dart
/*
  Этот скрипт пререндерит указанные маршруты Flutter веб-приложения,
  используя Headless Chrome через Puppeteer. Он сохраняет сгенерированные HTML-файлы
  в соответствующие директории внутри build/web.
flutter build web
cd prerender_tool
dart run prerender.dart
*/

import 'dart:io';
import 'package:puppeteer/puppeteer.dart';
import 'package:path/path.dart' as path;
import 'meta_tags.dart';

const routes = [
  '/about',
  '/about-app',
  '/contacts',
  '/copyright',
  '/portfolio',
  '/under_construction',
  '/useful',
  '/useful/dev',
  '/useful/seo',
  '/useful/instruments',
  '/useful/instruments/seo-analyzer',
  '/useful/instruments/seo-analyzer-en',
  '/useful/instruments/seo-forecast',
  '/useful/try-coding',
  '/useful/try-coding/html-css-sandbox',
  '/marocco',
  '/jordan',
  '/sri-lanka',
  '/georgia-part1',
  '/useful/dev/flutter-web-seo',
  '/useful/dev/flutter-state-management',
  '/useful/dev/design-patterns',
  '/useful/dev/seo-analyzer-story',
  '/useful/dev/seo-forecast-story',
  '/useful/seo/seo-ai-era',
  '/useful/seo/eeat-guide',
  '/useful/seo/linkbuilding-strategies',
  '/useful/seo/technical-audit-checklist',
  '/useful/seo/semantic-core-guide',
  '/useful/seo/sitemap-guide',
  '/useful/seo/tools',
  '/fluttersnake',
  '/leaderboard',
];

const baseUrl = 'http://localhost:8080';
const productionUrl = 'https://shastovsky.com'; // <<< КОНСТАНТА ДЛЯ ЗАМЕНЫ
const buildDir = '../build/web';

Future<void> main() async {
  print('Запускаем сервер для пререндеринга на $baseUrl...');
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  _serveBuildDirectory(server);

  print('Запускаем Headless Chrome...');
  final browser = await puppeteer.launch(headless: true);

  // <<< ИЗМЕНЕНИЕ: Шаблоном снова является web/index.html, как было в рабочей версии >>>
  final templateFile = File('../web/index.html'); // Путь к исходному шаблону
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
      if (msg.type != ConsoleMessageType.warning) {
        print('CONSOLE BROWSER [${msg.type}]: ${msg.text}');
      }
    });
    page.onError.listen((error) => print('PAGE ERROR: $error'));
    page.onRequestFailed.listen((request) {
      if (request.url.startsWith(baseUrl)) {
        print('REQUEST FAILED: ${request.url} (${request.failure})');
      }
    });
    try {
      await page.goto('$baseUrl$route?prerender=true',
          wait: Until.domContentLoaded);

      print('Ждем семантический контент страницы...');
      final prerenderedHtml = await _waitForPrerenderedHtml(page);
      final pageMetadataJson =
          await page.evaluate<String>(r'''() => JSON.stringify({
        title: document.title,
        metaTitle: document.querySelector('meta[name="title"]')?.content ?? '',
        description: document.querySelector('meta[name="description"]')?.content ?? '',
        openGraphTitle: document.querySelector('meta[property="og:title"]')?.content ?? '',
        openGraphDescription: document.querySelector('meta[property="og:description"]')?.content ?? '',
        openGraphImage: document.querySelector('meta[property="og:image"]')?.content ?? '',
      })''');

      if (prerenderedHtml.contains('Prerender container not found') ||
          prerenderedHtml.trim().isEmpty) {
        throw StateError('На странице $route не найден семантический контент.');
      }
      if (route == '/' && !prerenderedHtml.contains('<h1')) {
        throw StateError('На главной странице не найден семантический H1.');
      }
      print('✅ Семантический контент успешно извлечен для $route.');

      final depth = route.split('/').where((s) => s.isNotEmpty).length;
      final baseHref = route == '/' ? '/' : '../' * depth;
      const baseHrefTemplate = r'<base href="$FLUTTER_BASE_HREF">';
      const prerenderContainerTemplate =
          '<div id="prerender-container" style="display: none;"></div>';
      if (!templateContent.contains(baseHrefTemplate) ||
          !templateContent.contains(prerenderContainerTemplate)) {
        throw StateError(
            'В web/index.html не найдены ожидаемые base/prerender элементы.');
      }

      var finalContent = templateContent
          .replaceFirst(baseHrefTemplate, '<base href="$baseHref">')
          .replaceFirst(prerenderContainerTemplate,
              '<div id="prerender-container" style="display: none;">$prerenderedHtml</div>')
          .replaceFirst(
              RegExp(r'<noscript>[\s\S]*?</noscript>'), // Находим noscript
              '<noscript>\n$prerenderedHtml\n</noscript>');
      finalContent = applyPrerenderedMetadata(
        finalContent,
        pageMetadataJson,
        canonicalUrl: '$productionUrl$route',
      );

      if (finalContent.contains(r'$FLUTTER_BASE_HREF') ||
          RegExp(r'<script\b[^>]*src=[^>]*main\.dart\.js', caseSensitive: false)
              .hasMatch(finalContent) ||
          !finalContent.contains(
              '<div id="prerender-container" style="display: none;">$prerenderedHtml</div>')) {
        throw StateError('Не удалось безопасно собрать HTML для $route.');
      }

      // <<< ВОТ НУЖНОЕ ВАМ ДОПОЛНИТЕЛЬНОЕ ДЕЙСТВИЕ >>>
      // После всех манипуляций, глобально заменяем localhost на ваш домен.
      print('Заменяем $baseUrl на $productionUrl...');
      finalContent = finalContent.replaceAll(baseUrl, productionUrl);

      final dirPath = path.join(buildDir, route.substring(1));
      final directory = Directory(dirPath);
      if (!await directory.exists()) await directory.create(recursive: true);
      final filePath = path.join(dirPath, 'index.html');

      final file = File(filePath);
      await file.writeAsString(finalContent);

      print('Сохранено в: $filePath');
    } catch (e) {
      failedRoutes.add(route);
      print('ОШИБКА при обработке роута $route: $e');
    } finally {
      await page.close();
      await context.close();
    }
  }

  print('Пререндеринг завершен!');
  await browser.close();
  await server.close(force: true);
  if (failedRoutes.isNotEmpty) {
    throw StateError(
        'Не удалось пререндерить маршруты: ${failedRoutes.join(', ')}');
  }
}

Future<String> _waitForPrerenderedHtml(Page page) async {
  final deadline = DateTime.now().add(const Duration(seconds: 20));
  String? previousHtml;
  var stableChecks = 0;

  while (DateTime.now().isBefore(deadline)) {
    final html = await page.evaluate<String>(r'''() => {
      const container = document.getElementById('prerender-container');
      return container ? container.innerHTML : '';
    }''');

    if (html.trim().isNotEmpty) {
      if (html == previousHtml) {
        stableChecks++;
        if (stableChecks >= 2) return html;
      } else {
        previousHtml = html;
        stableChecks = 0;
      }
    }

    await Future.delayed(const Duration(milliseconds: 300));
  }

  throw StateError('Семантический контент страницы не появился за 20 секунд.');
}

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
    case '.wasm':
      return ContentType('application', 'wasm');
    case '.ttf':
    case '.otf':
      return ContentType('application', 'font-sfnt');
    default:
      return ContentType('application', 'octet-stream');
  }
}
