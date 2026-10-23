// lib/pages/page_about.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:minimal/utils/meta_tag_service.dart';
import 'package:url_launcher/url_launcher.dart';
// <<< ШАГ 1: Добавляем импорт семантических виджетов >>>
import 'package:minimal/components/semantic_widgets.dart';

class AboutPage extends StatefulWidget {
  static const String name = 'about';

  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  // <<< ШАГ 2: Добавляем флаг для определения режима рендеринга >>>
  bool _isPrerendering = false;

  @override
  void initState() {
    super.initState();
    // <<< ШАГ 3: Проверяем URL на наличие параметра пререндеринга >>>
    final uri = Uri.base;
    if (uri.queryParameters['prerender'] == 'true') {
      setState(() {
        _isPrerendering = true;
      });
    }

    MetaTagService().updateAllTags(
      title: "Обо мне | Даниил Шастовский - SEO, разработка, путешествия",
      description:
          "Привет! Я Даниил, SEO-специалист и разработчик. Здесь я делюсь своим опытом в digital, историями из поездок и фотографиями.",
      imageUrl:
          "https://shastovsky.com/assets/assets/images/avatar_default.webp",
    );
  }

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

  // <<< ШАГ 4: Новый метод для генерации семантического контента >>>
  Widget _buildPrerenderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SemanticH1("Обо мне"),
        SemanticImg(
            src: "assets/images/avatar_default.webp", alt: "Даниил Шастовский"),
        SemanticP(
            "Хin chào) Меня зовут Даниил! Здесь вы найдете больше информации о моем опыте работы как SEO-Специалиста и также как руководителя. Я рассматриваю предложения на позиции Senior SEO Analyst или Head of SEO Department. Ну и конечно же, я открыт к предложениям по отдельным проектам."),
        SemanticH2("Немного о моих ценностях в работе"),
        SemanticP(
            "В работе особенно ценю: качественную документацию, чёткие технические задания, профессиональную команду и отлаженные процессы. Открыт к сотрудничеству и буду рад встрече! Часто путешествую, поэтому рассматриваю только удалённый формат работы."),
        SemanticH2("Мой опыт"),
        SemanticP(calculateExperience()),
        SemanticH2("Zum Punkt (Январь 2023 — по настоящее время)"),
        SemanticP(
            "Senior SEO-специалист, GroupHead. Полностью отвечаю за 3 крупных постоянных проектов. Работаю над внедрением ИИ технологий в продвижении проектов. Создаю инструкции по работе с Ai для seo-продвижения и работой с кодом проектов. Руковожу командой SEO специалистов."),
        SemanticH2("Molinos (Февраль 2022 — Декабрь 2022)"),
        SemanticP(
            "Middle SEO. Работа над задачами продвижения со стороны Senior ведущего проекта. Составление технического и SEO аудита новых проектов. Обучение."),
        SemanticH2("Zharkov seo agency (Июнь 2021 — Февраль 2022)"),
        SemanticP(
            "SEO-специалист. Начало карьеры в SEO, прохождение курсов обучения. Ведение 8+ проектов с сентября 2021. Опыт работы с ограничениями Яндекса и их устранением. Достижение значительных результатов в продвижении сайтов."),
        SemanticH2("Тинькофф Инвестиции (Сентябрь 2020 — Июнь 2021)"),
        SemanticP(
            "Инвестиционный консультант (Тут я просто искал себя). Аналитика и ведение портфеля. Создание трейд стратегии. Помощь и консультация для действующих клиентов брокера."),
        SemanticH2("Фриланс (Январь 2019 — Сентябрь 2020)"),
        SemanticP("Full-stack web-разработчик. Разработка сайтов."),
        SemanticH2("Plastic system LLC (Декабрь 2017 — Сентябрь 2020)"),
        SemanticP(
            "Ведущий web-администратор. Управление и наполнение контентом двух сайтов компании. Ведение социальных сетей (VK, Facebook, Instagram). Настройка и управление рекламными кампаниями. Работа с Яндекс.Маркет и Google Ads. Координация работы с подрядчиками. Создание лендингов и сайтов компании."),
        SemanticH2("EPAM Systems Inc. (Май 2019 — Август 2019)"),
        SemanticP(
            "Тестировщик ПО. Производственная практика. Разработка и тестирование ботов."),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // <<< ШАГ 5: Добавляем условную логику в метод build >>>
    if (_isPrerendering) {
      return Material(
          child: SingleChildScrollView(child: _buildPrerenderContent()));
    }

    // Ваш обычный UI код без изменений
    final isMobile = MediaQuery.of(context).size.width < 800;
    final theme = Theme.of(context);

    return Scaffold(
      drawer: isMobile ? buildAppDrawer(context) : null,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),
      body: CustomScrollView(
        slivers: [
          ...[
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Breadcrumbs(items: [
                BreadcrumbItem(text: "Главная", routeName: '/'),
                BreadcrumbItem(text: "Обо мне"),
              ]),
            ),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text("Обо мне", style: headlineTextStyle(context)),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(top: 16, bottom: 24),
                child: const CircleAvatar(
                  radius: 64,
                  backgroundImage:
                      AssetImage('assets/images/avatar_default.webp'),
                  backgroundColor: Color(0xFFF5F5F5),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom24,
                child: RichText(
                  textAlign:
                      TextAlign.center, // <-- Добавлено для центрирования
                  text: TextSpan(
                    style: subtitleTextStyle(context),
                    children: [
                      const TextSpan(text: "Хin chào) "),
                      TextSpan(
                        text: "Меня зовут Даниил!",
                        style: subtitleTextStyle(context).copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const TextSpan(
                          text:
                              " Здесь вы найдете больше информации о моем опыте работы как "),
                      TextSpan(
                        text: "SEO-Специалиста",
                        style: subtitleTextStyle(context).copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const TextSpan(text: " и также как "),
                      TextSpan(
                        text: "руководителя",
                        style: subtitleTextStyle(context).copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const TextSpan(
                          text: ".\n\nЯ рассматриваю предложения на позиции "),
                      TextSpan(
                        text: "Senior SEO Analyst",
                        style: subtitleTextStyle(context).copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const TextSpan(text: " или "),
                      TextSpan(
                        text: "Head of SEO Department",
                        style: subtitleTextStyle(context).copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const TextSpan(text: ". Ну и конечно же, я открыт к "),
                      TextSpan(
                        text: "предложениям по отдельным проектам",
                        style: subtitleTextStyle(context).copyWith(
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
            divider(context),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text("Немного о моих ценностях в работе",
                    style: headlineSecondaryTextStyle(context)),
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
                    textAlign:
                        TextAlign.center, // <-- Добавлено для центрирования
                    style: subtitleTextStyle(context)),
              ),
            ),
            divider(context),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text("Мой опыт",
                    style: headlineSecondaryTextStyle(context)),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                calculateExperience(),
                style: headlineSecondaryTextStyle(context).copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16), // Отступ перед списком
            ExpansionTile(
              title: Text(
                "Zum Punkt (Январь 2023 — по настоящее время)",
                style: subtitleTextStyle(context)
                    .copyWith(fontWeight: FontWeight.bold),
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
                    style: bodyTextStyle(context),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                "Molinos (Февраль 2022 — Декабрь 2022)",
                style: subtitleTextStyle(context)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Middle SEO"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "• Работа над задачами продвижения со стороны Senior ведущего проекта\n"
                    "• Составление технического и SEO аудита новых проектов\n"
                    "• Обучение",
                    style: bodyTextStyle(context),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                "Zharkov seo agency (Июнь 2021 — Февраль 2022)",
                style: subtitleTextStyle(context)
                    .copyWith(fontWeight: FontWeight.bold),
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
                    style: bodyTextStyle(context),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                "Тинькофф Инвестиции (Сентябрь 2020 — Июнь 2021)",
                style: subtitleTextStyle(context)
                    .copyWith(fontWeight: FontWeight.bold),
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
                    style: bodyTextStyle(context),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                "Фриланс (Январь 2019 — Сентябрь 2020)",
                style: subtitleTextStyle(context)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Full-stack web-разработчик"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "• Разработка сайтов",
                    style: bodyTextStyle(context),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                "Plastic system LLC (Декабрь 2017 — Сентябрь 2020)",
                style: subtitleTextStyle(context)
                    .copyWith(fontWeight: FontWeight.bold),
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
                    style: bodyTextStyle(context),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                "EPAM Systems Inc. (Май 2019 — Август 2019)",
                style: subtitleTextStyle(context)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Тестировщик ПО"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "• Производственная практика\n"
                    "• Разработка и тестирование ботов",
                    style: bodyTextStyle(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            dividerSmall(context),
            const SizedBox(height: 24),
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
                          ..onTap = () =>
                              launchUrl(Uri.parse('https://t.me/shastovscky')),
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
                        onPressed: () =>
                            launchUrl(Uri.parse('https://t.me/switchleveler')),
                      ),
                      ElevatedButton.icon(
                        icon: Icon(Icons.campaign,
                            color: theme.colorScheme.onSurface),
                        label: const Text('Telegram канал'),
                        style: elevatedButtonStyle(context),
                        onPressed: () =>
                            launchUrl(Uri.parse('https://t.me/shastovscky')),
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
                            Text(
                              'Запрещенная в РФ организация',
                              style: TextStyle(
                                  fontSize: 9,
                                  color: theme.colorScheme.secondary),
                            ),
                          ],
                        ),
                        style: elevatedButtonStyle(context),
                        onPressed: () => launchUrl(
                            Uri.parse('https://instagram.com/yellolwapple')),
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
                            Text(
                              'Запрещенная в РФ организация',
                              style: TextStyle(
                                  fontSize: 9,
                                  color: theme.colorScheme.secondary),
                            ),
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
                            Text(
                              'Запрещенная в РФ организация',
                              style: TextStyle(
                                  fontSize: 9,
                                  color: theme.colorScheme.secondary),
                            ),
                          ],
                        ),
                        style: elevatedButtonStyle(context),
                        onPressed: () => launchUrl(
                            Uri.parse('https://www.youtube.com/@itsmyadv')),
                      ),
                      ElevatedButton.icon(
                        icon: Icon(Icons.article_outlined,
                            color: theme.colorScheme.onSurface),
                        label: const Text('VC.RU'),
                        style: elevatedButtonStyle(context),
                        onPressed: () =>
                            launchUrl(Uri.parse('https://vc.ru/id1145025')),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ].toMaxWidthSliver(),
          SliverFillRemaining(
            hasScrollBody: false,
            child: MaxWidthBox(maxWidth: 1200, child: Container()),
          ),
          ...[
            divider(context),
            const Footer(),
          ].toMaxWidthSliver(),
        ],
      ),
    );
  }
}
