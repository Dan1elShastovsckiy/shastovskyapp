import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/pages/pages_instruments/page_seo_forecast.dart';
import 'package:minimal/pages/pages_instruments/page_seo_analyzer.dart';
import 'package:minimal/pages/pages_instruments/page_seo_analyzer_en.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart'
    hide MaxWidthBox;
import 'package:url_launcher/url_launcher.dart';
import 'package:minimal/utils/meta_tag_service.dart';
import 'package:minimal/components/semantic_widgets.dart';

class InstrumentsPage extends StatefulWidget {
  static const String name = 'useful/instruments';
  const InstrumentsPage({super.key});

  @override
  State<InstrumentsPage> createState() => _InstrumentsPageState();
}

class _InstrumentsPageState extends State<InstrumentsPage> {
  bool _isPrerendering = false;

  @override
  void initState() {
    super.initState();
    final uri = Uri.base;
    if (uri.queryParameters['prerender'] == 'true') {
      setState(() {
        _isPrerendering = true;
      });
    }

    MetaTagService().updateAllTags(
      title: "Полезные инструменты для SEO | Сайт Даниила Шастовского",
      description:
          "Полезные инструменты для SEO. Анализатор текста SEO, Генератор семантического ядра, Проверка внешних ссылок и многое другое.",
    );
  }

  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://seocontrol.shastovsky.com/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildPrerenderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SemanticH1("Полезные инструменты для SEO"),
        SemanticP("Полезные инструменты для вашей работы с SEO"),
        SemanticH2("Анализатор текста SEO"),
        SemanticP("Просто закиньте текст и ТЗ для анализа"),
        SemanticA(
            href: "/${SeoAnalyzerPage.name}",
            text: "Перейти к Анализатору текста SEO"),
        SemanticH2("SEO English Text Analyzer"),
        SemanticP("Just drop in text and terms for analysis"),
        SemanticA(
            href: "/${SeoAnalyzerPageEn.name}",
            text: "Go to SEO English Text Analyzer"),
        SemanticH2("Прогноз SEO"),
        SemanticP("Рассчитайте прогноз по трафику проекта в пару кликов"),
        SemanticA(
            href: "/${SeoForecastPage.name}", text: "Перейти к Прогнозу SEO"),
        // Ссылка для бота на новый сервис
        SemanticH2("SEO Control Panel"),
        SemanticP("Автоматический мониторинг Яндекс и Google"),
        SemanticA(
            href: "https://seocontrol.shastovsky.com/",
            text: "Перейти в SEO Control"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isPrerendering) {
      return Material(
          child: SingleChildScrollView(child: _buildPrerenderContent()));
    }

    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),
      drawer: isMobile ? buildAppDrawer(context) : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: MaxWidthBox(
            maxWidth: 1200,
            child: Column(
              children: [
                const SizedBox(height: 24),
                const Breadcrumbs(items: [
                  BreadcrumbItem(text: "Главная", routeName: '/'),
                  BreadcrumbItem(text: "Полезное", routeName: '/useful'),
                  BreadcrumbItem(text: "Инструменты SEO"),
                ]),
                const SizedBox(height: 40),
                Text("Полезные инструменты для SEO",
                    style: headlineTextStyle(context)),
                const SizedBox(height: 16),
                Text("Полезные инструменты для вашей работы с SEO",
                    style: subtitleTextStyle(context),
                    textAlign: TextAlign.center),
                const SizedBox(height: 40),

                _buildCategoryButton(
                    context: context,
                    icon: Icons.web,
                    title: "Анализатор текста SEO",
                    subtitle: "Просто закиньте текст и ТЗ для анализа",
                    routeName: '/${SeoAnalyzerPage.name}'),
                const SizedBox(height: 24),

                _buildCategoryButton(
                    context: context,
                    icon: Icons.toc,
                    title: "SEO English Text Analyzer",
                    subtitle: "Just drop in text and terms for analysis",
                    routeName: '/${SeoAnalyzerPageEn.name}'),
                const SizedBox(height: 24),

                // <<< ЗАМЕНЕНА ЗАГЛУШКИ НА СИНЮЮ КНОПКУ >>>
                InkWell(
                  onTap: _launchURL,
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 40),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.auto_graph_rounded,
                              size: 48, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "SEO Control Panel",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                24, // Размер как в headlineSecondaryTextStyle
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Manrope', // Ваш шрифт заголовков
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Автоматический мониторинг Яндекс и Google",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.open_in_new,
                                color: Colors.white70, size: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                _buildCategoryButton(
                    context: context,
                    icon: Icons.trending_up,
                    title: "Прогноз SEO",
                    subtitle:
                        "Рассчитайте прогноз по трафику проекта в пару кликов",
                    routeName: '/${SeoForecastPage.name}'),

                const SizedBox(height: 80),
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
                                color: theme.colorScheme.onSurface),
                            label: const Text('Telegram личный'),
                            style: elevatedButtonStyle(context),
                            onPressed: () => launchUrl(
                                Uri.parse('https://t.me/switchleveler')),
                          ),
                          ElevatedButton.icon(
                            icon: Icon(Icons.campaign,
                                color: theme.colorScheme.onSurface),
                            label: const Text('Telegram канал'),
                            style: elevatedButtonStyle(context),
                            onPressed: () => launchUrl(
                                Uri.parse('https://t.me/shastovscky')),
                          ),
                          ElevatedButton.icon(
                            icon: Icon(Icons.camera_alt,
                                color: theme.colorScheme.onSurface),
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
                                      color: theme.colorScheme.secondary),
                                ),
                              ],
                            ),
                            style: elevatedButtonStyle(context),
                            onPressed: () => launchUrl(Uri.parse(
                                'https://instagram.com/yellolwapple')),
                          ),
                          ElevatedButton.icon(
                            icon: Icon(Icons.work,
                                color: theme.colorScheme.onSurface),
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
                                      color: theme.colorScheme.secondary),
                                ),
                              ],
                            ),
                            style: elevatedButtonStyle(context),
                            onPressed: () => launchUrl(Uri.parse(
                                'https://hh.ru/resume/b94af167ff049031c70039ed1f746c61797571')),
                          ),
                          ElevatedButton.icon(
                            icon: Icon(Icons.smart_display_outlined,
                                color: theme.colorScheme.onSurface),
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
                                      color: theme.colorScheme.secondary),
                                ),
                              ],
                            ),
                            style: elevatedButtonStyle(context),
                            onPressed: () => launchUrl(
                                Uri.parse('https://www.youtube.com/@itsmyadv')),
                          ),
                          ElevatedButton.icon(
                            icon: Icon(Icons.article_outlined,
                                color: theme.colorScheme.onSurface),
                            label: const Text('VC.RU'),
                            style: elevatedButtonStyle(context),
                            onPressed: () =>
                                launchUrl(Uri.parse('https://vc.ru/id1145025')),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                divider(context),
                const Footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String? routeName,
  }) {
    final theme = Theme.of(context);
    final bool isEnabled = routeName != null;

    return InkWell(
      onTap: isEnabled ? () => Navigator.pushNamed(context, routeName) : null,
      hoverColor: isEnabled
          ? theme.colorScheme.onSurface.withAlpha(10)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(4),
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border.all(color: theme.dividerColor, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              Icon(icon, size: 48, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(title, style: headlineSecondaryTextStyle(context)),
              const SizedBox(height: 8),
              Text(subtitle,
                  style: bodyTextStyle(context)
                      .copyWith(color: theme.colorScheme.secondary)),
            ],
          ),
        ),
      ),
    );
  }
}
