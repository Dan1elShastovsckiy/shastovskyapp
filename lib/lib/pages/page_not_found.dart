// lib/pages/page_not_found.dart

import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xFFF5F5F5),// Убираем, чтобы использовать тему
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: MinimalMenuBar(),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
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
                  icon: const Icon(Icons.home_rounded, color: Colors.white),
                  label: const Text("ВЕРНИТЕ МЕНЯ НА САЙТ"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1d1d1d),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false),
                ),
                const Spacer(flex: 2),
                const Footer(),
              ],
            ).toMaxWidth(),
          ),
        ],
      ),
    );
  }
}

extension on Column {
  toMaxWidth() {}
}
