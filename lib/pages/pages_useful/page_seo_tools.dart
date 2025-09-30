// lib/pages/pages_useful/page_seo_tools.dart

import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/components/related_articles.dart';
import 'package:minimal/components/service_card.dart';
import 'dart:ui';
import 'package:minimal/data/seo_tools_data.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:minimal/utils/meta_tag_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:minimal/pages/pages.dart';

class SeoToolsPage extends StatefulWidget {
  static const String name = 'useful/seo/tools';
  const SeoToolsPage({super.key});

  @override
  State<SeoToolsPage> createState() => _SeoToolsPageState();
}

class _SeoToolsPageState extends State<SeoToolsPage>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late TabController _tabController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: seoToolSections.length, vsync: this);

    MetaTagService().updateAllTags(
      title: "Полезные SEO-сервисы | Блог Даниила Шастовского",
      description:
          "Интерактивная таблица с инструментами для внутренней, внешней и технической оптимизации.",
      imageUrl:
          "https://shastovsky.ru/assets/assets/images/seo-guides/tools_preview.webp",
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final isMobile = MediaQuery.of(context).size.width < 800;
      final double viewportFraction = isMobile ? 0.8 : 0.9;
      _pageController = PageController(viewportFraction: viewportFraction);
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    if (!_isInitialized) {
      return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(isMobile ? 65 : 110),
            child: const MinimalMenuBar(),
          ),
          body: const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),
      drawer: isMobile ? buildAppDrawer(context) : null,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: MaxWidthBox(
                maxWidth: 1200,
                child: Column(
                  children: [
                    const Breadcrumbs(items: [
                      BreadcrumbItem(text: "Главная", routeName: '/'),
                      BreadcrumbItem(text: "Полезное", routeName: '/useful'),
                      BreadcrumbItem(text: "SEO", routeName: '/useful/seo'),
                      BreadcrumbItem(text: "Инструменты"),
                    ]),
                    const SizedBox(height: 16),
                    Text("Полезные SEO-сервисы",
                        style: headlineTextStyle(context),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    Text(
                      isMobile
                          ? "Интерактивная подборка инструментов. Листайте карточки вбок, чтобы увидеть все сервисы в категории."
                          : "Интерактивная подборка инструментов для ежедневной работы. Здесь собраны все ключевые сервисы для решения любых SEO-задач.",
                      style: subtitleTextStyle(context),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isMobile)
            ...buildMobileSlivers(context)
          else
            ...buildDesktopSlivers(context),
          SliverToBoxAdapter(
            child: MaxWidthBox(
              maxWidth: 1200,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const TagWrapper(tags: [
                      Tag(tag: "SEO"),
                      Tag(tag: "Инструменты"),
                      Tag(tag: "Сервисы"),
                    ]),
                    // <<< ВИДЖЕТ ДЛЯ ПОКАЗА СВЯЗАННЫХ СТАТЕЙ >>>
                    const RelatedArticles(
                      currentArticleRouteName:
                          SeoToolsPage.name, // Название ТЕКУЩЕЙ страницы
                      category:
                          'seo', // Категория, из которой показывать статьи
                    ),
                    const SizedBox(height: 40),
                    Container(
                      margin: const EdgeInsets.only(bottom: 40),
                      width: double.infinity,
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            alignment: WrapAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                icon: Icon(Icons.telegram,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                                label: const Text('Telegram личный'),
                                style: elevatedButtonStyle(context),
                                onPressed: () => launchUrl(
                                    Uri.parse('https://t.me/switchleveler')),
                              ),
                              ElevatedButton.icon(
                                icon: Icon(Icons.campaign,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                                label: const Text('Telegram канал'),
                                style: elevatedButtonStyle(context),
                                onPressed: () => launchUrl(
                                    Uri.parse('https://t.me/shastovscky')),
                              ),
                              ElevatedButton.icon(
                                icon: Icon(Icons.camera_alt,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                                label: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Instagram'),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Запрещенная в РФ организация',
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                    ),
                                  ],
                                ),
                                style: elevatedButtonStyle(context),
                                onPressed: () => launchUrl(Uri.parse(
                                    'https://instagram.com/yellolwapple')),
                              ),
                              ElevatedButton.icon(
                                icon: Icon(Icons.work,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                                label: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('LinkedIn'),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Запрещенная в РФ организация',
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                    ),
                                  ],
                                ),
                                style: elevatedButtonStyle(context),
                                onPressed: () => launchUrl(Uri.parse(
                                    'https://hh.ru/resume/b94af167ff049031c70039ed1f746c61797571')),
                              ),
                              ElevatedButton.icon(
                                icon: Icon(Icons.smart_display_outlined,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                                label: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('YouTube'),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Запрещенная в РФ организация',
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                    ),
                                  ],
                                ),
                                style: elevatedButtonStyle(context),
                                onPressed: () => launchUrl(Uri.parse(
                                    'https://www.youtube.com/@itsmyadv')),
                              ),
                              ElevatedButton.icon(
                                icon: Icon(Icons.article_outlined,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                                label: const Text('VC.RU'),
                                style: elevatedButtonStyle(context),
                                onPressed: () => launchUrl(
                                    Uri.parse('https://vc.ru/id1145025')),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Breadcrumbs(items: [
                      BreadcrumbItem(text: "Главная", routeName: '/'),
                      BreadcrumbItem(text: "Полезное", routeName: '/useful'),
                      BreadcrumbItem(text: "SEO", routeName: '/useful/seo'),
                      BreadcrumbItem(text: "Инструменты"),
                    ]),
                    ...authorSection(
                      context: context,
                      imageUrl: "assets/images/avatar_default.png",
                      name: "Автор: Шастовский Даниил",
                      bio:
                          "SEO-специалист, автор этого сайта. Помогаю проектам расти в поисковой выдаче, используя данные, опыт и немного магии AI.",
                    ),
                    divider(context),
                    const Footer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildMobileSlivers(BuildContext context) {
    return [
      SliverList.list(
        children: seoToolSections.expand((section) {
          return [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Text(section.name,
                  style: headlineSecondaryTextStyle(context)),
            ),
            ...section.categories
                .map((category) => _buildMobileCategoryRow(context, category)),
          ];
        }).toList(),
      )
    ];
  }

  Widget _buildMobileCategoryRow(
      BuildContext context, SeoToolCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(category.name,
              style:
                  bodyTextStyle(context).copyWith(fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: category.services.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ServiceCard(
                  service: category.services[index],
                  width: 180,
                  height: 120,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  List<Widget> buildDesktopSlivers(BuildContext context) {
    final theme = Theme.of(context);
    return [
      SliverPersistentHeader(
        delegate: _SliverTabBarDelegate(
          TabBar(
            controller: _tabController,
            isScrollable: true,
            onTap: _onTabTapped,
            tabs: seoToolSections
                .map((section) => Tab(text: section.name))
                .toList(),
            overlayColor: WidgetStateProperty.all(Colors.transparent),
          ),
          theme: theme,
        ),
        pinned: true,
      ),
      SliverToBoxAdapter(
        child: SizedBox(
          height: 500,
          child: PageView.builder(
            controller: _pageController,
            itemCount: seoToolSections.length,
            onPageChanged: (index) {
              _tabController.animateTo(index);
            },
            itemBuilder: (context, sectionIndex) {
              final section = seoToolSections[sectionIndex];
              return AnimatedPadding(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(
                    vertical: sectionIndex == _tabController.index ? 8 : 28.0,
                    horizontal: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withAlpha(128),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: theme.dividerColor)),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: section.categories.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, categoryIndex) {
                          final category = section.categories[categoryIndex];
                          return Container(
                            width: 250,
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    child: Text(category.name,
                                        style:
                                            headlineSecondaryTextStyle(context)
                                                .copyWith(fontSize: 18)),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: category.services.length,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, serviceIndex) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12),
                                        child: ServiceCard(
                                            service: category
                                                .services[serviceIndex]),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ];
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this.tabBar, {required this.theme});

  final TabBar tabBar;
  final ThemeData theme;

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: MaxWidthBox(
        maxWidth: 1200,
        child: tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
