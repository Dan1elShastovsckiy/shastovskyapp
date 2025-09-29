// /lib/pages/page_favisnake.dart

import 'dart:js' as js;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart'
    hide MaxWidthBox;
import 'package:url_launcher/url_launcher.dart';

class FaviSnakePage extends StatefulWidget {
  static const String name = 'favisnake';
  const FaviSnakePage({super.key});

  @override
  State<FaviSnakePage> createState() => _FaviSnakePageState();
}

class _FaviSnakePageState extends State<FaviSnakePage> {
  @override
  void initState() {
    super.initState();
    // Внедряем скрипт в <head> документа при открытии страницы
    js.context.callMethod('eval', [
      '''
      var existingScript = document.getElementById('favisnake-script');
      if (!existingScript) {
        var script = document.createElement('script');
        script.id = 'favisnake-script';
        script.src = 'favisnake.js';
        document.head.appendChild(script);
      }
      '''
    ]);
  }

  @override
  Widget build(BuildContext context) {
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
            maxWidth: 800,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                const Breadcrumbs(items: [
                  BreadcrumbItem(text: "Главная", routeName: '/'),
                  BreadcrumbItem(text: "Favisnake"),
                ]),
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                Text("Favisnake", style: headlineTextStyle(context)),
                const SizedBox(height: 24),
                Text(
                  "Используйте стрелки на клавиатуре, чтобы управлять змейкой в иконке сайта (favicon)!",
                  style: subtitleTextStyle(context),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: bodyTextStyle(context),
                    children: [
                      const TextSpan(text: "Оригинальная идея и код от "),
                      TextSpan(
                        text: "Francisco Uzo",
                        style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchUrl(
                              Uri.parse('https://franciscouzo.github.io/')),
                      ),
                      const TextSpan(text: ".\nИсходный код доступен на "),
                      TextSpan(
                        text: "GitHub",
                        style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchUrl(Uri.parse(
                              'https://github.com/franciscouzo/franciscouzo.github.io/tree/master/favisnake')),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                divider(context),
                const Footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
