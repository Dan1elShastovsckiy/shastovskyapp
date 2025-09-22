// lib/components/route_generator.dart

import 'package:flutter/material.dart';
import 'package:minimal/pages/pages.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) {
        final Uri uri = Uri.parse(settings.name ?? '/');
        final String pathName = uri.path.startsWith('/') && uri.path.length > 1
            ? uri.path.substring(1)
            : uri.path;

        return SelectionArea(
          child: switch (pathName) {
            '/' || ListPage.name => const ListPage(),
            PostPage.name => const PostPage(),
            PostGeorgiaPage.name => const PostGeorgiaPage(),

            // Новые маршруты
            UsefulPage.name => const UsefulPage(),
            UsefulDevPage.name => const UsefulDevPage(),
            UsefulSeoPage.name => const UsefulSeoPage(),
            PostSeoAiPage.name => const PostSeoAiPage(),
            AboutPage.name => const AboutPage(),
            PortfolioPage.name => const PortfolioPage(),
            TypographyPage.name => const TypographyPage(),
            ContactsPage.name => const ContactsPage(),
            PageUnderConstruction.name => PageUnderConstruction(
                title: (settings.arguments as Map<String, dynamic>?)?['title'] ?? 'Страница в разработке', postTitle: 'Страница в разработке',
              ),
            _ => const PageNotFound(),
          },
        );
      },
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }
}