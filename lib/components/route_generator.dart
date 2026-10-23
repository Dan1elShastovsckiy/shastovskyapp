// /lib/components/route_generator.dart

import 'package:flutter/material.dart';
import 'package:minimal/pages/page_instruments.dart';
import 'package:minimal/pages/page_leaderboard.dart';
import 'package:minimal/pages/pages.dart';
import 'package:minimal/pages/pages_instruments/page_seo_forecast.dart';
import 'package:minimal/pages/pages_instruments/page_seo_analyzer.dart';
import 'package:minimal/pages/pages_instruments/page_seo_analyzer_en.dart';
import 'package:minimal/pages/page_saved_reports.dart';

class RouteGenerator {
  // Карта для всех СТАТИЧЕСКИХ роутов.
  // Обратите внимание: SeoForecastPage отсюда удален, так как он теперь обрабатывается динамически.
  static final Map<String, WidgetBuilder> _routes = {
    '/': (context) => const ListPage(),
    '/${ListPage.name}': (context) => const ListPage(),

    // Роуты авторизации
    '/${LoginPage.name}': (context) => const LoginPage(),
    '/${RegisterPage.name}': (context) => const RegisterPage(),
    '/${ForgotPasswordPage.name}': (context) => const ForgotPasswordPage(),
    '/${AccountPage.name}': (context) => const AccountPage(),
    '/${SavedReportsPage.name}': (context) => const SavedReportsPage(),

    // Существующие роуты PostJordanPage
    '/${UsefulPage.name}': (context) => const UsefulPage(),
    '/${UsefulDevPage.name}': (context) => const UsefulDevPage(),
    '/${UsefulSeoPage.name}': (context) => const UsefulSeoPage(),
    '/${TryCodingPage.name}': (context) => const TryCodingPage(),
    '/${InstrumentsPage.name}': (context) => const InstrumentsPage(),
    '/${PostPage.name}': (context) => const PostPage(),
    '/${PostSriLankaPage.name}': (context) => const PostSriLankaPage(),
    '/${PostGeorgiaPage.name}': (context) => const PostGeorgiaPage(),
    '/${PostJordanPage.name}': (context) => const PostJordanPage(),
    '/${HtmlSandboxPage.name}': (context) => const HtmlSandboxPage(),
    '/${SeoToolsPage.name}': (context) => const SeoToolsPage(),
    '/${SemanticCoreGuidePage.name}': (context) =>
        const SemanticCoreGuidePage(),
    '/${PostFlutterSeoPage.name}': (context) => const PostFlutterSeoPage(),
    '/${PostStateManagementPage.name}': (context) =>
        const PostStateManagementPage(),
    '/${PostSeoAnalyzerDevStory.name}': (context) =>
        const PostSeoAnalyzerDevStory(),
    '/${PostForecastDevStory.name}': (context) =>
        const PostForecastDevStory(), // Новая страница истории разработки
    '/${DesignPatternsPage.name}': (context) => const DesignPatternsPage(),
    '/${PostSeoAiPage.name}': (context) => const PostSeoAiPage(),
    '/${PostEeatGuidePage.name}': (context) => const PostEeatGuidePage(),
    '/${PostLinkbuildingPage.name}': (context) => const PostLinkbuildingPage(),
    '/${PostTechnicalAuditPage.name}': (context) =>
        const PostTechnicalAuditPage(),
    '/${SitemapGuidePage.name}': (context) => const SitemapGuidePage(),
    '/${SeoAnalyzerPage.name}': (context) => const SeoAnalyzerPage(),
    '/${SeoAnalyzerPageEn.name}': (context) => const SeoAnalyzerPageEn(),
    // '${SeoForecastPage.name}': (context) => const SeoForecastPage(), // <--- УДАЛЕНО ОТСЮДА LeaderboardPage
    '/${LeaderboardPage.name}': (context) => const LeaderboardPage(),
    '/${AboutPage.name}': (context) => const AboutPage(),
    '/${PortfolioPage.name}': (context) => const PortfolioPage(),
    '/${TypographyPage.name}': (context) => const TypographyPage(),
    '/${ContactsPage.name}': (context) => const ContactsPage(),
    '/${CopyrightPage.name}': (context) => const CopyrightPage(),
    '/${FaviSnakePage.name}': (context) => const FaviSnakePage(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) {
        // Используем URI для удобного парсинга пути и его сегментов
        final uri = Uri.parse(settings.name ?? '/');
        final rawPath = uri.path.isEmpty ? '/' : uri.path;
        final pathName = rawPath.length > 1
            ? rawPath.replaceFirst(RegExp(r'/+$'), '')
            : rawPath;
        final pathSegments =
            uri.pathSegments.where((segment) => segment.isNotEmpty).toList();
        Widget page;

        // --- НАЧАЛО НОВОЙ ЛОГИКИ ДЛЯ ДИНАМИЧЕСКИХ РОУТОВ ---

        // Проверяем, относится ли URL к странице прогноза
        // pathName.startsWith более надежен, чем прямое сравнение
        final forecastSegments = SeoForecastPage.name.split('/');
        final isForecastPath = pathSegments.length >= forecastSegments.length &&
            pathSegments.take(forecastSegments.length).join('/') ==
                SeoForecastPage.name;

        if (isForecastPath) {
          if (pathSegments.length == forecastSegments.length) {
            page = const SeoForecastPage();
          } else if (pathSegments.length == forecastSegments.length + 1 &&
              pathSegments.last.isNotEmpty) {
            final reportId = pathSegments.last;
            page = SeoForecastPage(reportId: reportId);
          } else {
            page = const PageNotFound();
          }
        }

        // --- КОНЕЦ НОВОЙ ЛОГИКИ ---

        // Если роут не был обработан динамически, ищем его в статической карте
        else if (_routes.containsKey(pathName)) {
          page = _routes[pathName]!(context);
        }
        // Отдельно обрабатываем роут со сложными аргументами (ваша существующая логика)
        else if (pathName == '/${PageUnderConstruction.name}') {
          final arguments = settings.arguments;
          final argumentTitle = arguments is Map ? arguments['title'] : null;
          final requestedTitle = argumentTitle is String
              ? argumentTitle
              : uri.queryParameters['title'];
          final title = requestedTitle?.trim().isNotEmpty == true
              ? requestedTitle!.trim()
              : 'Страница в разработке';
          page = PageUnderConstruction(postTitle: title);
        }
        // Если ничего не найдено - 404
        else {
          page = const PageNotFound();
        }

        // Оборачиваем любую страницу в SelectionArea, как и было
        return SelectionArea(
          child: page,
        );
      },
      // Сохраняем ваше требование по отсутствию анимации перехода
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }
}
