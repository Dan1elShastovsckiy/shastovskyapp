// lib/pages/page_useful.dart

import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/pages/page_instruments.dart';
import 'package:minimal/pages/pages.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';

class UsefulPage extends StatelessWidget {
  static const String name = 'useful';

  const UsefulPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final theme = Theme.of(context);

    return Scaffold(
      drawer: isMobile ? buildAppDrawer(context) : null,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),
      // ИЗМЕНЕНИЕ: Используем SingleChildScrollView для исправления меню
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: MaxWidthBox(
            maxWidth: 1200,
            child: Column(
              children: [
                const SizedBox(height: 24),
                // ДОБАВЛЕНО: Хлебные крошки
                const Breadcrumbs(items: [
                  BreadcrumbItem(text: "Главная", routeName: '/'),
                  BreadcrumbItem(text: "Полезное"),
                ]),
                const SizedBox(height: 80),
                Text("Полезное", style: headlineTextStyle(context)),
                const SizedBox(height: 16),
                Text(
                  "Статьи, заметки и материалы по SEO и веб-разработке",
                  style: subtitleTextStyle(context),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                _buildCategoryButton(
                  context: context,
                  icon: Icons.code_rounded,
                  title: "Разработка",
                  subtitle: "Flutter, Dart и веб-технологии",
                  routeName: '/useful/dev', // Уточнил путь
                ),
                const SizedBox(height: 24),
                _buildCategoryButton(
                  context: context,
                  icon: Icons.travel_explore_rounded,
                  title: "SEO",
                  subtitle: "Оптимизация, контент и аналитика",
                  routeName: '/useful/seo', // Уточнил путь
                ),
                const SizedBox(height: 24),
                _buildCategoryButton(
                  context: context,
                  icon: Icons.terminal,
                  title: "Попробуй кодить",
                  subtitle: "Интерактивные песочницы для кода",
                  routeName:
                      '/${TryCodingPage.name}', // Используем новый правильный путь
                ),
                const SizedBox(height: 24),
                _buildCategoryButton(
                  context: context,
                  icon: Icons.analytics_rounded,
                  title: "Полезные инструменты для SEO",
                  subtitle: "Полезные инструменты для вашей работы с SEO",
                  routeName:
                      '/${InstrumentsPage.name}', // Уточнил путь InstrumentsPage
                ),
                const SizedBox(height: 120),
                // БЛОК С АВТОРОМ И КНОПКАМИ, СОХРАНЕН БЕЗ ИЗМЕНЕНИЙ
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
