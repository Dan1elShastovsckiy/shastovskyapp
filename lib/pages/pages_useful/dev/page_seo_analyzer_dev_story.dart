// lib/pages/pages_useful/dev/page_seo_analyzer_dev_story.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minimal/components/related_articles.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/components/share_buttons_block.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart'
    hide MaxWidthBox;
import 'package:minimal/utils/meta_tag_service.dart';
import 'package:minimal/components/feature_tile.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class PostSeoAnalyzerDevStory extends StatefulWidget {
  static const String name = 'useful/dev/seo-analyzer-story';

  const PostSeoAnalyzerDevStory({super.key});

  @override
  State<PostSeoAnalyzerDevStory> createState() =>
      _PostSeoAnalyzerDevStoryState();
}

class _PostSeoAnalyzerDevStoryState extends State<PostSeoAnalyzerDevStory> {
  // Список изображений для предзагрузки
  final List<String> _pageImages = [
    "assets/images/dev/seo_analyzer_story/v1_prototype.webp",
    "assets/images/dev/seo_analyzer_story/stemming_diagram.webp",
    "assets/images/dev/seo_analyzer_story/tz_parser_flowchart.webp",
    "assets/images/dev/seo_analyzer_story/ui_thread_jam.webp",
    "assets/images/dev/seo_analyzer_story/ui_thread_isolate.webp",
    "assets/images/dev/seo_analyzer_story/recognize_before_after.webp",
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
          "Под капотом SEO-анализатора: история разработки | Блог Даниила Шастовского",
      description:
          "Путь от идеи и простого прототипа до асинхронного Flutter-приложения с парсером, стеммингом и отзывчивым UI. Глубокое погружение в решение реальных проблем.",
      imageUrl:
          "https://shastovsky.ru/assets/assets/images/dev/seo_analyzer_story/ui_thread_isolate.webp",
    );
  }

  // Вспомогательная функция для показа всплывающих окон
  void _showInfoDialog(BuildContext context,
      {required String title, required String markdownContent}) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(title, style: headlineSecondaryTextStyle(context)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MarkdownBody(
                  data: markdownContent,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                    p: bodyTextStyle(context),
                    listBullet: bodyTextStyle(context),
                    code: bodyTextStyle(context).copyWith(
                      fontFamily: 'monospace',
                      backgroundColor:
                          theme.colorScheme.onSurface.withOpacity(0.1),
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
                BreadcrumbItem(text: "Разработка", routeName: '/useful/dev'),
                BreadcrumbItem(text: "История SEO-анализатора"),
              ]),
            ),
            const SizedBox(height: 40),
            Text("Под капотом SEO-анализатора: история разработки",
                style: headlineTextStyle(context), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Text(
              "Время чтения: ~20 минут",
              style: subtitleTextStyle(context)
                  .copyWith(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              "Любой полезный инструмент начинается с боли. Эта статья — честная история о том, как боль от рутинной SEO-проверки текстов превратилась в полноценное Flutter-приложение. Мы пройдем весь путь: от наивного прототипа и фидбэка коллег до борьбы с зависанием UI и неожиданных открытий о работе буфера обмена.",
              style: subtitleTextStyle(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            const TextHeadlineSecondary(
                text: "Глава 1: Прототип v0.1 — Боль, страдания и Ctrl+F"),
            MarkdownBody(
              data:
                  "Все началось с простой задачи: проверить, соответствует ли текст копирайтера техническому заданию (ТЗ). Каждый раз это был один и тот же ритуал:\n\n"
                  "1.  Скопировать текст в один сервис для подсчета символов.\n"
                  "2.  Вручную (`Ctrl+F`) искать каждое ключевое слово, считая вхождения.\n"
                  "3.  Пытаться понять, все ли темы из структуры ТЗ раскрыты в подзаголовках.\n\n"
                  "Это было долго, нудно и чревато ошибками. Так родилась идея: создать инструмент, который бы делал все это автоматически.",
              selectable: true,
              styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                  p: bodyTextStyle(context),
                  listBullet: bodyTextStyle(context)),
            ),
            Column(
              children: [
                const ImageWrapper(
                    image:
                        "assets/images/dev/seo_analyzer_story/v1_prototype.webp"),
                const SizedBox(height: 8),
                Text(
                  "Визуализация первого прототипа: два простых поля и кнопка.",
                  style: subtitleTextStyle(context)
                      .copyWith(fontStyle: FontStyle.italic, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const TextHeadlineSecondary(
                text: "Глава 2: Первый фидбэк и первые проблемы"),
            MarkdownBody(
              data:
                  "Первая версия была собрана «на коленке»: два поля `TextField`, кнопка «Проверить» и простейшая логика `text.contains(keyword)`. Проблемы обнаружились сразу, как только я показал инструмент коллегам:\n\n"
                  "• **«Он не находит ключи, которые точно есть!»** — `String.contains()` не понимал падежей. «Купить машин**у**» и «купить машин**а**» для него были разными фразами.\n"
                  "• **«В ТЗ куча всего, а ты проверяешь только ключи»** — парсер ТЗ был слишком примитивен и не умел извлекать структуру, LSI-слова, мета-теги.\n"
                  "• **«В объем текста попадает всё подряд»** — алгоритм не мог правильно «отрезать» конец секции и забирал в «Объем» половину ТЗ.\n\n"
                  "Стало ясно, что наивный подход провалился. Нужна была настоящая «математика».",
              selectable: true,
              styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                  p: bodyTextStyle(context),
                  listBullet: bodyTextStyle(context),
                  code: bodyTextStyle(context).copyWith(
                      fontFamily: 'monospace',
                      backgroundColor:
                          theme.colorScheme.onSurface.withOpacity(0.1))),
            ),
            const TextHeadlineSecondary(
                text: "Глава 3: Эволюция — от строк к семантике"),
            const FeatureTile(
              icon: Icons.science_outlined,
              title: "Алгоритмы вместо Contains()",
              content:
                  "Простой поиск был заменен на более надежный, вдохновленный классическими алгоритмами вроде **Бойера-Мура**. Вместо сложных регулярных выражений, которые плохо работали с кириллицей, был написан посимвольный поиск. Для «разбавленных» вхождений (когда слова ключа разбросаны по предложению), фраза стала очищаться от стоп-слов (союзов, предлогов), и алгоритм искал только «значимые» части.",
            ),
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  const TextSpan(
                      text:
                          "Главным прорывом стала борьба с морфологией. Проблема «Е»/«Ё» была решена простой заменой `text.replaceAll('ё', 'е')`, но для падежей и склонений этого было мало. На помощь пришел "),
                  TextSpan(
                    text: "алгоритм стемминга",
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _showInfoDialog(context,
                          title: "Что такое стемминг?",
                          markdownContent:
                              "**Стемминг** — это процесс нахождения основы слова путем отсечения окончаний и суффиксов. Например, слова «работа», «работал», «работающий» после стемминга превратятся в одну и ту же основу «работ».\n\nЭто грубый, но очень быстрый и эффективный метод для задач информационного поиска. В проекте используется библиотека `snowball_stemmer`, реализующая алгоритм Портера для русского языка."),
                  ),
                  const TextSpan(
                      text:
                          ". Теперь перед анализом и текст, и ключи проходили «очистку», превращаясь в набор основ слов."),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                const ImageWrapper(
                    image:
                        "assets/images/dev/seo_analyzer_story/stemming_diagram.webp"),
                const SizedBox(height: 8),
                Text(
                  "Принцип работы стемминга: разные словоформы приводятся к единой основе.",
                  style: subtitleTextStyle(context)
                      .copyWith(fontStyle: FontStyle.italic, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const FeatureTile(
              icon: Icons.splitscreen_outlined,
              title: "Парсер ТЗ 2.0",
              content:
                  "Парсер был полностью переписан. Вместо простого поиска маркера он научился работать со списком всех возможных заголовков («Объем», «Title», «Ключи», «LSI» и их вариации). Теперь алгоритм искал стартовый маркер, начинал собирать строки и останавливался, как только встречал **следующий известный маркер** или **несколько пустых строк подряд**. Это позволило аккуратно «вырезать» нужные секции, решив проблему с «жадным» парсингом.",
            ),
            Column(
              children: [
                const ImageWrapper(
                    image:
                        "assets/images/dev/seo_analyzer_story/tz_parser_flowchart.webp"),
                const SizedBox(height: 8),
                Text(
                  "Упрощенная схема алгоритма парсинга технического задания.",
                  style: subtitleTextStyle(context)
                      .copyWith(fontStyle: FontStyle.italic, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const TextHeadlineSecondary(
                text: "Глава 4: Фидбэк Лены и рождение v1.0"),
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  const TextSpan(
                      text:
                          "После всех улучшений инструмент стал гораздо умнее. Настало время для серьезного тест-драйва. Я отдал его на проверку коллеге Лене Мельниковой ("),
                  TextSpan(
                    text: "@oh_laalaa",
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap =
                          () => launchUrl(Uri.parse('https://t.me/oh_laalaa')),
                  ),
                  const TextSpan(
                      text:
                          "). Ее (офигеть какой подробный и 'докапывающийся' в хорошем смысле) фидбэк стал катализатором для превращения прототипа в настоящий рабочий инструмент."),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const FeatureTile(
              icon: Icons.edit_note,
              title: "Проблема №1: «Текст — это не просто буквы!»",
              content:
                  "Лена справедливо заметила, что SEO-текст — это структура, а простой `TextField` не позволяет ни вставить, ни разметить заголовки и списки. Это делало невозможным анализ структуры.\n\n"
                  "**Решение:** Интеграция `flutter_quill`. Этот Rich Text редактор, хранящий документ в формате **Delta**, стал сердцем новой версии. Теперь инструмент мог не только «видеть», но и анализировать заголовки, списки и другое форматирование.",
            ),
            const FeatureTile(
              icon: Icons.spellcheck,
              title: "Проблема №2: «А где проверка орфографии?»",
              content:
                  "Логичное замечание. Текст без ошибок — базовое требование.\n\n"
                  "**Решение:** Интеграция с API **Яндекс.Спеллера**. Теперь после анализа текста отдельный асинхронный запрос отправлялся на серверы Яндекса, и инструмент начал подсвечивать орфографические ошибки с вариантами замены.",
            ),
            const FeatureTile(
              icon: Icons.calculate_outlined,
              title: "Проблема №3: «Считает не так, как Миратекст!»",
              content:
                  "Финальным испытанием стала сверка с «золотым стандартом» — популярным сервисом анализа. Оказалось, что мой алгоритм подсчета вхождений давал расхождения.\n\n"
                  "**Решение:** Глубокое погружение в математику. Алгоритм был допилен, чтобы учитывать «занятые» диапазоны (если длинный ключ «купить синий автомобиль» найден, короткий ключ «автомобиль» внутри него уже не считается). Были добавлены разные режимы анализа (с пересечениями и без), что позволило добиться результатов 1-в-1 с референсом.",
            ),
            const TextHeadlineSecondary(
                text:
                    "Глава 5: Главный враг — зависание интерфейса (UI Freeze)"),
            MarkdownBody(
              data:
                  "Когда вся сложная логика была готова, проявился самый страшный враг производительности. При нажатии на кнопку «Запустить анализ» приложение замирало на 5-10 секунд. Индикатор загрузки появлялся и тут же «замерзал».\n\n"
                  "Причина — **блокировка UI-потока**. Вся тяжелая математика по стеммингу, поиску и подсчету слов выполнялась в том же потоке, что и анимация крутилки.",
              selectable: true,
              styleSheet: MarkdownStyleSheet.fromTheme(theme)
                  .copyWith(p: bodyTextStyle(context)),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                const ImageWrapper(
                    image:
                        "assets/images/dev/seo_analyzer_story/ui_thread_jam.webp"),
                const SizedBox(height: 8),
                Text(
                  "До: UI-поток пытается делать все сразу и создает 'пробку'.",
                  style: subtitleTextStyle(context)
                      .copyWith(fontStyle: FontStyle.italic, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            MarkdownBody(
              data: "**Решение: Изоляты и `compute()`**\n\n"
                  "Во Flutter для выполнения тяжелой работы в фоновом потоке используются **Изоляты**. Это как нанять отдельного работника в другой комнате. Вся логика анализа была вынесена в отдельную глобальную функцию и запущена через `compute()`, что освободило основной поток и сделало анимацию плавной.",
              selectable: true,
              styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                  p: bodyTextStyle(context),
                  code: bodyTextStyle(context).copyWith(
                      fontFamily: 'monospace',
                      backgroundColor:
                          theme.colorScheme.onSurface.withOpacity(0.1))),
            ),
            Column(
              children: [
                const ImageWrapper(
                    image:
                        "assets/images/dev/seo_analyzer_story/ui_thread_isolate.webp"),
                const SizedBox(height: 8),
                Text(
                  "После: работа вынесена в отдельный поток (Изолят), UI остается отзывчивым.",
                  style: subtitleTextStyle(context)
                      .copyWith(fontStyle: FontStyle.italic, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const TextBlockquote(
                text:
                    "Но даже после этого лоадер «дергался». Финальным штрихом стало добавление `Future.delayed` перед запуском тяжелых операций, чтобы гарантировать, что анимация успеет начаться. Мелочь, которая кардинально меняет ощущение от работы с инструментом."),
            const TextHeadlineSecondary(
                text: "Глава 6: Битва за UX и фиаско с RTF"),
            MarkdownBody(
              data:
                  "Последней нерешенной задачей оставалась вставка из Google Docs. Фидбэк был однозначным: «Неудобно вставлять голый текст и форматировать вручную». Начались поиски решения, которые превратились в настоящий детектив:\n\n"
                  "1.  **Гипотеза №1: HTML.** Провалилась. HTML от Google оказался слишком «грязным».\n"
                  "2.  **Гипотеза №2: RTF.** Провалилась. Готовых парсеров RTF для Dart/Flutter не нашлось.\n"
                  "3.  **Открытие:** Отладка показала, что в моем тестовом окружении Google Docs вообще **не кладет в буфер обмена ничего, кроме простого текста!**",
              selectable: true,
              styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                  p: bodyTextStyle(context),
                  listBullet: bodyTextStyle(context)),
            ),
            const FeatureTile(
              icon: Icons.auto_fix_high,
              title: "Элегантный поворот: функция «Распознать структуру»",
              content:
                  "Раз мы не можем получить структуру *при* вставке, давайте получим ее *после*! Так родилась идея кнопки «🪄 Распознать структуру».\n\n"
                  "Она запускает простой, но эффективный эвристический алгоритм, который пробегается по уже вставленному простому тексту и применяет форматирование по правилам:\n\n"
                  "• Если строка короткая и не заканчивается точкой — это, скорее всего, **заголовок**.\n"
                  "• Если строка начинается с `•` или `*` — это точно **пункт списка**.\n\n"
                  "Это решило проблему на 90%, предоставив пользователю быстрый способ получить структурированный текст для анализа без необходимости ручной разметки.",
            ),
            Column(
              children: [
                const ImageWrapper(
                    image:
                        "assets/images/dev/seo_analyzer_story/recognize_before_after.webp"),
                const SizedBox(height: 8),
                Text(
                  "Результат работы функции 'Распознать структуру': из простого текста в отформатированный документ.",
                  style: subtitleTextStyle(context)
                      .copyWith(fontStyle: FontStyle.italic, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const TextHeadlineSecondary(
                text:
                    "Заключение: итерации, компромиссы и фокус на пользователе"),
            const TextBody(
              text:
                  "Путь создания этого инструмента — классический пример итеративной разработки. От неработающего прототипа и критики коллег, через решение фундаментальных проблем производительности, до столкновения с ограничениями внешнего мира и поиска элегантных обходных путей.\n\n"
                  "Ключевой вывод: идеального решения не существует. Но можно, шаг за шагом, приближаться к нему, постоянно держа в фокусе главную цель — решить «боль» пользователя максимально простым и эффективным способом.",
            ),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: TagWrapper(tags: [
                Tag(tag: "Flutter"),
                Tag(tag: "Dart"),
                Tag(tag: "Разработка"),
                Tag(tag: "Производительность"),
                Tag(tag: "UI/UX"),
              ]),
            ),
            const SizedBox(height: 20),
            const ShareButtonsBlock(), // <<< ДОБАВЛЕН ВИДЖЕТ ДЛЯ КНОПОК ПОДЕЛИТЬСЯ >>>
            const SizedBox(height: 40),
            const RelatedArticles(
              currentArticleRouteName: PostSeoAnalyzerDevStory.name,
              category: 'dev',
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
              child: Breadcrumbs(items: [
                BreadcrumbItem(text: "Главная", routeName: '/'),
                BreadcrumbItem(text: "Полезное", routeName: '/useful'),
                BreadcrumbItem(text: "Разработка", routeName: '/useful/dev'),
                BreadcrumbItem(text: "История SEO-анализатора"),
              ]),
            ),
            ...authorSection(
              context: context,
              imageUrl: "assets/images/avatar_default.png",
              name: "Автор: Шастовский Даниил",
              bio:
                  "Разработчик этого инструмента и автор статьи. Люблю решать сложные задачи и делиться процессом их решения.",
            ),
            divider(context),
            const Footer(),
          ].toMaxWidthSliver(),
        ],
      ),
    );
  }
}
