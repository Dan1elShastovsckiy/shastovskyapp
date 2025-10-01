// lib/pages/pages_useful/page_eeat_guide_post.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minimal/components/related_articles.dart';
import 'package:minimal/pages/pages.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:minimal/utils/meta_tag_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PostEeatGuidePage extends StatefulWidget {
  static const String name = 'useful/seo/eeat-guide';

  const PostEeatGuidePage({super.key});

  @override
  State<PostEeatGuidePage> createState() => _PostEeatGuidePageState();
}

class _PostEeatGuidePageState extends State<PostEeatGuidePage> {
  final List<String> _pageImages = [
    "assets/images/seo-guides/eeat_components.webp",
    "assets/images/seo-guides/author_bio_example.webp",
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
          "E-E-A-T: Полный гид по экспертности для SEO | Блог Даниила Шастовского",
      description:
          "Разбираем факторы Experience, Expertise, Authoritativeness, and Trustworthiness. Как доказать Google, что ваш контент создан экспертом.",
      imageUrl:
          "https://shastovsky.ru/assets/assets/images/seo-guides/eeat_components.webp",
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    final theme = Theme.of(context);
    final boldStyle =
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
                  "Полное руководство по E-E-A-T в 2025 году",
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
                  BreadcrumbItem(
                      text: "E-E-A-T Руководство"), // Текущая страница
                ],
              ),
            ),
            const SizedBox(height: 20),
            /*const Align(
              alignment: Alignment.centerLeft,
              child: TextBodySecondary(text: "Полезное / SEO / E-E-A-T Руководство"),
            ),*/
            const TextBody(
              text:
                  "В мире SEO, где алгоритмы Google становятся все более человекоподобными, концепция E-E-A-T (Experience, Expertise, Authoritativeness, Trustworthiness) превратилась из рекомендации в краеугольный камень успешного ранжирования. Особенно это касается YMYL-ниш (Your Money or Your Life). Давайте разберемся, что означает каждый компонент и как практически применить его на вашем сайте.",
            ),

            const TextHeadlineSecondary(text: "Что такое E-E-A-T?"),
            const ImageWrapper(
                image: "assets/images/seo-guides/eeat_components.webp"),
            const Align(
              alignment: Alignment.center,
              child: TextBodySecondary(
                  text: "Визуализация четырех столпов E-E-A-T"),
            ),
            const TextBody(
                text:
                    "E-E-A-T — это аббревиатура, которую Google использует для оценки качества контента и надежности источника. Давайте расшифруем каждый элемент:"),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(style: bodyTextStyle(context), children: [
                    TextSpan(text: "• Experience (Опыт): ", style: boldStyle),
                    const TextSpan(
                        text:
                            "Новейшее дополнение. Демонстрирует, что контент создан человеком с реальным, практическим опытом в теме. Это ответ Google на засилье AI-контента без души."),
                  ])),
                  const SizedBox(height: 16),
                  RichText(
                      text: TextSpan(style: bodyTextStyle(context), children: [
                    TextSpan(
                        text: "• Expertise (Экспертиза): ", style: boldStyle),
                    const TextSpan(
                        text:
                            "Подтверждает глубокие знания автора в конкретной области. Экспертом может быть как дипломированный специалист, так и опытный практик."),
                  ])),
                  const SizedBox(height: 16),
                  RichText(
                      text: TextSpan(style: bodyTextStyle(context), children: [
                    TextSpan(
                        text: "• Authoritativeness (Авторитетность): ",
                        style: boldStyle),
                    const TextSpan(
                        text:
                            "Это репутация. Насколько ваш сайт, бренд и авторы признаны авторитетами в вашей нише? Здесь играют роль ссылки, упоминания, отзывы."),
                  ])),
                  const SizedBox(height: 16),
                  RichText(
                      text: TextSpan(style: bodyTextStyle(context), children: [
                    TextSpan(
                        text: "• Trustworthiness (Надежность/Доверие): ",
                        style: boldStyle),
                    const TextSpan(
                        text:
                            "Самый важный аспект. Может ли пользователь доверять вашему сайту? Это касается безопасности (HTTPS), прозрачности (контакты, информация о компании) и честности контента."),
                  ])),
                ],
              ),
            ),

            const TextHeadlineSecondary(
                text: "Как прокачать каждый компонент E-E-A-T"),

            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("1. Демонстрация Опыта (Experience)", style: boldStyle),
                  const TextBody(
                      text:
                          "• Пишите от первого лица: Используйте фразы 'Я протестировал', 'В моей практике был случай', 'Мы пришли к выводу'.\n• Добавляйте уникальные медиа: Публикуйте собственные фото и видео, а не стоковые. Покажите продукт в использовании, процесс оказания услуги.\n• Делитесь результатами: Приводите кейсы, скриншоты 'до/после', реальные данные из аналитики."),
                  Text("2. Подтверждение Экспертизы (Expertise)",
                      style: boldStyle),
                  const ImageWrapper(
                      image:
                          "assets/images/seo-guides/author_bio_example.webp"),
                  const Align(
                    alignment: Alignment.center,
                    child: TextBodySecondary(
                        text: "Пример информативного блока об авторе статьи"),
                  ),
                  const TextBody(
                      text:
                          "• Создайте страницы авторов: Подробные биографии с указанием образования, опыта работы, публикаций и ссылками на соцсети.\n• Указывайте автора под каждой статьей: Свяжите статью с конкретным экспертом.\n• Глубина контента: Не переписывайте чужие статьи. Проводите собственные исследования, создавайте исчерпывающие руководства, которые полностью закрывают потребность пользователя."),
                  Text("3. Построение Авторитетности (Authoritativeness)",
                      style: boldStyle),
                  const TextBody(
                      text:
                          "• Получайте ссылки с трастовых ресурсов: Цитирования в отраслевых СМИ, на сайтах университетов, в блогах лидеров мнений.\n• Работайте с упоминаниями бренда: Даже упоминания без ссылки (unlinked mentions) учитываются Google.\n• Создайте страницу 'О нас': Расскажите историю вашего бренда, его миссию и ценности. Покажите лица, стоящие за компанией."),
                  Text("4. Обеспечение Надежности (Trustworthiness)",
                      style: boldStyle),
                  const TextBody(
                      text:
                          "• Техническая база: Обязательный HTTPS, отсутствие навязчивой рекламы.\n• Прозрачность: Легкодоступная контактная информация, политика конфиденциальности, условия использования.\n• Работа с отзывами: Размещайте реальные отзывы клиентов. Отвечайте на негативные комментарии на внешних площадках."),
                ],
              ),
            ),

            const TextBlockquote(
                text:
                    "E-E-A-T — это не чек-лист, который можно выполнить и забыть. Это непрерывный процесс построения репутации и доверия как у пользователей, так и у поисковых систем."),

            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: TagWrapper(tags: [
                Tag(tag: "SEO"),
                Tag(tag: "E-E-A-T"),
                Tag(tag: "Внутренняя оптимизация"),
              ]),
            ),
            // <<< ВИДЖЕТ ДЛЯ ПОКАЗА СВЯЗАННЫХ СТАТЕЙ >>>
            const RelatedArticles(
              currentArticleRouteName:
                  PostEeatGuidePage.name, // Название ТЕКУЩЕЙ страницы
              category: 'seo', // Категория, из которой показывать статьи
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
                      text: "SEO",
                      routeName:
                          '/${UsefulSeoPage.name}'), // Ссылка на разводящую
                  BreadcrumbItem(
                      text: "E-E-A-T Руководство"), // Текущая страница
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
