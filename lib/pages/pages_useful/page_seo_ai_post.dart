// lib/pages/page_seo_ai_post.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minimal/pages/pages.dart';
import 'package:minimal/components/components.dart';
// <<< ИСПРАВЛЕНИЕ: Добавлен необходимый импорт для MaxWidthBox и toMaxWidthSliver >>>
import 'package:minimal/utils/max_width_extension.dart';
import 'package:url_launcher/url_launcher.dart';

class PostSeoAiPage extends StatefulWidget {
  static const String name = 'useful/seo/seo-ai-era';

  const PostSeoAiPage({super.key});

  @override
  State<PostSeoAiPage> createState() => _PostSeoAiPageState();
}

class _PostSeoAiPageState extends State<PostSeoAiPage> {
  // Список всех изображений на странице для предварительного кэширования.
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
    // Предварительное кэширование всех изображений для улучшения производительности
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
                  "SEO в эпоху ИИ: Новые правила ранжирования",
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
                  BreadcrumbItem(text: "SEO в эпоху ИИ"), // Текущая страница
                ],
              ),
            ),
            const SizedBox(height: 20),
            /*const Align(
              alignment: Alignment.centerLeft,
              child: TextBodySecondary(text: "Полезное / SEO / SEO в Эпоху ИИ"),
            ),*/
            const TextBody(
              text:
                  "Приветствую вас, коллеги-SEO-специалисты! Сегодня мы погрузимся в самые глубины новой эры поиска, где искусственный интеллект меняет правила игры. Обсудим, как нам, практикам, не просто выживать, а получать преимущество.",
            ),
            const TextBody(
              text:
                  "Наша цель – разобраться в неочевидных факторах ранжирования и деталях, которые помогут сайтам лучше проявлять себя как в классическом поиске, так и в коротких AI-ответах.",
            ),

            // --- Смена парадигмы ---
            const TextHeadlineSecondary(
                text: "Смена парадигмы: от традиционного SEO к SEO эпохи AI"),
            const TextBody(
              text:
                  "Дамир Халилов, нейро-креатор и автор книги «ChatGPT на каждый день», справедливо отмечает: «началась новая эпоха», и ключевым навыком становится именно работа с нейросетями. Это не просто модный тренд, а фундаментальное изменение.",
            ),
            const TextBody(
              text:
                  "О масштабе изменений говорят не только эксперты, но и реальные события: антимонопольный иск США против Google и нашумевшая утечка «Content Warehouse» в начале 2024 года, которая беспрецедентно раскрыла внутреннюю кухню алгоритмов Google. Исследователь и глава SEO в компании «Hobo Web» Шон Андерсон в своей книге «Strategic SEO 2025» утверждает, что «основополагающие правила поиска были переписаны».",
            ),

            // --- Глубокое погружение в алгоритмы Google ---
            const TextHeadlineSecondary(
                text:
                    "Глубокое погружение в алгоритмы Google: что мы узнали из утечек"),
            const TextBody(
              text:
                  "Ранее скрытая информация теперь на поверхности. Google использует сложную, многоэтапную архитектуру ранжирования, состоящую из трех основных систем (и одной “неосновной”):",
            ),
            const ImageWrapper(
                image: "assets/images/seo-ai-era/strategic_hobo_table.webp"),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(style: bodyTextStyle(context), children: [
                      TextSpan(
                          text:
                              "1. Topicality (T) – Тематическая релевантность: ",
                          style:
                              boldStyle.copyWith(fontStyle: FontStyle.italic)),
                      const TextSpan(
                          text:
                              "Это базовый балл, определяющий прямую релевантность документа к запросу. Он основан на 'ручных' сигналах, разработанных инженерами Google, и включает три основных компонента (ABC):"),
                    ]),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBody(
                            text:
                                "◦ A (Anchors): Текст гиперссылок, указывающих на документ."),
                        TextBody(
                            text:
                                "◦ B (Body): Присутствие и заметность терминов запроса в тексте документа."),
                        TextBody(
                            text:
                                "◦ C (Clicks): Взаимодействие пользователя – то, как долго пользователь оставался на просмотренной странице, прежде чем вернуться на страницу результатов поиска (SERP). Это прямое подтверждение того, что клики являются основным сигналом релевантности, что долгое время отрицалось Google."),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(style: bodyTextStyle(context), children: [
                      TextSpan(
                          text: "2. Quality Score (Q) – Показатель качества: ",
                          style:
                              boldStyle.copyWith(fontStyle: FontStyle.italic)),
                      const TextSpan(
                          text:
                              "Это ранее скрытый внутренний показатель, оценивающий 'общую надежность и качество веб-сайта/домена'. Q* в значительной степени статичен и не зависит от запроса, что прямо противоречит многолетним публичным заявлениям Google об отсутствии 'общего показателя авторитетности домена'. Ключевым входом для Q* является обновленная версия PageRank, измеряющая 'расстояние от известного хорошего источника'. Сайты, близкие к авторитетным 'семенным' сайтам в ссылочном графе, получают более высокий Q*. Помните слова HJ Kim: 'Q (качество страницы, т.е. понятие надежности) невероятно важно для ранжирования'."),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    text: TextSpan(style: bodyTextStyle(context), children: [
                      TextSpan(
                          text:
                              "3. Navboost – Корректировка на основе поведения пользователей: ",
                          style:
                              boldStyle.copyWith(fontStyle: FontStyle.italic)),
                      const TextSpan(
                          text:
                              "Эта система уточняет ранжирование на основе 'масштабного, исторического хранилища данных о взаимодействии пользователей'. Navboost анализирует 13 месяцев агрегированных данных о кликах пользователей (хорошие/плохие/самые долгие клики), чтобы выявить устойчивые закономерности удовлетворенности пользователей. Это, пожалуй, самое значимое откровение судебного процесса. Это означает, что пользовательский опыт (UX), особенно после клика, стал новым ядром SEO. Плохой UX, приводящий к быстрому возврату на SERP ('пого-стикингу'), является негативным сигналом (badClick), тогда как удовлетворительный опыт приводит к lastLongestClick – мощному позитивному сигналу."),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    text: TextSpan(style: bodyTextStyle(context), children: [
                      TextSpan(text: "4. RankBrain: ", style: boldStyle),
                      const TextSpan(
                          text:
                              "Это одна из ключевых систем машинного обучения (ML) Google, официально подтвержденная в 2015 году, которая значительно изменила подход к пониманию поисковых запросов. Её основная функция — интерпретировать поисковые запросы, особенно те, которые являются новыми, неоднозначными или относятся к 'длинному хвосту' (то есть, уникальные запросы, которые Google ранее не встречал). RankBrain не заменяет другие фундаментальные сигналы ранжирования, такие как PageRank или тематическая релевантность (T*), но интегрируется с ними как дополняющий сигнал. Он работает поверх 'ручных' систем, разработанных инженерами Google (T*, Q*)."),
                    ]),
                  ),
                ],
              ),
            ),

            const TextBlockquote(
              text:
                  "Машинное обучение, в лице RankBrain и DeepRank, используется для сложных задач, таких как интерпретация новых запросов, но оно работает поверх этих 'ручных' систем (T*, Q*), что подтверждает стремление Google к контролю над поиском.",
            ),

            // --- Неочевидные факторы ---
            const TextHeadlineSecondary(
                text: "Неочевидные факторы ранжирования и последствия утечки"),
            const TextBody(
              text:
                  "Утечка Content Warehouse подтвердила давние подозрения и выявила 'глубокую пропасть между внутренней реальностью и тщательно сформированной публичной нарративой'. Вот несколько ключевых неочевидных факторов и выводов:",
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(style: bodyTextStyle(context), children: [
                    TextSpan(
                        text: "• siteAuthority реально: ", style: boldStyle),
                    const TextSpan(
                        text:
                            "Да, общий показатель качества или доверия для всего веб-сайта существует и влияет на ранжирование."),
                  ])),
                  const SizedBox(height: 16),
                  RichText(
                      text: TextSpan(style: bodyTextStyle(context), children: [
                    TextSpan(
                        text: "• 'Песочница' для новых сайтов (hostAge): ",
                        style: boldStyle),
                    const TextSpan(
                        text:
                            "Новые домены рассматриваются с алгоритмическим подозрением, пока не накопят достаточную историю доверия. Так что быстрого взлета для совсем свежих доменов не ждите."),
                  ])),
                  const SizedBox(height: 16),
                  RichText(
                      text: TextSpan(style: bodyTextStyle(context), children: [
                    TextSpan(text: "• Белые списки: ", style: boldStyle),
                    const TextSpan(
                        text:
                            "Документы указывают на существование потенциальных 'белых списков' (isElectionAuthority, isCovidLocalAuthority) для чувствительных тем YMYL (Your Money Your Life), где Google вручную повышает авторитетные источники. Это говорит о важности не только технической оптимизации, но и подтвержденного авторитета в нише."),
                  ])),
                  const SizedBox(height: 16),
                  RichText(
                      text: TextSpan(style: bodyTextStyle(context), children: [
                    TextSpan(
                        text: "• Бренд – главный фактор ранжирования: ",
                        style: boldStyle),
                    const TextSpan(
                        text:
                            "Сильный бренд становится наиболее долговечным конкурентным преимуществом. Google измеряет общую репутацию домена (siteAuthority) и вознаграждает тех, на кого пользователи активно кликают и кому доверяют. Брендированные запросы – это самый сильный сигнал авторитетности."),
                  ])),
                  const SizedBox(height: 16),
                  RichText(
                      text: TextSpan(style: bodyTextStyle(context), children: [
                    TextSpan(
                        text: "• Disconnected Entity Hypothesis (DEH): ",
                        style: boldStyle),
                    const TextSpan(
                        text:
                            "Если Google не может связать ваш сайт с известной, надежной сущностью, это вызывает недоверие в алгоритме. Неважно насколько хороши ваши ссылки или контент – сайт будет испытывать трудности с ранжированием для YMYL-запросов. Решение: полная прозрачность идентификации (кто управляет сайтом, кто пишет контент, почему это заслуживает доверия). Это включает контактную информацию, биографии авторов, использование структурированных данных (Schema.org) и создание положительной репутации в интернете."),
                  ])),
                ],
              ),
            ),

            // --- Контентная стратегия ---
            const TextHeadlineSecondary(
                text: "Контентная стратегия в новую эру: E-E-A-T, HCU и DEH"),
            const ImageWrapper(
                image: "assets/images/seo-ai-era/eeat_diagram.webp"),
            const TextBody(
                text:
                    "Google активно борется с 'контентом, ориентированным на поисковые системы', продвигая 'контент, ориентированный на человека'."),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(style: bodyTextStyle(context), children: [
                    TextSpan(
                        text:
                            "• E-E-A-T (Experience, Expertise, Authoritativeness, Trustworthiness): ",
                        style: boldStyle),
                    const TextSpan(
                        text:
                            "Теперь с добавлением 'Опыта' (Experience), а 'Траст' (доверие) назван 'самым важным членом семейства E-E-A-T'. Это означает, что недостаточно просто быть экспертом; нужно демонстрировать реальный опыт и быть прозрачным. Отсутствие информации о владельце сайта и создателях контента – 'красный флаг' и 'убийца доверия'."),
                  ])),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 8.0, bottom: 16.0),
                    child: RichText(
                        text: TextSpan(
                            style: bodyTextStyle(context)
                                .copyWith(fontStyle: FontStyle.italic),
                            children: const [
                          TextSpan(
                              text:
                                  "Неочевидная деталь: В тексте должны быть фразы, демонстрирующие личный опыт ('Мы протестировали 10 сервисов, и вот наш вывод...', 'За 5 лет работы мы поняли, что...')"),
                        ])),
                  ),
                  const TextBlockquote(
                      text:
                          "Подкрепляйте утверждения данными, схемами, инфографикой, а для авторитетности указывайте ссылки на публикации авторов в авторитетных СМИ."),
                  RichText(
                      text: TextSpan(style: bodyTextStyle(context), children: [
                    TextSpan(
                        text: "• Helpful Content Update (HCU): ",
                        style: boldStyle),
                    const TextSpan(
                        text:
                            "Это обновление нацелено на понижение 'бесполезного', 'ориентированного на поисковые системы' контента и повышение качества страниц 'созданных специально для людей'. Малым и средним сайтам, особенно аффилированным блогерам, HCU нанес 'разрушительное воздействие', и восстановление после него очень трудно. Google объясняет, что это не быстрые технические исправления, а фундаментальные изменения в подходе к созданию контента."),
                  ])),
                  const SizedBox(height: 16),
                  RichText(
                      text: TextSpan(style: bodyTextStyle(context), children: [
                    TextSpan(
                        text: "• Подход 'Ответ-прежде-всего': ",
                        style: boldStyle),
                    const TextSpan(
                        text:
                            "Структурируйте текст по принципу 'перевернутой пирамиды', где самый важный и прямой ответ на вопрос пользователя находится в начале, в первых абзацах. И так в каждом логическом блоке информации (чанке)."),
                  ])),
                  const SizedBox(height: 16),
                  RichText(
                      text: TextSpan(style: bodyTextStyle(context), children: [
                    TextSpan(text: "• Обогащение контента: ", style: boldStyle),
                    const TextSpan(
                        text:
                            "Добавляйте уникальные данные, оригинальные исследования, опросы, глубокий личный опыт – ИИ ищет первоисточники. Мультимодальный контент (таблицы, инфографика, уникальные фото и видео) лучше верифицируется и ценится роботами."),
                  ])),
                ],
              ),
            ),

            // --- Zero-Click Search ---
            const TextHeadlineSecondary(
                text: "Zero-Click Search и будущее маркетинга"),
            const TextBody(
                text:
                    "Рост 'нулевого клика' (Zero-Click Search), когда пользователи получают ответы прямо на SERP, трансформирует поиск. Google активно развивает такие функции, как Featured Snippets, Knowledge Panels, Direct Answer Boxes, Local Pack, People Also Ask (PAA)."),
            Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 24.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(
                              style: bodyTextStyle(context),
                              children: [
                            TextSpan(
                                text: "• AI Overviews (AIO): ",
                                style: boldStyle),
                            const TextSpan(
                                text:
                                    "Сводки, генерируемые AI (например, Gemini), синтезируют информацию из нескольких источников и отображаются в самом верху SERP, оттесняя все остальные результаты, включая рекламу. Это значительно увеличивает вероятность поиска с нулевым кликом."),
                          ])),
                    ])),
            const TextBody(
                text:
                    "Для издателей это 'экзистенциальный кризис', так как их бизнес зависит от трафика. Однако для местных сервисных предприятий Local Pack может быть 'мощным и чистым позитивным инструментом нулевого клика', обеспечивая немедленные ценные действия (звонки, бронирования)."),
            Text("Новая стратегия SEO ('Zero-Click Playbook') включает:",
                style: bodyTextStyle(context)),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, bottom: 24.0, top: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(style: bodyTextStyle(context), children: [
                    TextSpan(text: "• On-SERP SEO: ", style: boldStyle),
                    const TextSpan(
                        text:
                            "Цель – максимизировать видимость бренда внутри функций SERP. Это оптимизация для Featured Snippets, Local Pack и AIO (Answer Engine Optimization)."),
                  ])),
                  const SizedBox(height: 16),
                  RichText(
                      text: TextSpan(style: bodyTextStyle(context), children: [
                    TextSpan(
                        text: "• Построение 'моста' (Click-Independence): ",
                        style: boldStyle),
                    const TextSpan(
                        text:
                            "Создание сильного бренда и лояльного сообщества, чтобы снизить зависимость от трафика Google. Фокусируйтесь на брендированных запросах, развивайте собственные каналы (рассылки, соцсети) и полностью внедряйте E-E-A-T."),
                  ])),
                  const SizedBox(height: 16),
                  RichText(
                      text: TextSpan(style: bodyTextStyle(context), children: [
                    TextSpan(
                        text: "• Переосмысление измерений: ", style: boldStyle),
                    const TextSpan(
                        text:
                            "Отказ от традиционных метрик (CTR, органические сессии) в пользу 'видимости' (Impression Share, SERP Feature Wins) и роста объема брендированных запросов."),
                  ])),
                ],
              ),
            ),

            // --- Практические шаги ---
            const TextHeadlineSecondary(
                text: "Практические шаги и неочевидные детали для внедрения"),
            const TextBody(
                text:
                    "Теперь перейдем к конкретным действиям, опираясь на 'Чек-лист на GEO аудит сайта для продвижения в AI поисковиках и быстрых ответах'."),

            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "1. Фундаментальная индексация и доступность (Этап 1 Чек-листа):",
                      style: boldStyle),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBody(
                            text:
                                "• Убедитесь, что в robots.txt нет блокировок для Google-Extended, GPTBot, ChatGPT-User, PerplexityBot, YandexBot и других основных краулеров."),
                        TextBody(
                            text:
                                "• Настройте IndexNow в Bing Webmaster Tools для быстрой отправки URL – это критично для видимости в ChatGPT Search и Microsoft Copilot."),
                        TextBody(
                            text:
                                "• Техническое здоровье: Core Web Vitals и 'Удобство для мобильных' в Google Search Console должны быть 'Хорошо'."),
                      ],
                    ),
                  ),
                  Text(
                      "2. Прямая проверка в ИИ-системах и анализ (Этап 2 Чек-листа):",
                      style: boldStyle),
                  const ImageWrapper(
                      image:
                          "assets/images/seo-ai-era/yandex_ai_summary_example.webp"),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBody(
                            text:
                                "• Тестируйте свой сайт 'глазами' нейросети: Сформируйте список из 5 главных запросов и проверьте, как Яндекс.Алиса, Google AI Overview (за пределами РФ), ChatGPT и Google AI Studio (модель Gemini Flash) находят и интерпретируют информацию с вашего сайта."),
                        TextBody(
                            text:
                                "• Корректность информации: Убедитесь, что AI правильно распознает ключевые данные, особенно цены и предложения, на SPA-сайтах и сайтах с большим количеством JavaScript. AI может ошибаться, выбирая неактуальную цену."),
                        TextBody(
                            text:
                                "• Неочевидная деталь: Отладка ошибок с помощью AI (URL context, умные модели). В отличие от классических поисковиков, AI-системы позволяют задавать вопросы и получать советы по устранению проблем."),
                      ],
                    ),
                  ),
                  const ImageWrapper(
                      image: "assets/images/seo-ai-era/ai_debug_example.webp"),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBlockquote(
                            text:
                                "Я взял неправильную цену для [название продукта]. Она должна быть [правильная цена]. Открой страницу [URL страницы] и четко напиши мне, почему ты взял цену [неправильная цена], а не [правильная цена]. Я хочу, чтобы LLM всегда понимала, что актуальная цена - это меньшая цена. Оцени контент моей страницы и дай мне рекомендации, как оптимизировать код, структуру контента с учетом правильных данных включая цену."),
                        TextBody(
                            text:
                                "• Управление сниппетами: Используйте атрибут data-nosnippet для 'сокрытия' от роботов той части контента (например, точной цены или ключевого вывода), которая должна мотивировать пользователя перейти на сайт."),
                      ],
                    ),
                  ),
                  Text(
                      "3. Структура контента и семантическая верстка (Этап 3 Чек-листа):",
                      style: boldStyle),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextBody(
                            text:
                                "• HTML-структура: Единый заголовок <h1>, логическая иерархия подзаголовков (<h2>, <h3>), использование списков (<ul>, <ol>, <dl>) и таблиц (<table>)."),
                        const TextBody(
                            text:
                                "• Семантическая разметка: Используйте теги <article>, <section>, <strong> (а не <b>), <em>, <time>, <code>, <kbd>, <var>, <del>, <ins>."),
                        const TextBody(
                            text:
                                "• Микроразметка Schema.org: Внедряйте релевантные типы разметки (Article, FAQPage, HowTo, Product, Organization, Person) и связывайте их через атрибут @id. Это продвинутая техника, которая помогает Google лучше понимать сущности на вашем сайте."),
                        RichText(
                            text: TextSpan(
                                style: bodyTextStyle(context),
                                children: [
                              const TextSpan(
                                  text:
                                      "• Рендеринг контента: Проверяйте сохраненные копии страниц в Яндекс.Поиске и Google Search Console, а также используйте инструмент "),
                              _linkTextSpan("totheweb.com",
                                  "https://totheweb.com/learning_center/tools-convert-html-text-to-plain-text-for-content-review/"),
                              const TextSpan(
                                  text:
                                      ", чтобы увидеть, как Google видит контент вашей страницы."),
                            ])),
                        RichText(
                            text: TextSpan(
                                style: bodyTextStyle(context),
                                children: [
                              const TextSpan(
                                  text:
                                      "• Инструменты для проверки чанкирования: Используйте "),
                              _linkTextSpan(
                                  "relevancylens.seoworkflow.online/analyzer",
                                  "http://relevancylens.seoworkflow.online/analyzer"),
                              const TextSpan(
                                  text:
                                      " для анализа, какие 'чанки' информации AI находит на странице и насколько они релевантны."),
                            ])),
                      ],
                    ),
                  ),
                  Text(
                      "4. Глубокий аудит контента и тематического авторитета (Этап 4 Чек-листа):",
                      style: boldStyle),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBody(
                            text:
                                "• Контент-хабы ('структура кокона'): Организуйте контент в тематические кластеры с мощной внутренней перелинковкой. Основная статья должна ссылаться на все дочерние, а дочерние – друг на друга и на родителя."),
                        TextBody(
                            text:
                                "• Расширенный E-E-A-T: Пишите конкретные факты и излучайте экспертизу. Например, вместо 'Мы достигли результата много где' пишите 'За 2024 год мы добились результата по SEO на 90% сайтов в работе'."),
                        TextBody(
                            text:
                                "• Добавочная ценность: Предлагает ли ваш контент уникальные данные, оригинальные исследования, опросы, глубокий личный опыт? Искусственный интеллект ищет первоисточники."),
                        TextBody(
                            text:
                                "• Мультимодальность: Обогащайте текст таблицами, инфографикой, схемами, уникальными фото и видео. Мультимодальный контент лучше верифицируется и ценится ИИ."),
                        TextBody(
                            text:
                                "• Соответствие формату SERP: Создавайте контент в том формате (видео, текст), который доминирует в выдаче Google по целевым запросам."),
                      ],
                    ),
                  ),
                  Text(
                      "5. Анализ силы бренда и внешней репутации (Этап 5 Чек-листа):",
                      style: boldStyle),
                  const ImageWrapper(
                      image:
                          "assets/images/seo-ai-era/ahrefs_ai_overview_study.webp"),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBody(
                            text:
                                "• Упоминания бренда в интернете (unlinked brand mentions): Это наиболее сильный фактор корреляции с появлением бренда в AI-обзорах (0.664). Используйте Ahrefs Content Explorer для поиска таких упоминаний. Ключевой вывод: нужно размещаться (даже без ссылок) там, где AI ищут информацию для формирования ответа. Думайте о Reddit, Quora, Яндекс Кью и профильных форумах – там, где вас рекомендуют в тематических ветках."),
                        TextBody(
                            text:
                                "• Knowledge Panel и Google Business Profile/Яндекс Бизнес: Проверьте полноту и рейтинг этих профилей. Это критично для локальных сигналов и доверия."),
                        TextBody(
                            text:
                                "• URL домена акцептора = название бренда или схоже с названием бренда (имени проекта)."),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- Заключение ---
            const TextHeadlineSecondary(
                text: "Заключение: комплексный подход – ключ к успеху"),
            const TextBlockquote(
                text:
                    "Новая эра SEO требует от нас гибкости и глубокого понимания не только алгоритмов, но и того, как AI обрабатывает информацию и как пользователи взаимодействуют с поиском."),
            const TextBody(
                text: "Ключ к успеху лежит в комплексном подходе, сочетающем:"),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextBody(
                      text:
                          "• Техническую оптимизацию (доступность для AI-краулеров, семантическая верстка)."),
                  TextBody(
                      text:
                          "• Глубокое понимание пользователя и создание человеко-ориентированного контента."),
                  TextBody(
                      text:
                          "• Стратегическое развитие бренда и сущности (Entity SEO) через прозрачность, структурированные данные и активное наращивание упоминаний бренда, даже без ссылок."),
                  TextBody(
                      text:
                          "• Адаптацию к Zero-Click реальности путем оптимизации для SERP-функций и развития собственных каналов."),
                  TextBody(
                      text:
                          "• Активное и умное использование AI-инструментов для автоматизации рутины, генерации идей, создания контента, и, что неочевидно, для отладки того, как AI понимает ваш сайт."),
                ],
              ),
            ),
            const TextBody(
                text:
                    "SEO перестает быть только про 'ключевые слова и ссылки'. Это непрерывный цикл внедрения, измерения и адаптации, требующий инженерного подхода и постоянного развития. Осваивайте promt-инжиниринг, экспериментируйте с AI-агентами, и пусть ваш интеллект поможет вам в работе с интеллектом искусственным."),
            const TextBody(text: "Спасибо, что дочитали)"),
            const SizedBox(height: 40),
            // Теги
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
                  BreadcrumbItem(text: "SEO в эпоху ИИ"), // Текущая страница
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
