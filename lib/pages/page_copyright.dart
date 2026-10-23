// /lib/pages/page_copyright.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:minimal/utils/meta_tag_service.dart'; // MetaTagService
import 'package:responsive_framework/responsive_framework.dart'
    hide MaxWidthBox;
import 'package:url_launcher/url_launcher.dart';
// <<< ШАГ 1: Импорт семантических виджетов >>>
import 'package:minimal/components/semantic_widgets.dart';

class CopyrightPage extends StatefulWidget {
  static const String name = 'copyright';
  const CopyrightPage({super.key});

  @override
  State<CopyrightPage> createState() => _CopyrightPageState();
}

class _CopyrightPageState extends State<CopyrightPage> {
  static const String _privacyPolicyUpdatedAt = '2025.11.20';

  // <<< ШАГ 2: Флаг пререндеринга >>>
  bool _isPrerendering = false;

  @override
  void initState() {
    super.initState();
    // <<< ШАГ 3: Проверка URL >>>
    final uri = Uri.base;
    if (uri.queryParameters['prerender'] == 'true') {
      setState(() {
        _isPrerendering = true;
      });
    }

    // Мета-теги для SEO
    MetaTagService().updateAllTags(
      title:
          "Правовая информация и Политика конфиденциальности | Shastovsky.com",
      description:
          "Авторское право, лицензия, политика конфиденциальности и условия использования сервисов Shastovsky.com и SEO Control.",
      imageUrl:
          "https://shastovsky.com/assets/assets/images/avatar_default.webp",
    );
  }

  // <<< ШАГ 4: Семантический контент для ботов >>>
  Widget _buildPrerenderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SemanticH1("Правовая информация и Политика конфиденциальности"),
        SemanticH2("1. Авторское право и Лицензия"),
        SemanticP("Copyright (C) 2025 Daniil Shastovskii <shastovsckiy@ya.ru>"),
        SemanticP("""
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
        """),
        SemanticH2("2. Политика конфиденциальности"),
        SemanticP("Последнее обновление: $_privacyPolicyUpdatedAt"),
        SemanticH2("2.1. Общие положения"),
        SemanticP(
            "Настоящая Политика описывает порядок сбора и использования информации пользователей экосистемы Shastovsky.com, включая основной сайт и сервис SEO Control (seocontrol.shastovsky.com). Используя наши сервисы, вы соглашаетесь с условиями данной Политики."),
        SemanticH2("2.2. Сбор данных"),
        SemanticP(
            "• Учетные данные: Email, имя профиля, UID (через Firebase Auth)."),
        SemanticP(
            "• Google Search Console: Список сайтов, sitemaps, статистика поиска (клики, показы). Доступ only-read."),
        SemanticP(
            "• Яндекс.Вебмастер и Метрика: Статистика посещаемости, диагностика ошибок сайта."),
        SemanticH2("Использование данных Google (Limited Use Policy)"),
        SemanticP(
            "Использование информации, полученной от API Google, и передача её любому другому приложению будут соответствовать Google API Services User Data Policy, включая требования ограниченного использования (Limited Use requirements)."),
        SemanticH2("2.3. Передача и хранение"),
        SemanticP(
            "Мы не продаем ваши данные. Данные передаются только техническим партнерам (Google Firebase, Хостинг) для обеспечения работы сервиса. Вы можете в любой момент удалить свой аккаунт, и все данные будут стерты."),
        SemanticH2("3. Условия использования (Terms of Service)"),
        SemanticP(
            "1. Предоставление услуг. Сервисы предоставляются «как есть» (as is). Мы прилагаем все усилия для обеспечения бесперебойной работы, но не гарантируем отсутствие сбоев."),
        SemanticP(
            "2. Ответственность. Администрация сайта не несет ответственности за любые прямые или косвенные убытки, возникшие в результате использования или невозможности использования сервисов."),
        SemanticP(
            "3. Использование API. Пользователь обязуется не использовать сервисы для спама, DDoS-атак или других незаконных действий. Мы оставляем за собой право заблокировать доступ при нарушении правил."),
        SemanticH2("Контакты"),
        SemanticP("Контакты для связи: support@shastovsky.com"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // <<< ШАГ 5: Условный рендеринг >>>
    if (_isPrerendering) {
      return Material(
          child: SingleChildScrollView(child: _buildPrerenderContent()));
    }

    // Обычный код Flutter UI (ваш предыдущий код)
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final theme = Theme.of(context);
    final bodyStyle = bodyTextStyle(context);
    final headerStyle = headlineSecondaryTextStyle(context)
        .copyWith(fontSize: 20, fontWeight: FontWeight.bold, height: 1.5);

    const licenseText = '''
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
''';

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Breadcrumbs(items: [
                  BreadcrumbItem(text: "Главная", routeName: '/'),
                  BreadcrumbItem(text: "Правовая информация"),
                ]),

                const SizedBox(height: 40),
                Text("Правовая информация", style: headlineTextStyle(context)),

                const SizedBox(height: 40),

                // --- БЛОК 1: КОПИРАЙТ ---
                _SectionHeader(text: "1. Авторское право и Лицензия"),
                SelectableText(
                    "Copyright (C) 2025 Daniil Shastovskii <shastovsckiy@ya.ru>",
                    style: bodyStyle),
                const SizedBox(height: 16),
                SelectableText(licenseText,
                    style: bodyStyle.copyWith(
                        fontFamily: 'monospace', height: 1.5, fontSize: 13)),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    style: bodyStyle,
                    children: [
                      const TextSpan(
                          text:
                              "Полный текст лицензии доступен на официальном сайте: "),
                      TextSpan(
                        text: "apache.org",
                        style: bodyStyle.copyWith(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchUrl(Uri.parse(
                              'http://www.apache.org/licenses/LICENSE-2.0')),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                const Divider(),
                const SizedBox(height: 40),

                // --- БЛОК 2: ПОЛИТИКА ---
                _SectionHeader(text: "2. Политика конфиденциальности"),
                SelectableText(
                  "Последнее обновление: $_privacyPolicyUpdatedAt",
                  style: bodyStyle.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24),

                _SubHeader(text: "2.1. Общие положения", style: headerStyle),
                SelectableText(
                  "Настоящая Политика описывает порядок сбора и использования информации пользователей экосистемы Shastovsky.com, включая основной сайт и сервис SEO Control (seocontrol.shastovsky.com). Используя наши сервисы, вы соглашаетесь с условиями данной Политики.",
                  style: bodyStyle,
                ),

                const SizedBox(height: 24),
                _SubHeader(text: "2.2. Сбор данных", style: headerStyle),
                _BulletPoint(
                    text:
                        "Учетные данные: Email, имя профиля, UID (через Firebase Auth).",
                    style: bodyStyle),
                _BulletPoint(
                    text:
                        "Google Search Console: Список сайтов, sitemaps, статистика поиска (клики, показы). Доступ only-read.",
                    style: bodyStyle),
                _BulletPoint(
                    text:
                        "Яндекс.Вебмастер и Метрика: Статистика посещаемости, диагностика ошибок сайта.",
                    style: bodyStyle),

                const SizedBox(height: 24),
                // ВАЖНЫЙ БЛОК ДЛЯ GOOGLE (LIMITED USE)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        "Использование данных Google (Limited Use Policy)",
                        style: headerStyle.copyWith(
                            fontSize: 16, color: Colors.blue.shade900),
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          style: bodyStyle.copyWith(
                              fontSize: 14, color: Colors.blue.shade900),
                          children: [
                            const TextSpan(
                              text:
                                  "Использование информации, полученной от API Google, и передача её любому другому приложению будут соответствовать ",
                            ),
                            TextSpan(
                              text: "Google API Services User Data Policy",
                              style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => launchUrl(Uri.parse(
                                    "https://developers.google.com/terms/api-services-user-data-policy")),
                            ),
                            const TextSpan(
                              text:
                                  ", включая требования ограниченного использования (Limited Use requirements).",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                _SubHeader(
                    text: "2.3. Передача и хранение", style: headerStyle),
                SelectableText(
                  "Мы не продаем ваши данные. Данные передаются только техническим партнерам (Google Firebase, Хостинг) для обеспечения работы сервиса. Вы можете в любой момент удалить свой аккаунт, и все данные будут стерты.",
                  style: bodyStyle,
                ),

                const SizedBox(height: 40),
                const Divider(),
                const SizedBox(height: 40),

                // --- БЛОК 3: TERMS OF SERVICE ---
                _SectionHeader(
                    text: "3. Условия использования (Terms of Service)"),

                const SizedBox(height: 16),
                SelectableText(
                  "1. Предоставление услуг. Сервисы предоставляются «как есть» (as is). Мы прилагаем все усилия для обеспечения бесперебойной работы, но не гарантируем отсутствие сбоев.",
                  style: bodyStyle,
                ),
                const SizedBox(height: 12),
                SelectableText(
                  "2. Ответственность. Администрация сайта не несет ответственности за любые прямые или косвенные убытки, возникшие в результате использования или невозможности использования сервисов.",
                  style: bodyStyle,
                ),
                const SizedBox(height: 12),
                SelectableText(
                  "3. Использование API. Пользователь обязуется не использовать сервисы для спама, DDoS-атак или других незаконных действий. Мы оставляем за собой право заблокировать доступ при нарушении правил.",
                  style: bodyStyle,
                ),

                const SizedBox(height: 40),
                const Divider(),
                const SizedBox(height: 40),

                // --- КОНТАКТЫ ---
                SelectableText(
                  "Контакты для связи: support@shastovsky.com",
                  style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 80),
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

// --- Вспомогательные виджеты (Остаются внизу файла) ---
class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader({required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Text(text,
          style: headlineSecondaryTextStyle(context).copyWith(fontSize: 24)),
    );
  }
}

class _SubHeader extends StatelessWidget {
  final String text;
  final TextStyle style;
  const _SubHeader({required this.text, required this.style});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(text, style: style),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  final TextStyle style;
  const _BulletPoint({required this.text, required this.style});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: style.copyWith(fontWeight: FontWeight.bold)),
          Expanded(child: SelectableText(text, style: style)),
        ],
      ),
    );
  }
}
