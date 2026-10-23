import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/pages/page_saved_reports.dart';
import 'package:minimal/pages/pages_instruments/page_seo_forecast.dart';
import 'package:minimal/services/auth_service.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // <<< 1. ИМПОРТ ДЛЯ ССЫЛОК

class AccountPage extends StatelessWidget {
  static const String name = 'account';
  const AccountPage({super.key});

  // Функция для открытия ссылки
  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://seocontrol.shastovsky.com/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.user;
    final isMobile = MediaQuery.of(context).size.width < 800;

    if (!authService.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (user == null) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(isMobile ? 65 : 110),
          child: const MinimalMenuBar(),
        ),
        drawer: isMobile ? buildAppDrawer(context) : null,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.account_circle_outlined, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Войдите в аккаунт, чтобы просмотреть эту страницу.',
                  textAlign: TextAlign.center,
                  style: bodyTextStyle(context),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text('Войти'),
                  style: elevatedButtonStyle(context),
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),
      drawer: isMobile ? buildAppDrawer(context) : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: MaxWidthBox(
          maxWidth: 800,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Breadcrumbs(items: [
                BreadcrumbItem(text: "Главная", routeName: '/'),
                BreadcrumbItem(text: "Мой аккаунт"),
              ]),
              const SizedBox(height: 40),
              Text("Мой аккаунт", style: headlineTextStyle(context)),
              const SizedBox(height: 40),

              // --- ИНФОРМАЦИЯ О ПОЛЬЗОВАТЕЛЕ ---
              Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person, size: 40),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.displayName ?? "Имя пользователя",
                          style: headlineSecondaryTextStyle(context),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user.email ?? "Нет email",
                          style: subtitleTextStyle(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // --- КНОПКИ ДЕЙСТВИЙ ---
              Wrap(
                spacing: 10,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text("Редактировать"),
                    style: elevatedButtonStyle(context),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("В разработке")),
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () async {
                      await authService.logout();
                      if (!context.mounted) return;
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (route) => false);
                    },
                    child: const Text("Выйти",
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              const Divider(),
              const SizedBox(height: 40),

              Text("Мои инструменты", style: headlineTextStyle(context)),
              const SizedBox(height: 20),

              // 1. КАРТОЧКА ВНУТРЕННИХ ИНСТРУМЕНТОВ
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.calculate_outlined),
                      title: const Text("Прогноз SEO-трафика"),
                      subtitle: const Text("Калькулятор сезонности"),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pushNamed(
                            context, '/${SeoForecastPage.name}');
                      },
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.folder_open_outlined),
                      title: const Text("Сохраненные отчеты"),
                      subtitle: const Text("Архив прогнозов"),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pushNamed(
                            context, '/${SavedReportsPage.name}');
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // <<< 2. НОВАЯ КРАСИВАЯ КНОПКА ДЛЯ SEOCONTROL >>>
              InkWell(
                onTap: _launchURL,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2563EB),
                        Color(0xFF1E40AF)
                      ], // Синий градиент
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.auto_graph_rounded,
                            color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 20),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "SEO Control Panel",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Автоматический мониторинг Яндекс и Google",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.open_in_new, color: Colors.white70),
                    ],
                  ),
                ),
              ),
              // <<< КОНЕЦ НОВОЙ КНОПКИ >>>

              const SizedBox(height: 60),
              const Divider(),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
