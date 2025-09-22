// lib/pages/page_useful.dart

import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/pages/pages.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';

class UsefulPage extends StatelessWidget {
  static const String name = 'useful';

  const UsefulPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    return Scaffold(
      drawer: isMobile ? buildAppDrawer(context) : null,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: MaxWidthBox(
              maxWidth: 1200,
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  Text("Полезное", style: headlineTextStyle),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Статьи, заметки и материалы по SEO и веб-разработке",
                      style: subtitleTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Кнопки категорий
                  _buildCategoryButton(
                    context: context,
                    icon: Icons.code_rounded,
                    title: "Разработка",
                    subtitle: "Flutter, Dart и веб-технологии",
                    routeName: '/${UsefulDevPage.name}',
                  ),
                  const SizedBox(height: 24),
                  _buildCategoryButton(
                    context: context,
                    icon: Icons.travel_explore_rounded,
                    title: "SEO",
                    subtitle: "Оптимизация, контент и аналитика",
                    routeName: '/${UsefulSeoPage.name}',
                  ),

                  // Отступ до нижнего блока
                  const SizedBox(height: 120),

                  // Блок с кнопками соцсетей
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
                              icon: const Icon(Icons.telegram,
                                  color: Colors.black),
                              label: const Text('Telegram личный'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                side: const BorderSide(color: Colors.black),
                                elevation: 0,
                              ),
                              onPressed: () => launchUrl(
                                  Uri.parse('https://t.me/switchleveler')),
                            ),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.campaign,
                                  color: Colors.black),
                              label: const Text('Telegram канал'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                side: const BorderSide(color: Colors.black),
                                elevation: 0,
                              ),
                              onPressed: () => launchUrl(
                                  Uri.parse('https://t.me/shastovscky')),
                            ),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.camera_alt,
                                  color: Colors.black),
                              label: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Instagram'),
                                  const SizedBox(height: 2),
                                  Text('Запрещенная в РФ организация',
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: Colors.grey.shade600)),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                side: const BorderSide(color: Colors.black),
                                elevation: 0,
                              ),
                              onPressed: () => launchUrl(Uri.parse(
                                  'https://instagram.com/yellolwapple')),
                            ),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.work, color: Colors.black),
                              label: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('LinkedIn'),
                                  const SizedBox(height: 2),
                                  Text('Запрещенная в РФ организация',
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: Colors.grey.shade600)),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                side: const BorderSide(color: Colors.black),
                                elevation: 0,
                              ),
                              onPressed: () => launchUrl(Uri.parse(
                                  'https://hh.ru/resume/b94af167ff049031c70039ed1f746c61797571')),
                            ),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.smart_display_outlined,
                                  color: Colors.black),
                              label: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('YouTube'),
                                  const SizedBox(height: 2),
                                  Text('Запрещенная в РФ организация',
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: Colors.grey.shade600)),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                side: const BorderSide(color: Colors.black),
                                elevation: 0,
                              ),
                              onPressed: () => launchUrl(Uri.parse(
                                  'https://www.youtube.com/@itsmyadv')),
                            ),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.article_outlined,
                                  color: Colors.black),
                              label: const Text('VC.RU'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                side: const BorderSide(color: Colors.black),
                                elevation: 0,
                              ),
                              onPressed: () => launchUrl(
                                  Uri.parse('https://vc.ru/id1145025')),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Футер
                  divider,
                  const Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String routeName,
  }) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, routeName),
      hoverColor: Colors.black.withAlpha(10),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Icon(icon, size: 48, color: textPrimary),
            const SizedBox(height: 16),
            Text(title, style: headlineSecondaryTextStyle),
            const SizedBox(height: 8),
            Text(subtitle, style: bodyTextStyle.copyWith(color: textSecondary)),
          ],
        ),
      ),
    );
  }
}
