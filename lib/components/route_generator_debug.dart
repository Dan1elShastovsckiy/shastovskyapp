// /lib/components/route_generator_debug.dart

import 'package:flutter/material.dart';
import 'package:minimal/pages/pages.dart';
// Импорты всех страниц без отложенной загрузки

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) {
        final String pathName = Uri.parse(settings.name ?? '/').path;
        Widget page;

        if (pathName == '/' || pathName == '/${ListPage.name}') {
          page = const ListPage();
        } else if (pathName == '/${UsefulPage.name}') {
          page = const UsefulPage();
        } else if (pathName == '/${UsefulDevPage.name}') {
          page = const UsefulDevPage();
        } else if (pathName == '/${UsefulSeoPage.name}') {
          page = const UsefulSeoPage();
        } else if (pathName == '/${TryCodingPage.name}') {
          page = const TryCodingPage();
        } else if (pathName == '/${PostPage.name}') {
          page = const PostPage();
        } else if (pathName == '/${PostGeorgiaPage.name}') {
          page = const PostGeorgiaPage();
        } else if (pathName == '/${HtmlSandboxPage.name}') {
          page = const HtmlSandboxPage();
        } else if (pathName == '/${SeoToolsPage.name}') {
          page = const SeoToolsPage();
        } else if (pathName == '/${PostFlutterSeoPage.name}') {
          page = const PostFlutterSeoPage();
        } else if (pathName == '/${PostStateManagementPage.name}') {
          page = const PostStateManagementPage();
        } else if (pathName == '/${DesignPatternsPage.name}') {
          page = const DesignPatternsPage();
        } else if (pathName == '/${PostSeoAiPage.name}') {
          page = const PostSeoAiPage();
        } else if (pathName == '/${PostEeatGuidePage.name}') {
          page = const PostEeatGuidePage();
        } else if (pathName == '/${PostLinkbuildingPage.name}') {
          page = const PostLinkbuildingPage();
        } else if (pathName == '/${PostTechnicalAuditPage.name}') {
          page = const PostTechnicalAuditPage();
        } else if (pathName == '/${AboutPage.name}') {
          page = const AboutPage();
        } else if (pathName == '/${PortfolioPage.name}') {
          page = const PortfolioPage();
        } else if (pathName == '/${TypographyPage.name}') {
          page = const TypographyPage();
        } else if (pathName == '/${ContactsPage.name}') {
          page = const ContactsPage();
        } else if (pathName == '/${CopyrightPage.name}') {
          page = const CopyrightPage();
        } else if (pathName == '/${FaviSnakePage.name}') {
          page = const FaviSnakePage();
        } else if (pathName == '/${PageUnderConstruction.name}') {
          page = PageUnderConstruction(
            title: (settings.arguments as Map<String, dynamic>?)?['title'] ??
                'Страница в разработке',
            postTitle: 'Страница в разработке',
          );
        } else {
          page = const PageNotFound();
        }

        return SelectionArea(
          child: page,
        );
      },
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }
}
