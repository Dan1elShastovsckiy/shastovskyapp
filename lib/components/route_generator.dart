// lib/components/route_generator.dart

import 'package:flutter/material.dart';
import 'package:minimal/pages/pages.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) {
        // <<< ИЗМЕНЕНИЕ: Теперь мы берем полный путь без обрезки >>>
        final String pathName = Uri.parse(settings.name ?? '/').path;

        return SelectionArea(
          // <<< ИЗМЕНЕНИЕ: Switch теперь работает с полными, вложенными путями >>>
          child: switch (pathName) {
            '/' || '/${ListPage.name}' => const ListPage(),
            '/${PostPage.name}' => const PostPage(),
            '/${PostGeorgiaPage.name}' => const PostGeorgiaPage(),

            // --- Новая вложенная структура ---
            '/${UsefulPage.name}' => const UsefulPage(),
            '/${UsefulDevPage.name}' => const UsefulDevPage(),
            '/${UsefulSeoPage.name}' => const UsefulSeoPage(),
            '/${TryCodingPage.name}' => const TryCodingPage(), // <-- ДОБАВИТЬ
            '/${HtmlSandboxPage.name}' => const HtmlSandboxPage(), // Новый маршрут для HTML & CSS песочницы
            //'/${JsSandboxPage.name}' => const JsSandboxPage(), // будущий маршрут для JS
            '/${SeoToolsPage.name}' =>
              const SeoToolsPage(), // Новый маршрут для страницы SEO инструментов
            '/${PostFlutterSeoPage.name}' => const PostFlutterSeoPage(),
            '/${PostStateManagementPage.name}' =>
              const PostStateManagementPage(),
            '/${DesignPatternsPage.name}' => const DesignPatternsPage(),
            '/${PostSeoAiPage.name}' => const PostSeoAiPage(),
            '/${PostEeatGuidePage.name}' => const PostEeatGuidePage(),
            '/${PostLinkbuildingPage.name}' => const PostLinkbuildingPage(),
            '/${PostTechnicalAuditPage.name}' => const PostTechnicalAuditPage(),
            '/${AboutPage.name}' => const AboutPage(),
            '/${PortfolioPage.name}' => const PortfolioPage(),
            '/${TypographyPage.name}' => const TypographyPage(),
            '/${ContactsPage.name}' => const ContactsPage(),
            '/${PageUnderConstruction.name}' => PageUnderConstruction(
                title:
                    (settings.arguments as Map<String, dynamic>?)?['title'] ??
                        'Страница в разработке',
                postTitle: 'Страница в разработке',
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
