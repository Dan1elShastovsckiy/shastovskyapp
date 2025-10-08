// lib/pages/pages_useful/page_seo_ai_post.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minimal/components/related_articles.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/components/share_buttons_block.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart'
    hide MaxWidthBox;
import 'package:url_launcher/url_launcher.dart';
import 'package:minimal/utils/meta_tag_service.dart';
import 'package:minimal/components/feature_tile.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PostSeoAiPage extends StatefulWidget {
  static const String name = 'useful/seo/seo-ai-era';

  const PostSeoAiPage({super.key});

  @override
  State<PostSeoAiPage> createState() => _PostSeoAiPageState();
}

class _PostSeoAiPageState extends State<PostSeoAiPage> {
  final List<String> _pageImages = [
    "assets/images/seo-ai-era/strategic_hobo_table.webp",
    "assets/images/seo-ai-era/eeat_diagram.webp",
    "assets/images/seo-ai-era/yandex_ai_summary_example.webp",
    "assets/images/seo-ai-era/ai_debug_example.webp",
    "assets/images/seo-ai-era/ahrefs_ai_overview_study.webp",
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
      title: "SEO в эпоху AI: Новые правила игры | Блог Даниила Шастовского",
      description:
          "Как Google SGE и другие нейросети меняют поисковую оптимизацию. Практическое руководство по адаптации стратегии.",
      imageUrl:
          "https://shastovsky.ru/assets/assets/images/seo-ai-era/eeat_diagram.webp",
    );
  }

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

  void _showGoogleLawsuitInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text("Про судебный иск против Google",
              style: headlineSecondaryTextStyle(context)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Этот антимонопольный иск привел к беспрецедентному раскрытию внутренней работы алгоритмов Google. Ключевые детали:",
                  style: bodyTextStyle(context),
                ),
                const SizedBox(height: 16),
                MarkdownBody(
                  data:
                      "• **Раскрытие архитектуры ранжирования:** Иск выявил сложную, многоэтапную архитектуру, включающую три основные системы: `Topicality (T*)`, `Quality Score (Q*)` и `Navboost`.\n\n"
                      "• **Подтверждение давних подозрений (The Four Great Vindications):** Утечка внутренних документов Google ('Content Warehouse') подтвердила четыре основных факта, которые Google ранее публично отрицал или не раскрывал\n\n"
                      "• **Роль машинного обучения (ML):** ML-системы, такие как RankBrain и DeepRank, используются для сложных задач (вроде интерпретации новых запросов), но они работают поверх 'ручных' систем, что указывает на стремление Google к контролю.",
                  selectable: true,
                  styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                    p: bodyTextStyle(context),
                    listBullet: bodyTextStyle(context),
                    code: bodyTextStyle(context).copyWith(
                      fontFamily: 'monospace',
                      backgroundColor:
                          theme.colorScheme.surface.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Понятно"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
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
                BreadcrumbItem(text: "Полезное", routeName: '/useful'),
                BreadcrumbItem(text: "SEO", routeName: '/useful/seo'),
                BreadcrumbItem(text: "SEO в эпоху ИИ"),
              ]),
            ),
            const SizedBox(height: 40),
            Text("SEO в эпоху ИИ: Новые правила ранжирования",
                style: headlineTextStyle(context), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Text(
              "Приветствую вас, коллеги-SEO-специалисты! Сегодня мы погрузимся в самые глубины новой эры поиска, где искусственный интеллект меняет правила игры. Обсудим утечки Google и практические шаги для оптимизации в эру AI Overviews.",
              style: subtitleTextStyle(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            const TextHeadlineSecondary(
                text: "Смена парадигмы: от традиционного SEO к SEO эпохи AI"),
            MarkdownBody(
              data:
                  "Дамир Халилов, автор книги «ChatGPT на каждый день», справедливо отмечает: **«началась новая эпоха»**, и ключевым навыком становится именно работа с нейросетями. Это не просто модный тренд, а фундаментальное изменение.",
              selectable: true,
              styleSheet: MarkdownStyleSheet.fromTheme(theme)
                  .copyWith(p: bodyTextStyle(context)),
            ),
            const SizedBox(height: 16), // Добавляем отступ между абзацами
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  const TextSpan(
                      text:
                          "О масштабе изменений говорят не только эксперты, но и реальные события: "),
                  TextSpan(
                    text:
                        "антимонопольный иск США против Google и нашумевшая утечка «Content Warehouse»",
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _showGoogleLawsuitInfo(context),
                  ),
                  const TextSpan(
                      text:
                          " в начале 2024 года, которая беспрецедентно раскрыла внутреннюю кухню алгоритмов Google."),
                ],
              ),
            ),
            const SizedBox(height: 16),
            MarkdownBody(
              data:
                  "Исследователь и глава SEO в компании **«Hobo Web» Шон Андерсон** в своей книге **«Strategic SEO 2025»** утверждает, что «основополагающие правила поиска были переписаны».",
              selectable: true,
              styleSheet: MarkdownStyleSheet.fromTheme(theme)
                  .copyWith(p: bodyTextStyle(context)),
            ),

            const ImageWrapper(
                image: "assets/images/seo-ai-era/strategic_hobo_table.webp"),
            const SizedBox(height: 20),

            const TextHeadlineSecondary(
                text: "Глубокое погружение в алгоритмы Google: что мы узнали"),
            const TextBody(
                text:
                    "Ранее скрытая информация теперь на поверхности. Google использует сложную, многоэтапную архитектуру ранжирования:"),

            const FeatureTile(
              icon: Icons.filter_1,
              title: "Topicality (T*) – Тематическая релевантность",
              content:
                  "Это базовый балл, определяющий прямую релевантность документа к запросу. Он основан на 'ручных' сигналах и включает три компонента:\n\n"
                  "• **A (Anchors):** Текст гиперссылок, указывающих на документ.\n"
                  "• **B (Body):** Присутствие и заметность терминов запроса в тексте документа.\n"
                  "• **C (Clicks):** Взаимодействие пользователя – как долго он оставался на странице после клика. Это прямое подтверждение, что клики являются основным сигналом релевантности.",
            ),
            const FeatureTile(
              icon: Icons.filter_2,
              title: "Quality Score (Q*) – Показатель качества",
              content:
                  "Это ранее скрытый внутренний показатель, оценивающий 'общую надежность и качество веб-сайта/домена'. Он в значительной степени статичен и не зависит от запроса, что противоречит многолетним публичным заявлениям Google.\n\n"
                  "Ключевым входом для Q* является обновленная версия PageRank, измеряющая 'расстояние от известного хорошего источника'. Сайты, близкие к авторитетным 'семенным' сайтам в ссылочном графе, получают более высокий Q*.",
            ),
            const FeatureTile(
              icon: Icons.filter_3,
              title: "Navboost – Корректировка на основе поведения",
              content:
                  "Эта система уточняет ранжирование на основе 'масштабного, исторического хранилища данных о взаимодействии пользователей'. Navboost анализирует 13 месяцев данных о кликах, чтобы выявить закономерности удовлетворенности.\n\n"
                  "Это означает, что **пользовательский опыт (UX)**, особенно после клика, стал новым ядром SEO. Плохой UX, приводящий к быстрому возврату на поиск ('пого-стикингу'), является негативным сигналом.",
            ),
            const FeatureTile(
              icon: Icons.filter_4,
              title: "RankBrain – Интерпретатор запросов",
              content:
                  "Это система машинного обучения, которая интерпретирует поисковые запросы, особенно новые или неоднозначные. RankBrain не заменяет другие сигналы, а работает поверх 'ручных' систем (T*, Q*), дополняя их.",
            ),

            const TextBlockquote(
              text:
                  "Машинное обучение используется для сложных задач, но оно работает поверх 'ручных' систем, что подтверждает стремление Google к контролю над поиском.",
            ),

            const TextHeadlineSecondary(
                text: "Неочевидные факторы ранжирования"),

            const FeatureTile(
              icon: Icons.verified_user_outlined,
              title: "siteAuthority, 'Песочница' и белые списки",
              content:
                  "• **siteAuthority реально:** Да, общий показатель качества или доверия для всего веб-сайта существует и влияет на ранжирование.\n\n"
                  "• **'Песочница' для новых сайтов (hostAge):** Новые домены рассматриваются с алгоритмическим подозрением, пока не накопят достаточную историю доверия.\n\n"
                  "• **Белые списки:** Документы указывают на существование потенциальных 'белых списков' (isElectionAuthority, isCovidLocalAuthority) для чувствительных тем YMYL (Your Money Your Life), где Google вручную повышает авторитетные источники.",
            ),
            const FeatureTile(
              icon: Icons.business,
              title: "Бренд – главный фактор ранжирования",
              content:
                  "Сильный бренд становится наиболее долговечным конкурентным преимуществом. Google измеряет общую репутацию домена (siteAuthority) и вознаграждает тех, на кого пользователи активно кликают и кому доверяют. **Брендированные запросы** – это самый сильный сигнал авторитетности.",
            ),
            const FeatureTile(
              icon: Icons.link_off,
              title: "Гипотеза 'отсоединенной сущности' (DEH)",
              content:
                  "Если Google не может связать ваш сайт с известной, надежной сущностью (компанией, автором), это вызывает недоверие в алгоритме. Неважно, насколько хороши ваши ссылки или контент – сайт будет испытывать трудности с ранжированием.\n\n"
                  "**Решение:** полная прозрачность идентификации (кто управляет сайтом, кто пишет контент). Это включает контактную информацию, биографии авторов, использование микроразметки (Schema.org) и создание положительной репутации.",
            ),

            const ImageWrapper(
                image: "assets/images/seo-ai-era/eeat_diagram.webp"),
            const SizedBox(height: 20),

            const TextHeadlineSecondary(
                text: "Контентная стратегия в новую эру"),

            const FeatureTile(
              icon: Icons.military_tech_outlined,
              title: "E-E-A-T (Опыт, Экспертиза, Авторитетность, Доверие)",
              content:
                  "Теперь с добавлением **'Опыта' (Experience)**, а **'Траст' (доверие)** назван 'самым важным членом семейства E-E-A-T'. Это означает, что недостаточно просто быть экспертом; нужно демонстрировать реальный опыт и быть прозрачным. Отсутствие информации о владельце сайта и создателях контента – 'красный флаг'.\n\n"
                  "**Неочевидная деталь:** В тексте должны быть фразы, демонстрирующие личный опыт ('Мы протестировали 10 сервисов, и вот наш вывод...', 'За 5 лет работы мы поняли, что...').",
            ),
            const FeatureTile(
              icon: Icons.thumb_up_alt_outlined,
              title:
                  "Helpful Content Update (HCU) и подход 'Ответ-прежде-всего'",
              content:
                  "Это обновление нацелено на понижение 'бесполезного' контента. Малым и средним сайтам HCU нанес 'разрушительное воздействие', и восстановление после него очень трудно.\n\n"
                  "**Подход 'Ответ-прежде-всего':** Структурируйте текст по принципу 'перевернутой пирамиды', где самый важный и прямой ответ на вопрос пользователя находится в начале, в первых абзацах.",
            ),

            const TextHeadlineSecondary(
                text: "Практические шаги для внедрения"),

            const FeatureTile(
              icon: Icons.checklist_rtl,
              title: "Чек-лист по адаптации к AI-поиску",
              content: """
**1. Фундаментальная индексация:**
*   Убедитесь, что в `robots.txt` нет блокировок для `Google-Extended`, `GPTBot`, `ChatGPT-User`, `PerplexityBot`.
*   Настройте IndexNow в Bing Webmaster Tools для быстрой отправки URL (критично для ChatGPT и Copilot).
*   Core Web Vitals и 'Удобство для мобильных' в GSC должны быть 'Хорошо'.

**2. Прямая проверка в ИИ-системах:**
*   Тестируйте свой сайт 'глазами' нейросети: задавайте вопросы в Яндекс.Алисе, ChatGPT, Google Gemini.
*   Убедитесь, что AI правильно распознает ключевые данные (особенно цены и предложения).
*   Используйте атрибут `data-nosnippet` для 'сокрытия' от роботов той части контента, которая должна мотивировать пользователя перейти на сайт.

**3. Структура контента:**
*   Используйте строгую иерархию заголовков (`<h1>`, `<h2>`), списки, таблицы.
*   Внедряйте микроразметку Schema.org (`Article`, `FAQPage`, `Product`, `Organization`).

**4. Глубокий аудит контента:**
*   Организуйте контент в тематические кластеры ('контент-хабы') с мощной внутренней перелинковкой.
*   Добавляйте уникальные данные, оригинальные исследования, опросы, глубокий личный опыт. ИИ ищет первоисточники.
*   Обогащайте текст таблицами, инфографикой, уникальными фото и видео.

**5. Анализ силы бренда:**
*   Ищите упоминания вашего бренда в интернете даже без ссылок (unlinked brand mentions), особенно на Reddit, Quora, Яндекс Кью и профильных форумах.
*   Проверьте полноту и рейтинг профилей в Google Business Profile / Яндекс Бизнес.
""",
            ),

            const ImageWrapper(
                image: "assets/images/seo-ai-era/ai_debug_example.webp"),
            const SizedBox(height: 20),

            const TextBody(
                text:
                    "Неочевидная деталь: Отладка ошибок с помощью AI. В отличие от классических поисковиков, AI-системам можно задавать прямые вопросы и получать советы по устранению проблем с парсингом вашей страницы."),

            const SizedBox(height: 20),
            const TextBlockquote(
              text:
                  "Важный комментарий: Хотя утечки дали нам много ценной информации, не стоит воспринимать ее как догму. Алгоритмы Google постоянно меняются. Ключ к успеху — в адаптации и фокусе на качестве для пользователя, а не в слепом следовании 'секретным' факторам.",
            ),

            const TextHeadlineSecondary(
                text: "Заключение: комплексный подход – ключ к успеху"),

            const TextBlockquote(
                text:
                    "Новая эра SEO требует от нас гибкости и глубокого понимания не только алгоритмов, но и того, как AI обрабатывает информацию и как пользователи взаимодействуют с поиском."),

            const TextBody(
                text:
                    "SEO перестает быть только про 'ключевые слова и ссылки'. Это непрерывный цикл внедрения, измерения и адаптации, требующий инженерного подхода и постоянного развития. Осваивайте promt-инжиниринг, экспериментируйте с AI-агентами, и пусть ваш интеллект поможет вам в работе с интеллектом искусственным.\n\nСпасибо, что дочитали)"),
            // ... (остальная часть страницы: теги, похожие статьи, футер)
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: TagWrapper(tags: [
                Tag(tag: "SEO"),
                Tag(tag: "AI"),
                Tag(tag: "Google"),
                Tag(tag: "Ранжирование"),
                Tag(tag: "E-E-A-T"),
              ]),
            ),
            const SizedBox(height: 20),
            const ShareButtonsBlock(), // <<< ДОБАВЛЕН ВИДЖЕТ ДЛЯ КНОПОК ПОДЕЛИТЬСЯ >>>
            const SizedBox(height: 40),
            const RelatedArticles(
              currentArticleRouteName: PostSeoAiPage.name,
              category: 'seo',
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
                          text: " или подписаться на меня в инстаграм "),
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
                          text:
                              " в нем я делюсь фото и видео из своих поездок."),
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
                              Uri.parse('https://t.me/switchleveler'))),
                      ElevatedButton.icon(
                          icon: Icon(Icons.campaign,
                              color: theme.colorScheme.onSurface),
                          label: const Text('Telegram канал'),
                          style: elevatedButtonStyle(context),
                          onPressed: () =>
                              launchUrl(Uri.parse('https://t.me/shastovscky'))),
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
                                        color: theme.colorScheme.secondary))
                              ]),
                          style: elevatedButtonStyle(context),
                          onPressed: () => launchUrl(
                              Uri.parse('https://instagram.com/yellolwapple'))),
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
                                        color: theme.colorScheme.secondary))
                              ]),
                          style: elevatedButtonStyle(context),
                          onPressed: () => launchUrl(Uri.parse(
                              'https://hh.ru/resume/b94af167ff049031c70039ed1f746c61797571'))),
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
                                        color: theme.colorScheme.secondary))
                              ]),
                          style: elevatedButtonStyle(context),
                          onPressed: () => launchUrl(
                              Uri.parse('https://www.youtube.com/@itsmyadv'))),
                      ElevatedButton.icon(
                          icon: Icon(Icons.article_outlined,
                              color: theme.colorScheme.onSurface),
                          label: const Text('VC.RU'),
                          style: elevatedButtonStyle(context),
                          onPressed: () =>
                              launchUrl(Uri.parse('https://vc.ru/id1145025'))),
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
                  BreadcrumbItem(text: "Полезное", routeName: '/useful'),
                  BreadcrumbItem(text: "SEO", routeName: '/useful/seo'),
                  BreadcrumbItem(text: "SEO в эпоху ИИ"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ...authorSection(
              context: context,
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
