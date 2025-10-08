// lib/pages/page_flutter_seo_post.dart

import 'package:flutter/gestures.dart';
import 'package:minimal/components/related_articles.dart';
import 'package:minimal/components/share_buttons_block.dart';
import 'package:minimal/utils/meta_tag_service.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/material.dart';
import 'package:minimal/pages/pages.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/max_width_extension.dart' hide MaxWidthBox;
import 'package:url_launcher/url_launcher.dart';

class PostFlutterSeoPage extends StatefulWidget {
  static const String name = 'useful/dev/flutter-web-seo';

  const PostFlutterSeoPage({super.key});

  @override
  State<PostFlutterSeoPage> createState() => _PostFlutterSeoPageState();
}

class _PostFlutterSeoPageState extends State<PostFlutterSeoPage> {
  final List<String> _pageImages = [
    "assets/images/dev-guides/flutter_ssg_flowchart.webp",
    "assets/images/dev-guides/nginx_config_snippet.webp",
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
      title: "Flutter Web & SEO: Полное руководство | Блог Даниила Шастовского",
      description:
          "Как сделать ваш Flutter сайт видимым для поисковых систем. Настройка рендеринга, мета-теги, sitemap и pre-rendering.",
      imageUrl:
          "https://shastovsky.ru/assets/assets/images/dev-guides/flutter_ssg_flowchart.webp",
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
      //backgroundColor: Colors.white,// Убираем, чтобы использовать тему
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
                  "Flutter Web & SEO: Полное руководство по SSG",
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
                  BreadcrumbItem(text: "Flutter Web & SEO"), // Текущая страница
                ],
              ),
            ),
            const SizedBox(height: 20),
            /*const Align(
              alignment: Alignment.centerLeft,
              child: TextBodySecondary(text: "Полезное / Разработка / Flutter Web & SEO"),
            ),*/
            const TextBody(
              text:
                  "Flutter Web позволяет создавать потрясающе красивые и быстрые веб-приложения. Но есть одна проблема, с которой сталкиваются разработчики: поисковая оптимизация (SEO). По умолчанию Flutter Web рендерит сайт как Single Page Application (SPA), что исторически плохо индексируется поисковыми роботами. Решение? Пререндеринг или генерация статических сайтов (SSG).",
            ),

            const TextHeadlineSecondary(
                text: "Проблема: почему SPA и SEO — не лучшие друзья?"),
            const TextBody(
              text:
                  "Поисковые роботы (краулеры) Google любят простой и понятный HTML. Когда робот заходит на стандартный Flutter Web сайт, он видит почти пустую HTML-страницу с тегом `<script>`, который загружает все приложение. Робот может попытаться исполнить JavaScript, но это не всегда получается идеально, и в результате он не видит ваш контент, заголовки и ссылки. Для поисковика ваш сайт выглядит как пустой лист.",
            ),

            const TextHeadlineSecondary(
                text: "Решение: Пререндеринг (Static Site Generation - SSG)"),
            const ImageWrapper(
                image: "assets/images/dev-guides/flutter_ssg_flowchart.webp"),
            const Align(
              alignment: Alignment.center,
              child: TextBodySecondary(
                  text:
                      "Схема работы пререндеринга: ботам - готовый HTML, пользователям - интерактивное приложение"),
            ),
            const TextBody(
                text:
                    "Суть пререндеринга проста: мы заранее 'отрисовываем' каждую страницу нашего Flutter-приложения в чистый HTML-файл. Когда поисковый бот запрашивает страницу, мы отдаем ему этот готовый HTML. А когда на сайт заходит реальный пользователь, мы загружаем полноценное интерактивное SPA-приложение."),
            const TextBody(
                text:
                    "Таким образом, мы убиваем двух зайцев: поисковики видят весь контент и прекрасно его индексируют, а пользователи получают богатый интерактивный опыт."),

            const TextHeadlineSecondary(
                text: "Как настроить пререндеринг для Flutter Web?"),
            const TextBody(text: "Есть два основных подхода:"),

            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("1. Сторонние сервисы (например, Prerender.io)",
                      style: boldStyle),
                  const TextBody(
                      text:
                          "Это самый простой способ. Вы регистрируетесь в сервисе, и он предоставляет вам middleware для вашего сервера. Этот middleware определяет, является ли посетитель ботом. Если да, он перенаправляет запрос на серверы Prerender, где ваша страница отрисовывается и возвращается боту в виде HTML. Для пользователя ничего не меняется."),
                  const SizedBox(height: 16),
                  Text("2. Собственное решение (Node.js + Puppeteer)",
                      style: boldStyle),
                  const TextBody(
                      text:
                          "Более сложный, но гибкий вариант. Вы создаете небольшой сервер на Node.js, который использует библиотеку Puppeteer (или Playwright) для запуска headless-браузера. Этот браузер открывает страницы вашего Flutter-сайта, дожидается их полной загрузки и сохраняет итоговый HTML. Эти HTML-файлы можно сгенерировать один раз при сборке проекта (true SSG) или генерировать их на лету."),
                ],
              ),
            ),

            const TextHeadlineSecondary(
                text: "Ключевой момент: Конфигурация веб-сервера"),
            const TextBody(
                text:
                    "Независимо от выбранного способа, вам нужно настроить ваш веб-сервер (Nginx, Apache) так, чтобы он различал ботов и пользователей. Это делается проверкой User-Agent'a запроса."),
            const ImageWrapper(
                image: "assets/images/dev-guides/nginx_config_snippet.webp"),
            const Align(
              alignment: Alignment.center,
              child: TextBodySecondary(
                  text:
                      "Пример конфигурации Nginx для перенаправления ботов на сервис пререндеринга"),
            ),

            const TextBlockquote(
                text:
                    "Инвестиции в настройку SSG для Flutter Web окупаются сторицей. Вы получаете не только отличные показатели SEO, но и значительно улучшаете скорость первоначальной загрузки (FCP) для пользователей, что также является важным фактором ранжирования."),

            const SizedBox(height: 40),
            // <<< БЛОК С ТЕГАМИ, P.S. И СОЦСЕТЯМИ >>>
            const Align(
              alignment: Alignment.centerLeft,
              child: TagWrapper(tags: [
                Tag(tag: "Flutter"),
                Tag(tag: "SEO"),
                Tag(tag: "Web"),
              ]),
            ),
            const SizedBox(height: 20),
            const ShareButtonsBlock(), // <<< ДОБАВЛЕН ВИДЖЕТ ДЛЯ КНОПОК ПОДЕЛИТЬСЯ >>>
            const SizedBox(height: 40),
            // <<< ВИДЖЕТ ДЛЯ ПОКАЗА СВЯЗАННЫХ СТАТЕЙ >>>
            const RelatedArticles(
              currentArticleRouteName:
                  PostFlutterSeoPage.name, // Название ТЕКУЩЕЙ страницы
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
                  BreadcrumbItem(text: "Flutter Web & SEO"), // Текущая страница
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
