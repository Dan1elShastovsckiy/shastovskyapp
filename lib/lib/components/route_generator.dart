// lib/components/route_generator.dart

import 'package:flutter/material.dart';
import 'package:minimal/pages/pages.dart'; // Этот импорт должен давать доступ и к PostGeorgiaPage
import 'package:responsive_framework/responsive_framework.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) {
        // Убираем print, он нам больше не нужен
        final Uri uri = Uri.parse(settings.name ?? '/');
        final String pathName = uri.path.startsWith('/') && uri.path.length > 1
            ? uri.path.substring(1)
            : uri.path;

        return SelectionArea(
          child: switch (pathName) {
            '/' ||
            ListPage.name =>
              const ListPage(), // ListPage - это const, убрал лишнее

            PostPage.name => const ResponsiveBreakpoints(
                breakpoints: [
                  Breakpoint(start: 0, end: 480, name: MOBILE),
                  Breakpoint(start: 481, end: 1200, name: TABLET),
                  Breakpoint(start: 1201, end: double.infinity, name: DESKTOP),
                ],
                child: PostPage(),
              ),

            // --- НОВОЕ ПРАВИЛО ДЛЯ СТРАНИЦЫ О ГРУЗИИ ---
            PostGeorgiaPage.name => const PostGeorgiaPage(),
            // ---------------------------------------------

            AboutPage.name => const AboutPage(),
            PortfolioPage.name => const PortfolioPage(),
            TypographyPage.name => const TypographyPage(),
            ContactsPage.name => const ContactsPage(),
            PageUnderConstruction.name => PageUnderConstruction(
                postTitle:
                    (settings.arguments as Map<String, dynamic>?)?['title'] ??
                        'Статья в разработке',
                title: null,
              ),

            // Обработка всех остальных случаев
            _ => const PageNotFound(),
          },
        );
      },
      // Убираем анимацию перехода
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }
}
