// lib/pages/page_technical_audit_post.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minimal/components/related_articles.dart';
import 'package:minimal/pages/pages.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:url_launcher/url_launcher.dart';

class PostTechnicalAuditPage extends StatefulWidget {
  static const String name = 'useful/seo/technical-audit-checklist';

  const PostTechnicalAuditPage({super.key});

  @override
  State<PostTechnicalAuditPage> createState() => _PostTechnicalAuditPageState();
}

class _PostTechnicalAuditPageState extends State<PostTechnicalAuditPage> {
  final List<String> _pageImages = [
    "assets/images/seo-guides/techcheck_website_seo.webp",
    "assets/images/seo-guides/gsc_coverage_errors.webp",
    "assets/images/seo-guides/pagespeed_insights_report.webp",
    "assets/images/seo-guides/gsc_robots_tester.webp",
    "assets/images/seo-guides/ahrefs_backlink_profile.webp",
    "assets/images/avatar_default.webp",
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final imagePath in _pageImages) {
      precacheImage(AssetImage(imagePath), context);
    }
  }

  // Вспомогательный виджет для создания кликабельных ссылок в тексте
  TextSpan _linkTextSpan(String text, String url) {
    return TextSpan(
      text: text,
      style: bodyTextStyle(context).copyWith(
        color: Colors.blue,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () => launchUrl(Uri.parse(url)),
    );
  }

  // Виджет для подзаголовков внутри пунктов
  Widget _subHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(text,
          style: bodyTextStyle(context).copyWith(fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    final theme = Theme.of(context);

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
            // <<< ИЗМЕНЕНИЕ: Выравнивание заголовка по левому краю >>>
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: marginBottom12,
                child: Text(
                  "Полный чек-лист по техническому аудиту сайта",
                  style: headlineTextStyle(context),
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
                  BreadcrumbItem(text: "Технический аудит"), // Текущая страница
                ],
              ),
            ),
            const SizedBox(height: 20),
            /*const Align(
              alignment: Alignment.centerLeft,
              child:
                  TextBodySecondary(text: "Полезное / SEO / Технический аудит"),
            ),*/
            const TextBody(
              text:
                  "Техническое состояние сайта — это фундамент, на котором строятся все остальные работы по продвижению. Если у поискового робота проблемы с доступом к вашему сайту, никакой гениальный контент не поможет. Этот исчерпывающий чек-лист, основанный на многолетней практике, поможет вам выявить и устранить 99% технических проблем, мешающих росту.",
            ),
            const ImageWrapper(
                image: "assets/images/seo-guides/techcheck_website_seo.webp"),

            // <<< ИЗМЕНЕНИЕ: Добавлено пространство перед заголовком раздела >>>
            const SizedBox(height: 24),
            const TextHeadlineSecondary(text: "Техническая оптимизация"),

            const TextHeadlineSecondary(text: "1. Редиректы"),
            const TextBody(
                text:
                    "Правильная настройка редиректов (перенаправлений) критически важна, чтобы не терять ссылочный вес и не запутывать поисковых роботов дублями страниц."),
            _subHeader("На главное зеркало"),
            const TextBody(
                text:
                    "• С www или без www: Определитесь, какой URL является основным (например, `https://site.ru`), и настройте 301 редирект со всех остальных вариантов (`https://www.site.ru`, `http://site.ru` и т.д.) на него.\n• Со страниц index.php/html: Убедитесь, что `https://site.ru/index.php` и `/index.html` ведут на `https://site.ru/`."),
            _subHeader("На слэш в конце URL"),
            const TextBody(
                text:
                    "• Для поисковика `/page/` и `/page` — это две разные страницы. Выберите один формат и настройте 301 редирект на него для всего сайта."),
            _subHeader("Цепочки редиректов"),
            const TextBody(
                text:
                    "• Избегайте цепочек вида A -> B -> C. Все неглавные зеркала должны сразу перенаправлять на целевую страницу (A -> C). Проверить можно с помощью десктопных краулеров Netpeak Spider или Screaming Frog."),

            const TextHeadlineSecondary(text: "2. Дубли сайта"),
            RichText(
                text: TextSpan(style: bodyTextStyle(context), children: [
              const TextSpan(
                  text:
                      "• По IP-адресу: Сайт не должен открываться по своему IP. Узнать IP можно через сервис "),
              _linkTextSpan("2ip.ru", "https://2ip.ru/analizator/"),
              const TextSpan(
                  text:
                      ".\n• С указанием порта: Страницы вида `https://site.ru:443/` должны быть недоступны или перенаправлять на основной домен.\n• Служебные поддомены: Убедитесь, что технические домены (`dev.site.ru`, `test.site.ru`) закрыты от индексации через `robots.txt` или защищены паролем."),
            ])),
            const SizedBox(height: 24),

            const TextHeadlineSecondary(text: "3. Индексация страниц"),
            const TextBody(
                text:
                    "Проверьте количество страниц в индексе Яндекса и Google с помощью оператора `site:vash-site.ru`. Например, в Яндексе может быть 170 страниц, а в Google — 190. Такая разница — повод для анализа отчетов в панелях вебмастеров, чтобы понять, какие страницы не попали в индекс или, наоборот, попали лишние."),

            const TextHeadlineSecondary(
                text: "4. Ответы сервера и наличие ошибок"),
            const ImageWrapper(
                image: "assets/images/seo-guides/gsc_coverage_errors.webp"),
            const Align(
                alignment: Alignment.center,
                child: TextBodySecondary(
                    text:
                        "Отчет 'Покрытие' в Google Search Console — ваш главный помощник в поиске ошибок")),
            RichText(
                text: TextSpan(style: bodyTextStyle(context), children: [
              const TextSpan(
                  text:
                      "• Существующие страницы должны отдавать код `200 OK`, несуществующие — `404 Not Found`. Проверить можно через "),
              _linkTextSpan("Bertal.ru", "https://bertal.ru/"),
              const TextSpan(
                  text:
                      ".\n• Битые ссылки (404 ошибки): Найдите и исправьте все внутренние ссылки, ведущие на несуществующие страницы. Это можно сделать с помощью краулеров.\n• Ошибки сервера (5xx): Регулярно проверяйте отчеты в GSC и Яндекс.Вебмастере на наличие серверных ошибок. Они критичны для индексации."),
            ])),
            const SizedBox(height: 24),

            const TextHeadlineSecondary(text: "5. Скорость загрузки"),
            const ImageWrapper(
                image:
                    "assets/images/seo-guides/pagespeed_insights_report.webp"),
            const Align(
                alignment: Alignment.center,
                child: TextBodySecondary(
                    text:
                        "Стремитесь к 'зеленой зоне' в отчете PageSpeed Insights")),
            RichText(
                text: TextSpan(style: bodyTextStyle(context), children: [
              const TextSpan(
                  text:
                      "Скорость — ключевой фактор ранжирования. Проверьте главную и типовую внутреннюю страницу через "),
              _linkTextSpan("Google PageSpeed Insights",
                  "https://developers.google.com/speed/pagespeed/insights/"),
              const TextSpan(
                  text:
                      ". Обратите внимание на показатели Core Web Vitals (LCP, INP, CLS). Также проверьте, включено ли Gzip-сжатие через "),
              _linkTextSpan("этот сервис",
                  "https://www.whatsmyip.org/http-compression-test/"),
              const TextSpan(text: ".")
            ])),
            const SizedBox(height: 24),

            const TextHeadlineSecondary(
                text: "6. Файлы robots.txt и sitemap.xml"),
            const ImageWrapper(
                image: "assets/images/seo-guides/gsc_robots_tester.webp"),
            const Align(
                alignment: Alignment.center,
                child: TextBodySecondary(
                    text: "Анализ файла robots.txt в Google Search Console")),
            _subHeader("robots.txt"),
            const TextBody(
                text:
                    "• Закройте от индексации служебные разделы: `/admin/`, `/wp-admin/`, страницы поиска по сайту, фильтры, сортировки, корзину, личный кабинет. Можно разделить директивы для разных ботов (User-agent: Yandex, User-agent: Googlebot).\n• Укажите путь к карте сайта директивой `Sitemap: https://site.ru/sitemap.xml`.\n• Проверьте в Google Search Console, что роботу доступны важные CSS и JS файлы для корректного рендеринга страницы."),
            _subHeader("sitemap.xml"),
            const TextBody(
                text:
                    "• Карта сайта должна быть валидной, без ошибок и содержать только канонические страницы с кодом ответа 200. В ней не должно быть редиректов, 404-х и закрытых от индексации страниц.\n• `lastmod` и `priority`: Используйте эти теги осмысленно. Не ставьте всем страницам `priority 1.0`. Указывайте реальную дату последнего обновления в `lastmod`."),

            const TextHeadlineSecondary(text: "7. Валидность HTML-кода"),
            RichText(
                text: TextSpan(style: bodyTextStyle(context), children: [
              const TextSpan(
                  text:
                      "Ошибки в HTML-коде могут мешать корректному отображению и индексации. Проверить главную страницу можно через "),
              _linkTextSpan("W3C Validator", "https://validator.w3.org/"),
              const TextSpan(
                  text:
                      ". Небольшое количество ошибок — не критично, но грубые нарушения стоит исправить."),
            ])),
            const SizedBox(height: 24),

            const TextHeadlineSecondary(
                text: "8. Адаптивность и кросс-браузерность"),
            RichText(
                text: TextSpan(style: bodyTextStyle(context), children: [
              const TextSpan(
                  text:
                      "Сайт должен корректно отображаться на всех устройствах. Проверьте его с помощью "),
              _linkTextSpan("Google Mobile-Friendly Test",
                  "https://search.google.com/test/mobile-friendly?hl=ru"),
              const TextSpan(
                  text:
                      " и обязательно протестируйте вручную на смартфонах и планшетах в разных браузерах (Chrome, Safari)."),
            ])),
            const SizedBox(height: 24),

            const TextHeadlineSecondary(text: "9. SSL-сертификат"),
            RichText(
                text: TextSpan(style: bodyTextStyle(context), children: [
              const TextSpan(
                  text:
                      "Наличие HTTPS — обязательно. Проверьте качество вашего сертификата через "),
              _linkTextSpan(
                  "SSL Labs Test", "https://www.ssllabs.com/ssltest/"),
              const TextSpan(
                  text:
                      ". Рейтинг должен быть не ниже A. Убедитесь, что в коде сайта не осталось внутренних ссылок на `http://`."),
            ])),
            const SizedBox(height: 24),

            const TextHeadlineSecondary(text: "10. Микроразметка"),
            RichText(
                text: TextSpan(style: bodyTextStyle(context), children: [
              const TextSpan(
                  text:
                      "Микроразметка Schema.org помогает поисковикам лучше понимать контент и формировать расширенные сниппеты. Внедрите разметку `Organization` (на странице контактов), `BreadcrumbList` (для 'хлебных крошек'), `Product` (для товаров). Корректность проверяйте в "),
              _linkTextSpan(
                  "Валидаторе Schema.org", "https://validator.schema.org/"),
              const TextSpan(text: " и в отчете 'Улучшения' в GSC."),
            ])),

            // <<< ИЗМЕНЕНИЕ: Добавлено пространство перед заголовком раздела >>>
            const SizedBox(height: 24),
            const TextHeadlineSecondary(text: "Внутренняя оптимизация"),

            const TextHeadlineSecondary(text: "11. Структура и URL"),
            _subHeader("Структура"),
            const TextBody(
                text:
                    "• Иерархия должна быть логичной и не слишком глубокой (в идеале — не более 3-4 кликов от главной до любой страницы).\n• Навигация (меню, 'хлебные крошки') должна быть интуитивно понятной."),
            _subHeader("URL"),
            const TextBody(
                text:
                    "• Используйте ЧПУ (человекопонятные URL): `site.ru/services/seo-audit`, а не `site.ru/cat.php?id=123`.\n• Используйте латиницу, дефисы в качестве разделителей. Избегайте длинных URL и переспама ключами."),

            const TextHeadlineSecondary(text: "12. Мета-теги и заголовки"),
            _subHeader("Title и Description"),
            const TextBody(
                text:
                    "• Title и Description должны быть уникальными для каждой страницы.\n• Title должен быть не длиннее 60-70 символов, Description — не длиннее 150-160.\n• Они должны точно отражать содержимое страницы и содержать основной ключевой запрос."),
            _subHeader("Заголовки H1-H6"),
            const TextBody(
                text:
                    "• На странице должен быть только один заголовок H1, уникальный для всего сайта.\n• Заголовки H2-H6 должны использоваться для создания логической структуры текста и не должны применяться для стилизации."),

            const TextHeadlineSecondary(text: "13. Контент и изображения"),
            _subHeader("Контент"),
            RichText(
                text: TextSpan(style: bodyTextStyle(context), children: [
              const TextSpan(
                  text:
                      "• Уникальность: Проверяйте тексты на уникальность через сервисы вроде "),
              _linkTextSpan("Advego", "https://advego.com/text/plag/"),
              const TextSpan(
                  text:
                      ".\n• Добавочная ценность: Ваш контент должен быть полезнее, чем у конкурентов. Используйте таблицы, списки, видео, инфографику, калькуляторы."),
            ])),
            _subHeader("Изображения"),
            const TextBody(
                text:
                    "• Атрибуты alt и title: У всех изображений должны быть прописаны осмысленные alt-теги. Это помогает в поиске по картинкам.\n• Оптимизация: Изображения должны быть сжаты без видимой потери качества."),

            const TextHeadlineSecondary(text: "14. Внешняя ссылочная масса"),
            const ImageWrapper(
                image: "assets/images/seo-guides/ahrefs_backlink_profile.webp"),
            const Align(
                alignment: Alignment.center,
                child: TextBodySecondary(
                    text: "Анализ динамики ссылочной массы в Ahrefs")),
            RichText(
                text: TextSpan(style: bodyTextStyle(context), children: [
              const TextSpan(
                  text: "Проанализируйте ссылочный профиль с помощью "),
              _linkTextSpan("Ahrefs", "https://ahrefs.com/"),
              const TextSpan(
                  text:
                      ". Ищите резкие скачки/падения, которые могут сигнализировать о санкциях, и проверяйте качество доноров. Анкоры должны быть разнообразными, с преобладанием безанкорных ссылок (название бренда, URL)."),
            ])),
            const SizedBox(height: 24),

            const TextBlockquote(
                text:
                    "Регулярный технический аудит (хотя бы раз в квартал) — это гигиена вашего сайта. Он помогает вовремя находить и исправлять проблемы, которые могут стоить вам трафика и позиций."),

            const SizedBox(height: 40),

            const Align(
              alignment: Alignment.centerLeft,
              child: TagWrapper(tags: [
                Tag(tag: "SEO"),
                Tag(tag: "Техническое SEO"),
                Tag(tag: "Аудит"),
                Tag(tag: "Чек-лист"),
              ]),
            ),
            // <<< ВИДЖЕТ ДЛЯ ПОКАЗА СВЯЗАННЫХ СТАТЕЙ >>>
            const RelatedArticles(
              currentArticleRouteName:
                  PostTechnicalAuditPage.name, // Название ТЕКУЩЕЙ страницы
              category: 'seo', // Категория, из которой показывать статьи
            ),
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

            // <<< ИЗМЕНЕНИЕ: Полный блок кнопок социальных сетей >>>
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
                  BreadcrumbItem(text: "Технический аудит"), // Текущая страница
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
