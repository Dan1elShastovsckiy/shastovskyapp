// lib/pages/page_state_management_post.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minimal/components/related_articles.dart';
import 'package:minimal/pages/pages.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:minimal/utils/meta_tag_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PostStateManagementPage extends StatefulWidget {
  static const String name = 'useful/dev/flutter-state-management';

  const PostStateManagementPage({super.key});

  @override
  State<PostStateManagementPage> createState() =>
      _PostStateManagementPageState();
}

class _PostStateManagementPageState extends State<PostStateManagementPage> {
  final List<String> _pageImages = [
    "assets/images/dev-guides/flutter_state_management_options.webp",
    "assets/images/dev-guides/bloc_pattern_diagram.webp",
    "assets/images/dev-guides/state_management_comparison_table.webp",
    "assets/images/avatar_default.webp",
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final imagePath in _pageImages) {
      precacheImage(AssetImage(imagePath), context);
    }
  }

  @override
  void initState() {
    super.initState();
    MetaTagService().updateAllTags(
      title:
          "State Management в Flutter: Какой выбрать в 2025? | Блог Даниила Шастовского",
      description:
          "Provider, BLoC, Riverpod, GetX... Разбираем плюсы и минусы каждого подхода на реальных примерах.",
      imageUrl: "https://shastovsky.ru/assets/assets/images/dev_article_2.webp",
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    final theme = Theme.of(context);
    bodyTextStyle(context).copyWith(fontWeight: FontWeight.bold);

    return Scaffold(
      drawer: isMobile ? buildAppDrawer(context) : null,
      //backgroundColor: Colors.white, // Убираем, чтобы использовать тему
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),
      body: CustomScrollView(
        slivers: [
          ...[
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text(
                  "State Management в Flutter: Какой выбрать в 2025?",
                  style: headlineTextStyle(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Breadcrumbs(
                items: [
                  BreadcrumbItem(text: "Главная", routeName: '/'),
                  BreadcrumbItem(
                      text: "Полезное",
                      routeName: '/${UsefulPage.name}'), // Ссылка на разводящую
                  BreadcrumbItem(
                      text: "Разработка",
                      routeName:
                          '/${UsefulDevPage.name}'), // Ссылка на разводящую
                  BreadcrumbItem(text: "State Management"), // Текущая страница
                ],
              ),
            ),
            const SizedBox(height: 20),
            /*const Align(
              alignment: Alignment.centerLeft,
              child: TextBodySecondary(
                  text: "Полезное / Разработка / State Management"),
            ),*/
            const TextBody(
              text:
                  "Вопрос 'Какой стейт-менеджер использовать?' — один из самых частых в сообществе Flutter. Ответ, как всегда, 'зависит от ситуации'. Но чтобы сделать осознанный выбор, нужно понимать сильные и слабые стороны основных игроков. Давайте разберем самые популярные подходы, чтобы вы могли выбрать идеальный инструмент для своего проекта.",
            ),
            const ImageWrapper(
                image:
                    "assets/images/dev-guides/flutter_state_management_options.webp"),
            const Align(
              alignment: Alignment.center,
              child: TextBodySecondary(
                  text:
                      "Основные претенденты на звание лучшего стейт-менеджера"),
            ),
            const TextHeadlineSecondary(
                text: "1. Provider: Простота и стандарт де-факто"),
            const TextBody(
                text:
                    "Provider — это обертка над InheritedWidget, которая значительно упрощает управление состоянием. Он рекомендован командой Google и является отличной отправной точкой для новичков."),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextBody(
                      text:
                          "• Плюсы: Легкий в освоении, минимум бойлерплейта (избыточного кода), хорошая производительность.\n• Минусы: Не обеспечивает строгую архитектуру, что в больших проектах может привести к хаосу. Зависимость от BuildContext может быть неудобной."),
                ],
              ),
            ),

            const TextHeadlineSecondary(
                text: "2. BLoC/Cubit: Мощь и предсказуемость"),
            const ImageWrapper(
                image: "assets/images/dev-guides/bloc_pattern_diagram.webp"),
            const Align(
              alignment: Alignment.center,
              child: TextBodySecondary(text: "Поток данных в паттерне BLoC"),
            ),
            const TextBody(
                text:
                    "BLoC (Business Logic Component) — это паттерн, основанный на стримах (потоках данных). UI отправляет события (Events) в BLoC, а BLoC в ответ выдает состояния (States), на которые UI подписывается и перерисовывается. Cubit — это упрощенная версия BLoC без событий."),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextBody(
                      text:
                          "• Плюсы: Четкое разделение логики и UI, высокая тестируемость, предсказуемость. Идеален для сложных состояний и больших команд.\n• Минусы: Большое количество бойлерплейта, высокий порог вхождения для новичков."),
                ],
              ),
            ),

            const TextHeadlineSecondary(text: "3. Riverpod: Эволюция Provider"),
            const TextBody(
                text:
                    "Riverpod создан тем же автором, что и Provider, и решает его основные проблемы. Он не зависит от BuildContext, является compile-safe (ошибки отлавливаются на этапе компиляции) и предлагает более гибкую и мощную систему."),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextBody(
                      text:
                          "• Плюсы: Все плюсы Provider, плюс независимость от дерева виджетов и повышенная безопасность.\n• Минусы: Все еще развивается, сообщество меньше, чем у BLoC или Provider."),
                ],
              ),
            ),

            const TextHeadlineSecondary(text: "Сравнительная таблица"),
            const ImageWrapper(
                image:
                    "assets/images/dev-guides/state_management_comparison_table.webp"),
            const Align(
              alignment: Alignment.center,
              child: TextBodySecondary(text: "Ключевые различия подходов"),
            ),

            const TextBlockquote(
                text:
                    "Вывод: Начните с Riverpod для новых проектов. Он сочетает простоту Provider с мощью и безопасностью. Если вы работаете над огромным enterprise-приложением, где важна строгая архитектура и максимальная тестируемость, BLoC будет вашим лучшим выбором."),

            const SizedBox(height: 40),
            // <<< БЛОК С ТЕГАМИ, P.S. И СОЦСЕТЯМИ >>>
            const Align(
              alignment: Alignment.centerLeft,
              child: TagWrapper(tags: [
                Tag(tag: "Flutter"),
                Tag(tag: "Архитектура"),
                Tag(tag: "State Management"),
              ]),
            ),
            // <<< ВИДЖЕТ ДЛЯ ПОКАЗА СВЯЗАННЫХ СТАТЕЙ >>>
            const RelatedArticles(
              currentArticleRouteName:
                  PostStateManagementPage.name, // Название ТЕКУЩЕЙ страницы
              category: 'dev', // Категория, из которой показывать статьи
            ),
            const SizedBox(height: 40),
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
            // кнопки соц.сетей (СТАРАЯ КНОПКА УДАЛЕНА)
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
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Breadcrumbs(
                items: [
                  BreadcrumbItem(text: "Главная", routeName: '/'),
                  BreadcrumbItem(
                      text: "Полезное",
                      routeName: '/${UsefulPage.name}'), // Ссылка на разводящую
                  BreadcrumbItem(
                      text: "Разработка",
                      routeName:
                          '/${UsefulDevPage.name}'), // Ссылка на разводящую
                  BreadcrumbItem(text: "State Management"), // Текущая страница
                ],
              ),
            ),
            const SizedBox(height: 20),
            ...authorSection(
              context: context, // Передаем контекст для ссылки
              imageUrl: "assets/images/avatar_default.webp",
              name: "Автор: Шастовский Даниил",
              bio:
                  "SEO-специалист, автор этого сайта. Помогаю проектам расти в поисковой выдаче, используя данные, опыт и немного магии AI.",
            ),
          ].toMaxWidthSliver(),
          SliverFillRemaining(
            hasScrollBody: false,
            // <<< Теперь MaxWidthBox определён >>>
            child: MaxWidthBox(
              maxWidth: 1200,
              child: Container(),
            ),
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
