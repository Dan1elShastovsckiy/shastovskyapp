// lib/pages/page_typography.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/pages/pages.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart'
    hide MaxWidthBox;
import 'package:url_launcher/url_launcher.dart';

class TypographyPage extends StatelessWidget {
  static const String name = 'about-app';

  const TypographyPage({super.key});

  void _showBacklogDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text("Планы по развитию (бэклог)",
              style: headlineSecondaryTextStyle(context)),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Theme(
                    data: theme.copyWith(dividerColor: Colors.transparent),
                    child: const Column(
                      children: [
                        ListTile(
                          leading:
                              Icon(Icons.check_circle, color: Colors.green),
                          title: Text("Полный рефакторинг системы тем"),
                          subtitle: Text(
                              "Реализовано. Переписана логика наследования цветов для корректной работы Dark/Light Mode."),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.check_circle, color: Colors.green),
                          title: Text(
                              "Создание раздела 'Полезное' и наполнение статьями"),
                          subtitle: Text(
                              "Реализовано. Добавлены статьи по SEO и Flutter."),
                        ),
                        ListTile(
                          leading: Icon(Icons.school, color: Colors.blue),
                          title: Text("Интерактивные курсы"),
                          subtitle: Text(
                              "В планах. Создание раздела с практическими курсами по SEO и разработке."),
                        ),
                        ListTile(
                          leading: Icon(Icons.people, color: Colors.blue),
                          title: Text("Раздел 'Авторы'"),
                          subtitle: Text(
                              "В планах. Возможность публиковать статьи от других экспертов."),
                        ),
                        ListTile(
                          leading: Icon(Icons.language, color: Colors.blue),
                          title: Text("Интернационализация (i18n)"),
                          subtitle: Text(
                              "В планах. Добавление переключателя языка (RU/EN) для всего интерфейса."),
                        ),
                        ListTile(
                          leading: Icon(Icons.comment, color: Colors.orange),
                          title: Text("Система комментариев для статей"),
                          subtitle: Text(
                              "В планах. Интеграция стороннего сервиса или своя реализация."),
                        ),
                        ListTile(
                          leading: Icon(Icons.search, color: Colors.orange),
                          title: Text("Поиск по сайту"),
                          subtitle: Text(
                              "В планах. Реализация поиска по статьям блога и портфолио."),
                        ),
                        ListTile(
                          leading: Icon(Icons.construction, color: Colors.grey),
                          title: Text("CI/CD и автоматическое развертывание"),
                          subtitle: Text(
                              "В планах. Настройка GitHub Actions для автоматической сборки и деплоя веб-версии."),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Закрыть"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    final theme = Theme.of(context);

    return Scaffold(
      drawer: isMobile ? buildAppDrawer(context) : null,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveBreakpoints.of(context).isMobile ? 24 : 48,
            ),
            sliver: SliverToBoxAdapter(
              child: MaxWidthBox(
                maxWidth: 1200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: marginBottom12,
                        child: Text("Об этом сайте",
                            style: headlineTextStyle(context)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: marginBottom24,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: subtitleTextStyle(context),
                            children: [
                              const TextSpan(
                                text: "Это приложение, написанное на ",
                              ),
                              TextSpan(
                                text: "Flutter",
                                style: subtitleTextStyle(context).copyWith(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => launchUrl(
                                      Uri.parse('https://docs.flutter.dev/')),
                              ),
                              const TextSpan(
                                text:
                                    ", демонстрирует возможности фреймворка и его адаптивность. Flutter - это кроссплатформенный фреймворк от Google, который позволяет создавать приложения для мобильных устройств, веба и десктопа с единой кодовой базой.\n\n"
                                    "А также служит моим портфолио, где я делюсь результатами своей работы, а также своими путешествиями и фотографиями.",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () => _showBacklogDialog(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            "Посмотреть планы по развитию (бэклог)",
                            style: subtitleTextStyle(context).copyWith(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ),
                    divider(context),
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: marginBottom12,
                        child: Text("Зачем?",
                            style: headlineSecondaryTextStyle(context)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: marginBottom24,
                        child: Text(
                            "Я его сделал чтобы показать свои навыки и возможности Flutter. А также, чтобы у меня была простая ссылка на все мое портфолио, в котором будет информация обо мне - как о специалисте, мои проекты и результаты моей работы, а также мой блог с фотографиями и историями путешествий, потому что мне это нравится и я хочу делиться своими впечатлениями с окружающими.",
                            style: subtitleTextStyle(context),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    Center(child: dividerSmall(context)),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: marginBottom12,
                        child: Text("Что дальше?",
                            style: headlineSecondaryTextStyle(context)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: marginBottom24,
                        child: Text(
                            "Дальше у меня есть планы развивать это приложение, добавлять новые разделы и возможности. Например, я хочу разделить меню главная на меню блог и сделать два меню с Блогом и Полезными материалами. На Полезные материалы повесить подменю SEO обучение и Разработка обучение",
                            style: subtitleTextStyle(context),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    Center(child: dividerSmall(context)),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: marginBottom12,
                        child: Text("Хочу такой же сайт",
                            style: headlineSecondaryTextStyle(context)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: marginBottom24,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: subtitleTextStyle(context),
                            children: [
                              const TextSpan(
                                  text: "Заказать такой же сайт можно у меня "),
                              TextSpan(
                                text: "в личных сообщениях. ",
                                style: subtitleTextStyle(context).copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const TextSpan(text: "Вот тут находятся "),
                              TextSpan(
                                text: "мои контакты",
                                style: subtitleTextStyle(context).copyWith(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.pushNamed(
                                      context, '/${ContactsPage.name}'),
                              ),
                              const TextSpan(
                                  text:
                                      ". А также ниже перечислены все социальные сети, в которых я есть."),
                            ],
                          ),
                        ),
                      ),
                    ),
                    divider(context),
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: marginBottom24,
                        child: Text("P.S.", style: subtitleTextStyle(context)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: marginBottom40,
                        child: RichText(
                          text: TextSpan(
                            style: bodyTextStyle(context),
                            children: [
                              const TextSpan(
                                text:
                                    "Если вам понравился этот сайт или то, что я делаю - вы можете поддержать меня в моем телеграм канале ",
                              ),
                              TextSpan(
                                text: "@shastovscky",
                                style: bodyTextStyle(context).copyWith(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => launchUrl(
                                      Uri.parse('https://t.me/shastovscky')),
                              ),
                              const TextSpan(
                                text: " или подписаться на меня в инстаграм ",
                              ),
                              TextSpan(
                                text: "@yellolwapple",
                                style: bodyTextStyle(context).copyWith(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => launchUrl(Uri.parse(
                                      'https://instagram.com/yellolwapple')),
                              ),
                              const TextSpan(
                                text:
                                    " в нем я делюсь фото и видео из своих поездок.",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                                    Text('Запрещенная в РФ организация',
                                        style: TextStyle(
                                            fontSize: 9,
                                            color:
                                                theme.colorScheme.secondary)),
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
                                    Text('Запрещенная в РФ организация',
                                        style: TextStyle(
                                            fontSize: 9,
                                            color:
                                                theme.colorScheme.secondary)),
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
                                    Text('Запрещенная в РФ организация',
                                        style: TextStyle(
                                            fontSize: 9,
                                            color:
                                                theme.colorScheme.secondary)),
                                  ],
                                ),
                                style: elevatedButtonStyle(context),
                                onPressed: () => launchUrl(Uri.parse(
                                    'https://www.youtube.com/@itsmyadv')),
                              ),
                              ElevatedButton.icon(
                                icon: Icon(Icons.article_outlined,
                                    color: theme.colorScheme.onSurface),
                                label: const Text('VC.RU'),
                                style: elevatedButtonStyle(context),
                                onPressed: () => launchUrl(
                                    Uri.parse('https://vc.ru/id1145025')),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: MaxWidthBox(
                maxWidth: 1200,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
