// /lib/components/route_generator.dart

import 'package:flutter/material.dart';
import 'package:minimal/pages/page_instruments.dart';

// --- ИМПОРТИРУЕМ ВСЕ СТРАНИЦЫ НАПРЯМУЮ, БЕЗ `deferred as` ---
import 'package:minimal/pages/page_list.dart';
import 'package:minimal/pages/page_useful.dart';
import 'package:minimal/pages/page_useful_dev.dart';
import 'package:minimal/pages/page_useful_seo.dart';
import 'package:minimal/pages/page_try_coding.dart';
import 'package:minimal/pages/page_not_found.dart';
import 'package:minimal/pages/page_post.dart';
import 'package:minimal/pages/page_georgia_post.dart';
import 'package:minimal/pages/page_html_sandbox.dart';
import 'package:minimal/pages/pages_useful/dev/page_seo_analyzer_dev_story.dart';
import 'package:minimal/pages/pages_useful/page_semantic_core_guide.dart';
import 'package:minimal/pages/pages_useful/page_seo_analyzer_en.dart';
import 'package:minimal/pages/pages_useful/page_seo_tools.dart';
import 'package:minimal/pages/pages_useful/page_flutter_seo_post.dart';
import 'package:minimal/pages/pages_useful/page_sitemap_guide.dart';
import 'package:minimal/pages/pages_useful/page_state_management_post.dart';
import 'package:minimal/pages/pages_useful/page_design_patterns.dart';
import 'package:minimal/pages/pages_useful/page_seo_ai_post.dart';
import 'package:minimal/pages/pages_useful/page_eeat_guide_post.dart';
import 'package:minimal/pages/pages_useful/page_linkbuilding_post.dart';
import 'package:minimal/pages/pages_useful/page_technical_audit_post.dart';
import 'package:minimal/pages/pages_useful/page_seo_analyzer.dart'; // <-- новая страница анализатор
import 'package:minimal/pages/page_about.dart';
import 'package:minimal/pages/page_portfolio.dart';
import 'package:minimal/pages/page_typography.dart';
import 'package:minimal/pages/page_contacts.dart';
import 'package:minimal/pages/page_under_construction.dart';
import 'package:minimal/pages/page_copyright.dart';
import 'package:minimal/pages/page_favisnake.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) {
        final String pathName = Uri.parse(settings.name ?? '/').path;
        Widget page;

        // Простая и надежная цепочка if/else if PostSeoAnalyzerDevStory
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
        } else if (pathName == '/${InstrumentsPage.name}') {
          page = const InstrumentsPage();
        } else if (pathName == '/${PostPage.name}') {
          page = const PostPage();
        } else if (pathName == '/${PostGeorgiaPage.name}') {
          page = const PostGeorgiaPage();
        } else if (pathName == '/${HtmlSandboxPage.name}') {
          page = const HtmlSandboxPage();
        } else if (pathName == '/${SeoToolsPage.name}') {
          page = const SeoToolsPage();
        } else if (pathName == '/${SemanticCoreGuidePage.name}') {
          page = const SemanticCoreGuidePage();
        } else if (pathName == '/${PostFlutterSeoPage.name}') {
          page = const PostFlutterSeoPage();
        } else if (pathName == '/${PostStateManagementPage.name}') {
          page = const PostStateManagementPage();
        } else if (pathName == '/${PostSeoAnalyzerDevStory.name}') {
          page = const PostSeoAnalyzerDevStory();
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
        } else if (pathName == '/${SitemapGuidePage.name}') {
          page = const SitemapGuidePage();
        } else if (pathName == '/${SeoAnalyzerPage.name}') {
          page = const SeoAnalyzerPage();
        } else if (pathName == '/${SeoAnalyzerPageEn.name}') {
          page = const SeoAnalyzerPageEn();
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
