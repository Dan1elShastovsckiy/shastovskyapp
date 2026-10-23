// lib/pages/page_saved_reports.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/models/forecast_report.dart';
import 'package:minimal/pages/pages_instruments/page_seo_forecast.dart';
import 'package:minimal/services/auth_service.dart';
import 'package:minimal/services/firestore_service.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:provider/provider.dart';

class SavedReportsPage extends StatelessWidget {
  static const String name = 'saved-reports';
  const SavedReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // <<< ШАГ 1: Определяем isMobile в начале метода >>>
    final isMobile = MediaQuery.of(context).size.width < 800;

    final authService = Provider.of<AuthService>(context);
    final user = authService.user;
    final firestoreService = FirestoreService();

    // Защита, если пользователь как-то попал сюда без авторизации
    if (user == null) {
      return const Scaffold(
          body: Center(
              child: Text("Пожалуйста, войдите, чтобы просмотреть отчеты.")));
    }

    return Scaffold(
      appBar: PreferredSize(
        // Используем корректную высоту для мобильных и десктопа
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),

      // <<< ШАГ 2: Добавляем drawer для мобильной версии >>>
      drawer: isMobile ? buildAppDrawer(context) : null,

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: MaxWidthBox(
          maxWidth: 800,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ваш код "хлебных крошек" и заголовков остается без изменений
              const Breadcrumbs(items: [
                BreadcrumbItem(text: "Главная", routeName: '/'),
                BreadcrumbItem(text: "Мой аккаунт", routeName: '/account'),
                BreadcrumbItem(text: "Сохраненные отчеты"),
              ]),
              const SizedBox(height: 40),
              Text("Сохраненные отчеты", style: headlineTextStyle(context)),
              const SizedBox(height: 8),
              Text("Прогноз SEO-трафика", style: subtitleTextStyle(context)),
              const SizedBox(height: 40),

              // Блок со списком отчетов остается без изменений
              StreamBuilder<List<ForecastReport>>(
                stream: firestoreService.getReportsForUser(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Card(
                        child: ListTile(
                            leading:
                                Icon(Icons.error_outline, color: Colors.red),
                            title: Text("Ошибка загрузки отчетов.")));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Card(
                      child: ListTile(
                        title: const Text("У вас пока нет сохраненных отчетов"),
                        subtitle: const Text(
                            "Создайте свой первый прогноз и сохраните его"),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/${SeoForecastPage.name}');
                        },
                      ),
                    );
                  }

                  final reports = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final report = reports[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const Icon(Icons.analytics_outlined),
                          title: Text(report.title),
                          subtitle: Text(
                              "Создан: ${DateFormat('dd.MM.yyyy HH:mm', 'ru_RU').format(report.createdAt)}"),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.pushNamed(context,
                                '/${SeoForecastPage.name}/${report.id}');
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 40), // Добавил отступ перед футером
              divider(context),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
