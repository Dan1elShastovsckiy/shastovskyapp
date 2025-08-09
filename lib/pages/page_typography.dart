import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';

class TypographyPage extends StatelessWidget {
  static const String name = 'about-app';

  const TypographyPage({super.key});

  Widget _buildSocialButton(String label, IconData icon, String url) {
    return SizedBox(
      width: 300,
      height: 80,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.black, size: 32),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          side: const BorderSide(color: Colors.black),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        ),
        onPressed: () => launchUrl(Uri.parse(url)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      // Теперь buildAppDrawer берется из components.dart, и ошибки нет
      drawer: isMobile ? buildAppDrawer(context) : null,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
            isMobile ? 65 : 110), // Высота для десктопа исправлена
        child: const MinimalMenuBar(),
      ),
      body: CustomScrollView(
        slivers: [
          ...[
            // const MinimalMenuBar(),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text(" ", style: headlineTextStyle),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text("Об этом сайте", style: headlineTextStyle),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom24,
                child: RichText(
                  text: TextSpan(
                    style: subtitleTextStyle,
                    children: [
                      const TextSpan(
                        text: "Это приложение, написанное на ",
                      ),
                      TextSpan(
                        text: "Flutter",
                        style: subtitleTextStyle.copyWith(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () =>
                              launchUrl(Uri.parse('https://docs.flutter.dev/')),
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
            divider,
            Container(
              margin: marginBottom40,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text("Зачем?", style: headlineSecondaryTextStyle),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom24,
                child: Text(
                    "Я его сделал чтобы показать свои навыки и возможности Flutter. А также, чтобы у меня была простая ссылка на все мое портфолио, в котором будет информация обо мне - как о специалисте, мои проекты и результаты моей работы, а также мой блог с фотографиями и историями путешествий, потому что мне это нравится и я хочу делиться своими впечатлениями с окружающими.",
                    style: subtitleTextStyle),
              ),
            ),
            dividerSmall,
            Container(
              margin: marginBottom24,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text("Что дальше?", style: headlineSecondaryTextStyle),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom24,
                child: Text(
                    "Дальше у меня есть планы развивать это приложение, добавлять новые разделы и возможности. Например, я хочу разделить меню главная на меню блог и сделать два меню с Блогом и Полезными материалами. На Полезные материалы повесить подменю SEO обучение и Разработка обучение",
                    style: subtitleTextStyle),
              ),
            ),
            dividerSmall,
            Container(
              margin: marginBottom24,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text(" ", style: headlineSecondaryTextStyle),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text("Хочу такой же сайт",
                    style: headlineSecondaryTextStyle),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom24,
                child: RichText(
                  text: TextSpan(
                    style: subtitleTextStyle,
                    children: [
                      const TextSpan(
                          text: "Заказать такой же сайт можно у меня "),
                      TextSpan(
                        text: "в личных сообщениях. ",
                        style: subtitleTextStyle.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const TextSpan(text: "Вот тут находятся "),
                      TextSpan(
                        text: "мои контакты",
                        style: subtitleTextStyle.copyWith(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap =
                              () => Navigator.pushNamed(context, '/contacts'),
                      ),
                      const TextSpan(
                          text:
                              ". А также ниже перечислены все социальные сети, в которых я есть."),
                    ],
                  ),
                ),
              ),
            ),
            divider,
            Container(
              margin: marginBottom40,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: marginBottom24,
                child: Text("P.S.", style: subtitleTextStyle),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: marginBottom40,
                child: RichText(
                  text: TextSpan(
                    style: bodyTextStyle,
                    children: [
                      const TextSpan(
                        text:
                            "Если вам понравился этот сайт или то, что я делаю - вы можете поддержать меня в моем телеграм канале ",
                      ),
                      TextSpan(
                        text: "@shastovscky",
                        style: bodyTextStyle.copyWith(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () =>
                              launchUrl(Uri.parse('https://t.me/shastovscky')),
                      ),
                      const TextSpan(
                        text: " или подписаться на меня в инстаграм ",
                      ),
                      TextSpan(
                        text: "@yellolwapple",
                        style: bodyTextStyle.copyWith(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchUrl(
                              Uri.parse('https://instagram.com/yellolwapple')),
                      ),
                      const TextSpan(
                        text: " в нем я делюсь фото и видео из своих поездок.",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // кнопки соц.сетей
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              width: double.infinity, // Растягиваем контейнер на всю ширину
              child: Center(
                // Центрируем содержимое
                child: Container(
                  constraints: const BoxConstraints(
                      maxWidth:
                          600), // Ограничиваем максимальную ширину блока с кнопками
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.telegram, color: Colors.black),
                        label: const Text('Telegram личный'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                        ),
                        onPressed: () =>
                            launchUrl(Uri.parse('https://t.me/switchleveler')),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.campaign, color: Colors.black),
                        label: const Text('Telegram канал'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                        ),
                        onPressed: () =>
                            launchUrl(Uri.parse('https://t.me/shastovscky')),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt, color: Colors.black),
                        label: const Text('Instagram'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                        ),
                        onPressed: () => launchUrl(
                            Uri.parse('https://instagram.com/yellolwapple')),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.work, color: Colors.black),
                        label: const Text('LinkedIn'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                        ),
                        onPressed: () => launchUrl(Uri.parse(
                            'https://hh.ru/resume/b94af167ff049031c70039ed1f746c61797571')),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.smart_display_outlined,
                            color: Colors.black), // YouTube
                        label: const Text('YouTube'), // текст кнопки
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                        ),
                        onPressed: () => launchUrl(Uri.parse(
                            'https://www.youtube.com/@itsmyadv')), // ссылка на YouTube
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
                        onPressed: () =>
                            launchUrl(Uri.parse('https://vc.ru/id1145025')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ].toMaxWidthSliver(),
          SliverFillRemaining(
            hasScrollBody: false,
            child: MaxWidthBox(
                maxWidth: 1200,
                backgroundColor: Colors.white,
                child: Container()),
          ),
          ...[
            divider,
            const Footer(),
          ].toMaxWidthSliver(),
        ],
      ),
    );
  }
}
