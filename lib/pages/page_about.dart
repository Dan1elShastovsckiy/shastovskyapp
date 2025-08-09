import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  static const String name = 'about';

  const AboutPage({super.key});

  String calculateExperience() {
    final startDate = DateTime(2017, 12);
    final now = DateTime.now();
    int months = (now.year - startDate.year) * 12 + now.month - startDate.month;
    int years = months ~/ 12;
    months = months % 12;
    String yearsStr = '$years ${_getYearForm(years)}';
    String monthsStr = '$months ${_getMonthForm(months)}';
    return 'Опыт работы $yearsStr $monthsStr';
  }

  String _getYearForm(int years) {
    if (years % 10 == 1 && years % 100 != 11) return 'год';
    if ([2, 3, 4].contains(years % 10) && ![12, 13, 14].contains(years % 100)) {
      return 'года';
    }
    return 'лет';
  }

  String _getMonthForm(int months) {
    if (months % 10 == 1 && months % 100 != 11) return 'месяц';
    if ([2, 3, 4].contains(months % 10) &&
        ![12, 13, 14].contains(months % 100)) {
      return 'месяца';
    }
    return 'месяцев';
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
                child: Text("Обо мне", style: headlineTextStyle),
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
                      const TextSpan(text: "Хin chào) "),
                      TextSpan(
                        text: "Меня зовут Даниил!",
                        style: subtitleTextStyle.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const TextSpan(
                          text:
                              " Здесь вы найдете больше информации о моем опыте работы как "),
                      TextSpan(
                        text: "SEO-Специалиста",
                        style: subtitleTextStyle.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const TextSpan(text: " и также как "),
                      TextSpan(
                        text: "руководителя",
                        style: subtitleTextStyle.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const TextSpan(
                          text: ".\n\nЯ рассматриваю предложения на позиции "),
                      TextSpan(
                        text: "Senior SEO Analyst",
                        style: subtitleTextStyle.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const TextSpan(text: " или "),
                      TextSpan(
                        text: "Head of SEO Department",
                        style: subtitleTextStyle.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const TextSpan(text: ". Ну и конечно же, я открыт к "),
                      TextSpan(
                        text: "предложениям по отдельным проектам",
                        style: subtitleTextStyle.copyWith(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap =
                              () => Navigator.pushNamed(context, '/contacts'),
                      ),
                      const TextSpan(text: "."),
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
                child: Text("Немного о моих ценностях в работе",
                    style: headlineSecondaryTextStyle),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom24,
                child: Text(
                    "В работе особенно ценю: качественную документацию, чёткие технические задания, профессиональную команду "
                    "и отлаженные процессы. Открыт к сотрудничеству и буду рад встрече!\n\n"
                    "Часто путешествую, поэтому рассматриваю только удалённый формат работы.",
                    style: subtitleTextStyle),
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
                child: Text("Мой опыт", style: headlineSecondaryTextStyle),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                calculateExperience(),
                style: headlineSecondaryTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ExpansionTile(
              title: Text(
                "Zum Punkt (Январь 2023 — по настоящее время)",
                style: subtitleTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Senior SEO-специалист, GroupHead"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "• Полностью отвечаю за 3 крупных постоянных проектов\n"
                    "• Работаю над внедрением ИИ технологий в продвижении проектов\n"
                    "• Создаю инструкции по работе с Ai для seo-продвижения и работой с кодом проектов\n"
                    "• Руковожу командой SEO специалистов",
                    style: bodyTextStyle,
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                "Molinos (Февраль 2022 — Декабрь 2022)",
                style: subtitleTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Middle SEO"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "• Работа над задачами продвижения со стороны Senior ведущего проекта\n"
                    "• Составление технического и SEO аудита новых проектов\n"
                    "• Обучение",
                    style: bodyTextStyle,
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                "Zharkov seo agency (Июнь 2021 — Февраль 2022)",
                style: subtitleTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("SEO-специалист"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "• Начало карьеры в SEO, прохождение курсов обучения\n"
                    "• Ведение 8+ проектов с сентября 2021\n"
                    "• Опыт работы с ограничениями Яндекса и их устранением\n"
                    "• Достижение значительных результатов в продвижении сайтов",
                    style: bodyTextStyle,
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                "Тинькофф Инвестиции (Сентябрь 2020 — Июнь 2021)",
                style: subtitleTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                  "Инвестиционный консультант (Тут я просто искал себя)"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "• Аналитика и ведение портфеля\n"
                    "• Создание трейд стратегии\n"
                    "• Помощь и консультация для действующих клиентов брокера",
                    style: bodyTextStyle,
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                "Фриланс (Январь 2019 — Сентябрь 2020)",
                style: subtitleTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Full-stack web-разработчик"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "• Разработка сайтов",
                    style: bodyTextStyle,
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                "Plastic system LLC (Декабрь 2017 — Сентябрь 2020)",
                style: subtitleTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Ведущий web-администратор"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "• Управление и наполнение контентом двух сайтов компании\n"
                    "• Ведение социальных сетей (VK, Facebook, Instagram)\n"
                    "• Настройка и управление рекламными кампаниями\n"
                    "• Работа с Яндекс.Маркет и Google Ads\n"
                    "• Координация работы с подрядчиками (дизайнер, SEO-специалист, программист)\n"
                    "• Создание лендингов и сайтов компании",
                    style: bodyTextStyle,
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                "EPAM Systems Inc. (Май 2019 — Август 2019)",
                style: subtitleTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Тестировщик ПО"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "• Производственная практика\n"
                    "• Разработка и тестирование ботов",
                    style: bodyTextStyle,
                  ),
                ),
              ],
            ),
            divider,
            Container(
              margin: marginBottom40,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text("Какой у меня подход к работе?",
                    style: headlineSecondaryTextStyle),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom24,
                child: Text(
                    "Я верю в важность качественного кода, ТЗ по SMART и чистого дизайна. Мой подход заключается в том, чтобы создавать продукты, которые не только функциональные, но и приятны в использовании. \n\n"
                    "Всегда стремлюсь к лучшим практикам SEO - оптимизации, разработки и использую современные технологии. Также ценю обратную связь и считаю, что она помогает мне расти как SEO специалисту и разработчику. \n"
                    "Я открыт к новым идеям и всегда готов учиться, люблю работать в команде и считаю, что совместная работа приводит к лучшим результатам.",
                    style: subtitleTextStyle),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom24,
                child: Text(
                    "Я считаю, что каждый проект — это возможность для роста и обучения и стремлюсь к тому, чтобы каждый мой проект был не только успешным, но и полезным для пользователей. Знаю, что технологии могут изменить мир к лучшему, и хочу быть частью этого изменения.",
                    style: subtitleTextStyle),
              ),
            ),
            dividerSmall,
            Container(
              margin: marginBottom24,
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
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              width: double.infinity,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
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
                            color: Colors.black),
                        label: const Text('YouTube'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                        ),
                        onPressed: () => launchUrl(
                            Uri.parse('https://www.youtube.com/@itsmyadv')),
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
