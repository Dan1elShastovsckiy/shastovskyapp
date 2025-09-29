// lib/components/route_generator.dart

import 'package:flutter/foundation.dart'; // <<< ИМПОРТ ДЛЯ kReleaseMode
import 'package:flutter/material.dart';
import 'deferred_loader.dart';

// импорты, сохранены без изменений
import 'package:minimal/pages/page_list.dart';
import 'package:minimal/pages/page_useful.dart';
import 'package:minimal/pages/page_useful_dev.dart';
import 'package:minimal/pages/page_useful_seo.dart';
import 'package:minimal/pages/page_try_coding.dart';
import 'package:minimal/pages/page_not_found.dart';
import 'package:minimal/pages/page_copyright.dart';
import 'package:minimal/pages/page_favisnake.dart';
import 'package:minimal/pages/page_post.dart' deferred as post_page;
import 'package:minimal/pages/page_georgia_post.dart'
    deferred as georgia_post_page;
import 'package:minimal/pages/page_html_sandbox.dart'
    deferred as html_sandbox_page;
import 'package:minimal/pages/pages_useful/page_seo_tools.dart'
    deferred as seo_tools_page;
import 'package:minimal/pages/pages_useful/page_flutter_seo_post.dart'
    deferred as flutter_seo_post_page;
import 'package:minimal/pages/pages_useful/page_state_management_post.dart'
    deferred as state_management_post_page;
import 'package:minimal/pages/pages_useful/page_design_patterns.dart'
    deferred as design_patterns_page;
import 'package:minimal/pages/pages_useful/page_seo_ai_post.dart'
    deferred as seo_ai_page;
import 'package:minimal/pages/pages_useful/page_eeat_guide_post.dart'
    deferred as eeat_guide_page;
import 'package:minimal/pages/pages_useful/page_linkbuilding_post.dart'
    deferred as linkbuilding_page;
import 'package:minimal/pages/pages_useful/page_technical_audit_post.dart'
    deferred as technical_audit_page;
import 'package:minimal/pages/page_about.dart' deferred as about_page;
import 'package:minimal/pages/page_portfolio.dart' deferred as portfolio_page;
import 'package:minimal/pages/page_typography.dart' deferred as typography_page;
import 'package:minimal/pages/page_contacts.dart' deferred as contacts_page;
import 'package:minimal/pages/page_under_construction.dart'
    deferred as under_construction_page;

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) {
        final String pathName = Uri.parse(settings.name ?? '/').path;
        // <<< НАЧАЛО БЛОКА БЕЗ ОТЛОЖЕННОЙ ЗАГРУЗКИ >>>
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
        }

        // <<< НАЧАЛО БЛОКА С ПРОВЕРКОЙ kReleaseMode >>>
        else if (pathName == '/${post_page.PostPage.name}') {
          page = kReleaseMode
              ? DeferredLoader(
                  libraryLoader: post_page.loadLibrary,
                  widgetBuilder: () => post_page.PostPage())
              : post_page.PostPage();
        } else if (pathName == '/${georgia_post_page.PostGeorgiaPage.name}') {
          page = kReleaseMode
              ? DeferredLoader(
                  libraryLoader: georgia_post_page.loadLibrary,
                  widgetBuilder: () => georgia_post_page.PostGeorgiaPage())
              : georgia_post_page.PostGeorgiaPage();
        } else if (pathName == '/${html_sandbox_page.HtmlSandboxPage.name}') {
          page = kReleaseMode
              ? DeferredLoader(
                  libraryLoader: html_sandbox_page.loadLibrary,
                  widgetBuilder: () => html_sandbox_page.HtmlSandboxPage())
              : html_sandbox_page.HtmlSandboxPage();
        } else if (pathName == '/${seo_tools_page.SeoToolsPage.name}') {
          page = kReleaseMode
              ? DeferredLoader(
                  libraryLoader: seo_tools_page.loadLibrary,
                  widgetBuilder: () => seo_tools_page.SeoToolsPage())
              : seo_tools_page.SeoToolsPage();
        } else if (pathName ==
            '/${flutter_seo_post_page.PostFlutterSeoPage.name}') {
          page = kReleaseMode
              ? DeferredLoader(
                  libraryLoader: flutter_seo_post_page.loadLibrary,
                  widgetBuilder: () =>
                      flutter_seo_post_page.PostFlutterSeoPage())
              : flutter_seo_post_page.PostFlutterSeoPage();
        } else if (pathName ==
            '/${state_management_post_page.PostStateManagementPage.name}') {
          page = kReleaseMode
              ? DeferredLoader(
                  libraryLoader: state_management_post_page.loadLibrary,
                  widgetBuilder: () =>
                      state_management_post_page.PostStateManagementPage())
              : state_management_post_page.PostStateManagementPage();
        } else if (pathName ==
            '/${design_patterns_page.DesignPatternsPage.name}') {
          page = kReleaseMode
              ? DeferredLoader(
                  libraryLoader: design_patterns_page.loadLibrary,
                  widgetBuilder: () =>
                      design_patterns_page.DesignPatternsPage())
              : design_patterns_page.DesignPatternsPage();
        } else if (pathName == '/${seo_ai_page.PostSeoAiPage.name}') {
          page = kReleaseMode
              ? DeferredLoader(
                  libraryLoader: seo_ai_page.loadLibrary,
                  widgetBuilder: () => seo_ai_page.PostSeoAiPage())
              : seo_ai_page.PostSeoAiPage();
        } else if (pathName == '/${eeat_guide_page.PostEeatGuidePage.name}') {
          page = kReleaseMode
              ? DeferredLoader(
                  libraryLoader: eeat_guide_page.loadLibrary,
                  widgetBuilder: () => eeat_guide_page.PostEeatGuidePage())
              : eeat_guide_page.PostEeatGuidePage();
        } else if (pathName ==
            '/${linkbuilding_page.PostLinkbuildingPage.name}') {
          page = kReleaseMode
              ? DeferredLoader(
                  libraryLoader: linkbuilding_page.loadLibrary,
                  widgetBuilder: () => linkbuilding_page.PostLinkbuildingPage())
              : linkbuilding_page.PostLinkbuildingPage();
        } else if (pathName ==
            '/${technical_audit_page.PostTechnicalAuditPage.name}') {
          page = kReleaseMode
              ? DeferredLoader(
                  libraryLoader: technical_audit_page.loadLibrary,
                  widgetBuilder: () =>
                      technical_audit_page.PostTechnicalAuditPage())
              : technical_audit_page.PostTechnicalAuditPage();
        } else if (pathName == '/${about_page.AboutPage.name}') {
          page = kReleaseMode
              ? DeferredLoader(
                  libraryLoader: about_page.loadLibrary,
                  widgetBuilder: () => about_page.AboutPage())
              : about_page.AboutPage();
        } else if (pathName == '/${portfolio_page.PortfolioPage.name}') {
          page = kReleaseMode
              ? DeferredLoader(
                  libraryLoader: portfolio_page.loadLibrary,
                  widgetBuilder: () => portfolio_page.PortfolioPage())
              : portfolio_page.PortfolioPage();
        } else if (pathName == '/${typography_page.TypographyPage.name}') {
          page = kReleaseMode
              ? DeferredLoader(
                  libraryLoader: typography_page.loadLibrary,
                  widgetBuilder: () => typography_page.TypographyPage())
              : typography_page.TypographyPage();
        } else if (pathName == '/${contacts_page.ContactsPage.name}') {
          page = kReleaseMode
              ? DeferredLoader(
                  libraryLoader: contacts_page.loadLibrary,
                  widgetBuilder: () => contacts_page.ContactsPage())
              : contacts_page.ContactsPage();
        } else if (pathName == '/${CopyrightPage.name}') {
          // <<< новый БЛОК для копирайта >>>
          page = const CopyrightPage();
        } else if (pathName == '/${FaviSnakePage.name}') {
          // <<< новый БЛОК для FaviSnake >>>
          page = const FaviSnakePage();
        } else if (pathName ==
            '/${under_construction_page.PageUnderConstruction.name}') {
          final pageBuilder = () =>
              under_construction_page.PageUnderConstruction(
                title:
                    (settings.arguments as Map<String, dynamic>?)?['title'] ??
                        'Страница в разработке',
                postTitle: 'Страница в разработке',
              );
          page = kReleaseMode
              ? DeferredLoader(
                  libraryLoader: under_construction_page.loadLibrary,
                  widgetBuilder: pageBuilder)
              : pageBuilder();
        }
        // <<< КОНЕЦ БЛОКА С ПРОВЕРКОЙ kReleaseMode >>>

        else {
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
