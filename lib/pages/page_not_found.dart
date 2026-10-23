// lib/pages/page_not_found.dart

import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/max_width_extension.dart'; // <<< ДОБАВЛЯЕМ ИМПОРТ

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: MinimalMenuBar(),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              // ИСПОЛЬЗУЕМ MaxWidthBox ДЛЯ ОГРАНИЧЕНИЯ ШИРИНЫ
              child: MaxWidthBox(
                maxWidth: 800,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Text(
                      "404",
                      style: headlineTextStyle(context).copyWith(fontSize: 80),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Упс! Страница не найдена",
                      style: subtitleTextStyle(context).copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Мы не смогли найти страницу, которую вы искали.",
                      textAlign: TextAlign.center,
                      style: bodyTextStyle(context),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.home_rounded),
                      label: const Text("ВЕРНУТЬСЯ НА ГЛАВНУЮ"),
                      // Используем стиль из темы
                      style: elevatedButtonStyle(context),
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context, '/', (route) => false),
                    ),
                    const Spacer(flex: 2),
                    // Убираем футер отсюда, так как он будет в общем потоке
                  ],
                ),
              ),
            ),
          ),
          // Добавляем футер как отдельный Sliver-элемент для консистентности
          SliverToBoxAdapter(
            child: MaxWidthBox(
              maxWidth: 1200,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
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
}

// ПУСТОЕ РАСШИРЕНИЕ УДАЛЕНО
