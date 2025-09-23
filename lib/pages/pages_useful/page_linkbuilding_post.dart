// lib/pages/pages_useful/page_linkbuilding_post.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minimal/pages/pages.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart'
    hide MaxWidthBox;
import 'package:url_launcher/url_launcher.dart';

class PostLinkbuildingPage extends StatefulWidget {
  static const String name = 'useful/seo/linkbuilding-strategies';

  const PostLinkbuildingPage({super.key});

  @override
  State<PostLinkbuildingPage> createState() => _PostLinkbuildingPageState();
}

class _PostLinkbuildingPageState extends State<PostLinkbuildingPage> {
  final List<String> _pageImages = [
    "assets/images/seo-guides/seo_strategy_linkbuilding_hard.webp",
    "assets/images/seo-guides/skyscraper_technique_flowchart.webp",
    "assets/images/seo-guides/linkbuilding_outreach_example.webp",
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
                  "Стратегии линкбилдинга для сложных ниш",
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
                      text: "SEO",
                      routeName:
                          '/${UsefulSeoPage.name}'), // Ссылка на разводящую
                  BreadcrumbItem(text: "Линкбилдинг"), // Текущая страница
                ],
              ),
            ),
            const SizedBox(height: 20),
            /*const Align(
              alignment: Alignment.centerLeft,
              child: TextBodySecondary(text: "Полезное / SEO / Линкбилдинг"),
            ),*/
            const TextBody(
              text:
                  "Получение качественных обратных ссылок всегда было сложной задачей. А в конкурентных или узкоспециализированных нишах (B2B, промышленность, медицина) это превращается в настоящее искусство. Стандартные методы вроде гостевых постов на общетематических площадках уже не работают. Давайте рассмотрим 'белые' и креативные стратегии, которые помогут получить заветные ссылки.",
            ),
            const ImageWrapper(
                image:
                    "assets/images/seo-guides/seo_strategy_linkbuilding_hard.webp"),
            const SizedBox(height: 20),

            const TextHeadlineSecondary(
                text: "1. Digital PR и контент-маркетинг"),
            const TextBody(
                text:
                    "Это стратегия 'магнита для ссылок'. Вместо того чтобы просить ссылки, вы создаете контент, на который хотят ссылаться сами. Это может быть:"),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextBody(
                      text:
                          "• Оригинальные исследования: Проведите опрос в своей отрасли, соберите и проанализируйте данные, оформите в виде отчета. Журналисты и блогеры любят ссылаться на эксклюзивную статистику.\n• Интерактивные инструменты: Калькуляторы, квизы, конфигураторы, которые решают проблему пользователя. Например, 'Калькулятор расчета экономии от внедрения нашего ПО'.\n• Подробные гайды и инфографика: Создайте самый полный и полезный материал по важной теме в вашей нише."),
                ],
              ),
            ),

            const TextHeadlineSecondary(
                text: "2. Техника 'Небоскреба' (Skyscraper Technique)"),
            const ImageWrapper(
                image:
                    "assets/images/seo-guides/skyscraper_technique_flowchart.webp"),
            const Align(
              alignment: Alignment.center,
              child: TextBodySecondary(
                  text: "Процесс работы по технике 'Небоскреба'"),
            ),
            const TextBody(
                text:
                    "Метод, популяризированный Брайаном Дином, состоит из трех шагов:"),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextBody(
                      text:
                          "1. Находите популярный контент конкурентов с большим количеством ссылок.\n2. Создаете свой материал на эту же тему, но делаете его значительно лучше: более полным, актуальным, с лучшим дизайном и инфографикой.\n3. Пишете владельцам сайтов, которые ссылаются на старый контент, и предлагаете им сослаться на ваш, более качественный материал."),
                ],
              ),
            ),

            const TextHeadlineSecondary(
                text: "3. HARO и его аналоги (Help a Reporter Out)"),
            const TextBody(
                text:
                    "Сервисы типа HARO (для англоязычного сегмента) или Pressfeed (для рунета) связывают журналистов, ищущих экспертные комментарии, с экспертами. Вы регистрируетесь, получаете запросы по вашей теме и даете емкие, полезные комментарии. Взамен вы получаете упоминание и, чаще всего, ссылку с авторитетного медиа-ресурса."),
            const ImageWrapper(
                image:
                    "assets/images/seo-guides/linkbuilding_outreach_example.webp"),
            const Align(
              alignment: Alignment.center,
              child: TextBodySecondary(
                  text: "Пример вежливого и персонализированного письма"),
            ),

            const TextHeadlineSecondary(
                text: "4. Стратегический гостевой постинг"),
            const TextBody(
                text:
                    "Забудьте о размещении на всех площадках подряд. Сконцентрируйтесь на 3-5 ключевых, самых авторитетных сайтах в вашей нише. Ваша цель — не просто ссылка, а построение репутации. Напишите для них действительно эксклюзивный и глубокий материал, который приведет на ваш сайт не только 'ссылочный вес', но и целевую аудиторию."),

            const TextBlockquote(
                text:
                    "Главное правило современного линкбилдинга: думайте не о том, как получить ссылку, а о том, как построить отношения и принести пользу аудитории другой площадки. Качественные ссылки — это естественное следствие такой стратегии."),

            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: TagWrapper(tags: [
                Tag(tag: "SEO"),
                Tag(tag: "Внешняя оптимизация"),
                Tag(tag: "Линкбилдинг"),
              ]),
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
                      text: "SEO",
                      routeName:
                          '/${UsefulSeoPage.name}'), // Ссылка на разводящую
                  BreadcrumbItem(text: "Линкбилдинг"), // Текущая страница
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
