// lib/pages/pages_useful/dev/page_forecast_dev_story.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minimal/components/comments_section.dart';
import 'package:minimal/components/reactions_widget.dart';
import 'package:minimal/components/related_articles.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/components/share_buttons_block.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart'
    hide MaxWidthBox;
import 'package:minimal/utils/meta_tag_service.dart';
import 'package:minimal/components/feature_tile.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
// <<< ШАГ 1: Добавляем импорт семантических виджетов >>>
import 'package:minimal/components/semantic_widgets.dart';

class PostForecastDevStory extends StatefulWidget {
  static const String name = 'useful/dev/seo-forecast-story';

  const PostForecastDevStory({super.key});

  @override
  State<PostForecastDevStory> createState() => _PostForecastDevStoryState();
}

class _PostForecastDevStoryState extends State<PostForecastDevStory> {
  final List<String> _pageImages = [
    "assets/images/dev/forecast_story/forecast-story-banner.webp",
    "assets/images/dev/forecast_story/traffic-deconstruction.webp",
    "assets/images/dev/forecast_story/firebase-ecosystem.webp",
    "assets/images/dev/forecast_story/google-sign-in-flow.webp",
    "assets/images/dev/forecast_story/firestore-data-model.webp",
    "assets/images/dev/forecast_story/firestore-security-rules.webp",
    "assets/images/avatar_default.webp",
  ];

  // <<< ШАГ 2: Добавляем флаг для определения режима рендеринга >>>
  bool _isPrerendering = false;

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
    // <<< ШАГ 3: Проверяем URL на наличие параметра пререндеринга >>>
    final uri = Uri.base;
    if (uri.queryParameters['prerender'] == 'true') {
      setState(() {
        _isPrerendering = true;
      });
    }

    MetaTagService().updateAllTags(
      title:
          "От калькулятора до SaaS: история создания SEO-прогноза | Блог Даниила Шастовского",
      description:
          "Как простая идея превратилась в full-stack фичу с Firebase, аутентификацией Google и защищенной базой данных. Разбор граблей и решений.",
      imageUrl:
          "https://shastovsky.com/assets/assets/images/dev/forecast_story/forecast-story-banner.webp",
    );
  }

  // <<< ШАГ 4: Новый метод для генерации семантического контента >>>
  Widget _buildPrerenderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SemanticH1("От калькулятора до SaaS: история создания SEO-прогноза"),
        SemanticP(
            "Изначально инструмент прогнозирования был простым калькулятором. Но настоящий потенциал раскрылся, когда появилась задача: дать пользователям возможность сохранять свои отчеты, делиться ими и возвращаться к ним позже. Эта история о том, как локальный инструмент превратился в мини-SaaS с аутентификацией и облачной базой данных."),
        SemanticImg(
            src: "assets/images/dev/forecast_story/forecast-story-banner.webp",
            alt: "Баннер статьи про историю создания SEO-прогноза"),
        SemanticH2("Глава 1: Математическое ядро"),
        SemanticP(
            "В основе любого прогноза лежит декомпозиция. Нельзя просто провести линию через исторические данные. Трафик — это сумма нескольких компонентов:"),
        SemanticImg(
            src: "assets/images/dev/forecast_story/traffic-deconstruction.webp",
            alt: "Декомпозиция трафика на тренд и сезонность"),
        SemanticP(
            "Компонент 1: Тренд. Общее направление роста или падения, очищенное от всех колебаний. Для его построения была выбрана простая, но надежная линейная регрессия — метод, который строит прямую линию, наилучшим образом описывающую набор данных."),
        SemanticP(
            "Компонент 2: Сезонность. Регулярные годовые циклы (например, падение спроса на кондиционеры зимой). Сезонность рассчитывалась классическим методом с усреднением по месяцам."),
        SemanticP(
            "Компонент 3: Брендовый и небрендовый трафик. Трафик по брендовым запросам (например, 'купить озон') ведет себя иначе, чем небрендовый ('купить холодильник'). Модель разделяет их и применяет процент роста от SEO только к небрендовой части прогноза."),
        SemanticH2("Глава 2: Проблема 'Дня сурка'"),
        SemanticP(
            "Инструмент был полезен, но страдал амнезией. Каждый раз, когда пользователь обновлял страницу, все его данные, настройки и результаты исчезали. Задача превратилась из «сделать калькулятор» в «построить приложение с бэкендом»."),
        SemanticH2("Глава 3: Выбор стека — Firebase to the Rescue"),
        SemanticP(
            "Создавать свой бэкенд с нуля для такой задачи — избыточно и долго. Выбор пал на Firebase, который закрывал сразу все потребности: аутентификацию, облачную базу данных и хостинг."),
        SemanticImg(
            src: "assets/images/dev/forecast_story/firebase-ecosystem.webp",
            alt: "Экосистема Firebase"),
        SemanticH2("Глава 4: Аутентификация — грабли веб-версии"),
        SemanticP(
            "Казалось бы, что может быть проще, чем добавить кнопку «Войти через Google»? Но именно здесь начались самые большие трудности, связанные со спецификой Flutter Web."),
        SemanticP(
            "Проблема: Постоянно меняющееся API Google Sign-In. Старые туториалы перестали работать. Новые версии требовали сложной, асинхронной инициализации и работы через потоки событий, особенно для веба."),
        SemanticImg(
            src: "assets/images/dev/forecast_story/google-sign-in-flow.webp",
            alt: "Схема аутентификации через Google Sign-In"),
        SemanticP(
            "Решение: Создание гибридной системы. В main.dart была добавлена ранняя инициализация GoogleSignIn.instance.initialize(). В AuthService была встроена логика, которая слушает authenticationEvents. Для веба используется специальный виджет google_sign_in_web.renderButton(), а для мобильных — кастомная кнопка."),
        SemanticH2("Глава 5: Хранение и шаринг отчетов"),
        SemanticP(
            "Когда аутентификация была решена, оставалось «просто» сохранять данные."),
        SemanticP(
            "Firestore: структура и запись. Для хранения отчетов была создана коллекция forecast_reports. Каждый документ в ней — это объект ForecastReport. В качестве ID документа используется уникальный UUID."),
        SemanticImg(
            src: "assets/images/dev/forecast_story/firestore-data-model.webp",
            alt: "Модель данных в Firestore"),
        SemanticP(
            "Ключевым моментом стала возможность поделиться отчетом. Но как сделать его публичным, но защищенным от редактирования? Решение: Правила безопасности Firestore. Было написано правило, которое разрешает чтение одного документа любому, но запись - только владельцу этого документа."),
        SemanticImg(
            src:
                "assets/images/dev/forecast_story/firestore-security-rules.webp",
            alt: "Правила безопасности Firestore"),
        SemanticH2("Заключение: От идеи до работающего сервиса"),
        SemanticP(
            "Этот путь наглядно показывает, как простая утилита может эволюционировать в полноценный сервис. Главными уроками стали: не бояться бэкенда (BaaS-платформы помогают); платформенные различия — это реальность; безопасность — не опция. В итоге, инструмент прогнозирования стал не просто калькулятором, а полезным рабочим инструментом с памятью и возможностью совместной работы."),
      ],
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
    // <<< ШАГ 5: Добавляем условную логику в метод build >>>
    if (_isPrerendering) {
      return Material(
          child: SingleChildScrollView(child: _buildPrerenderContent()));
    }

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
                BreadcrumbItem(text: "История SEO-прогноза"),
              ]),
            ),
            const SizedBox(height: 40),
            // <<< НОВЫЙ БЛОК ЗАГОЛОВКА >>>
            Center(
              child: Text(
                DateFormat.yMMMMd('ru_RU')
                    .format(DateTime(2025, 10, 22)), // Укажите вашу дату
                style: bodyTextStyle(context).copyWith(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text("От калькулятора до SaaS: история создания SEO-прогноза",
                style: headlineTextStyle(context), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  "~15 минут чтения", // Укажите ваше время
                  style: subtitleTextStyle(context)
                      .copyWith(fontStyle: FontStyle.italic, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Изначально инструмент прогнозирования был простым калькулятором. Но настоящий потенциал раскрылся, когда появилась задача: дать пользователям возможность сохранять свои отчеты, делиться ими и возвращаться к ним позже. Эта история о том, как локальный инструмент превратился в мини-SaaS с аутентификацией и облачной базой данных.",
              style: subtitleTextStyle(context),
              textAlign: TextAlign.center,
            ),
            const ImageWrapper(
                image:
                    "assets/images/dev/forecast_story/forecast-story-banner.webp"),

            const TextHeadlineSecondary(text: "Глава 1: Математическое ядро"),
            const TextBody(
                text:
                    "В основе любого прогноза лежит декомпозиция. Нельзя просто провести линию через исторические данные. Трафик — это сумма нескольких компонентов:"),
            const ImageWrapper(
                image:
                    "assets/images/dev/forecast_story/traffic-deconstruction.webp"),
            const SizedBox(height: 16),
            const FeatureTile(
              icon: Icons.timeline,
              title: "Компонент 1: Тренд",
              content:
                  "Общее направление роста или падения, очищенное от всех колебаний. Для его построения была выбрана простая, но надежная **линейная регрессия** — метод, который строит прямую линию, наилучшим образом описывающую набор данных.\n\n"
                  "**Формула:** `y = mx + b`\n\n"
                  "• `y` — прогнозируемое значение трафика.\n\n"
                  "• `m` — наклон линии (скорость роста).\n\n"
                  "• `x` — период времени (номер месяца).\n\n"
                  "• `b` — точка пересечения с осью Y (начальное значение).\n\n"
                  "Этот метод отлично подходит для сайтов со стабильным, предсказуемым ростом.",
            ),
            const FeatureTile(
              icon: Icons.wb_sunny_outlined,
              title: "Компонент 2: Сезонность",
              content:
                  "Регулярные годовые циклы (например, падение спроса на кондиционеры зимой). Сезонность рассчитывалась классическим методом с усреднением по месяцам.\n\n"
                  "**Формула коэффициента:** `Коэф. месяца = Факт. трафик / Значение тренда`\n\n"
                  "Сначала для каждого исторического месяца (например, для всех январей) вычисляется этот коэффициент. Затем все коэффициенты для одного и того же месяца (всех январей, всех февралей и т.д.) усредняются. \n\n В итоге мы получаем 12 коэффициентов — по одному на каждый месяц года, которые показывают, насколько трафик в этом месяце в среднем выше или ниже тренда.",
            ),
            const FeatureTile(
              icon: Icons.people_outline,
              title: "Компонент 3: Брендовый и небрендовый трафик",
              content:
                  "Трафик по брендовым запросам (например, 'купить озон') ведет себя иначе, чем небрендовый ('купить холодильник').\n\n Брендовый трафик более стабилен и меньше зависит от SEO. Поэтому модель разделяет их: прогнозирует брендовый трафик отдельно (часто как среднее значение) и применяет процент роста от SEO только к небрендовой части прогноза.",
            ),

            // <<< ИЗМЕНЕНИЕ: Добавлен отступ >>>
            const SizedBox(height: 40),
            const TextHeadlineSecondary(text: "Глава 2: Проблема 'Дня сурка'"),
            const TextBody(
              text:
                  "Инструмент был полезен, но страдал амнезией. Каждый раз, когда пользователь обновлял страницу, все его данные, настройки и результаты исчезали. Чтобы решить эту проблему, требовалась система, которая могла бы:\n\n"
                  "• Идентифицировать пользователя.\n\n"
                  "• Хранить его данные где-то на сервере.\n\n"
                  "• Загружать их при повторном визите.",
            ),
            const TextBlockquote(
                text:
                    "Задача превратилась из «сделать калькулятор» в «построить приложение с бэкендом»."),

            const SizedBox(height: 40),
            const TextHeadlineSecondary(
                text: "Глава 3: Выбор стека — Firebase to the Rescue"),
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  const TextSpan(
                      text:
                          "Создавать свой бэкенд с нуля для такой задачи — избыточно и долго. Выбор пал на "),
                  TextSpan(
                    text: "Firebase",
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _showInfoDialog(context,
                          title: "Что такое Firebase?",
                          markdownContent:
                              "**Firebase** — это платформа от Google (Backend-as-a-Service), которая предоставляет готовые решения для распространенных задач:\n\n"
                              "• **Authentication:** Готовая система входа/регистрации.\n\n"
                              "• **Firestore:** NoSQL база данных в облаке.\n\n"
                              "• **Hosting:** Простой хостинг для веб-приложений.\n\n"
                              "Использование Firebase позволило не писать серверный код, а сосредоточиться на логике самого приложения."),
                  ),
                  const TextSpan(
                      text: ", который закрывал сразу все потребности."),
                ],
              ),
            ),
            const ImageWrapper(
                image:
                    "assets/images/dev/forecast_story/firebase-ecosystem.webp"),

            const SizedBox(height: 40),
            const TextHeadlineSecondary(
                text: "Глава 4: Аутентификация — грабли веб-версии"),
            const TextBody(
                text:
                    "Казалось бы, что может быть проще, чем добавить кнопку «Войти через Google»? Но именно здесь начались самые большие трудности, связанные со спецификой Flutter Web."),
            const FeatureTile(
              icon: Icons.error_outline,
              title: "Проблема: Постоянно меняющееся API Google Sign-In",
              content:
                  "Пакет `google_sign_in` пережил несколько серьезных изменений. Старые туториалы, предлагавшие вызывать `GoogleSignIn().signIn()`, перестали работать. \n\nНовые версии требовали сложной, асинхронной инициализации и работы через потоки событий (`authenticationEvents`). Особенно для веба, где процесс входа инициируется не вызовом Dart-метода, а кликом по специальной HTML-кнопке, которую рендерит сам Google.",
            ),
            const ImageWrapper(
                image:
                    "assets/images/dev/forecast_story/google-sign-in-flow.webp"),
            const SizedBox(height: 16),
            // <<< ИЗМЕНЕНИЕ: Используем RichText для выделения жирным >>>
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  TextSpan(
                      text: "Решение:",
                      style: bodyTextStyle(context)
                          .copyWith(fontWeight: FontWeight.bold)),
                  const TextSpan(text: " Создание гибридной системы.\n\n1. "),
                  TextSpan(
                      text: "В `main.dart`",
                      style: bodyTextStyle(context)
                          .copyWith(fontWeight: FontWeight.bold)),
                  const TextSpan(
                      text:
                          " была добавлена ранняя инициализация `await GoogleSignIn.instance.initialize();`.\n2. "),
                  TextSpan(
                      text: "В `AuthService`",
                      style: bodyTextStyle(context)
                          .copyWith(fontWeight: FontWeight.bold)),
                  const TextSpan(
                      text:
                          " была встроена логика, которая слушает `authenticationEvents`. Когда событие входа от Google приходит, сервис автоматически получает токен и передает его в Firebase Auth.\n3. "),
                  TextSpan(
                      text: "Для веба",
                      style: bodyTextStyle(context)
                          .copyWith(fontWeight: FontWeight.bold)),
                  const TextSpan(
                      text:
                          " используется специальный виджет `google_sign_in_web.renderButton()`, а для мобильных — кастомная кнопка. В итоге, несмотря на разницу платформ, конечный результат один — пользователь входит в Firebase."),
                ],
              ),
            ),

            const SizedBox(height: 40),
            const TextHeadlineSecondary(
                text: "Глава 5: Хранение и шаринг отчетов"),
            const TextBody(
                text:
                    "Когда аутентификация была решена, оставалось «просто» сохранять данные."),
            const FeatureTile(
              icon: Icons.cloud_upload_outlined,
              title: "Firestore: структура и запись",
              content:
                  "Для хранения отчетов была создана коллекция `forecast_reports`. Каждый документ в ней — это объект `ForecastReport`, содержащий все входные данные (история, настройки) и результаты.\n\n В качестве ID документа используется уникальный UUID, что позволяет создавать множество отчетов.",
            ),
            const ImageWrapper(
                image:
                    "assets/images/dev/forecast_story/firestore-data-model.webp"),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                style: bodyTextStyle(context),
                children: [
                  const TextSpan(
                      text:
                          "Ключевым моментом стала возможность поделиться отчетом. Для этого была изменена логика URL: теперь после сохранения отчет доступен по уникальной ссылке вида `.../seo-forecast/<report_id>`.\n\n Но как сделать его публичным, но защищенным от редактирования?\n\n"),
                  TextSpan(
                      text: "Решение:",
                      style: bodyTextStyle(context)
                          .copyWith(fontWeight: FontWeight.bold)),
                  const TextSpan(text: " "),
                  TextSpan(
                    text: "Правила безопасности Firestore.",
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _showInfoDialog(context,
                          title: "Firestore Security Rules",
                          markdownContent:
                              "Это набор правил на стороне сервера, которые определяют, кто и как может читать и изменять данные. Для отчетов было написано правило:\n\n```\nmatch /forecast_reports/{reportId} {\n  // Любой может прочитать ОДИН документ\n  allow get: if true;\n\n  // Изменять может только владелец\n  allow write: if request.auth != null && \n    request.auth.uid == resource.data.userId;\n}\n```\n\nЭто позволило сделать отчеты публичными для просмотра по прямой ссылке, но защитить их от изменений посторонними."),
                  ),
                ],
              ),
            ),
            const ImageWrapper(
                image:
                    "assets/images/dev/forecast_story/firestore-security-rules.webp"),

            const SizedBox(height: 40),
            const TextHeadlineSecondary(
                text: "Заключение: От идеи до работающего сервиса"),
            MarkdownBody(
              data:
                  "Этот путь наглядно показывает, как простая утилита может эволюционировать в полноценный сервис. Главными уроками стали:\n\n"
                  "• **Не бояться бэкенда:** Современные BaaS-платформы, как Firebase, позволяют фронтам создавать сложные приложения без написания серверного кода.\n\n"
                  "• **Платформенные различия — это реальность:** Особенно в Flutter Web. То, что работает на мобильных, может потребовать совершенно иного подхода в браузере.\n\n"
                  "• **Безопасность — не опция:** Правила Firestore — это мощный инструмент, который нужно настраивать с самого начала.\n\n"
                  "В итоге, благодаря этой итерации, инструмент прогнозирования стал не просто калькулятором, а полезным рабочим инструментом с памятью и возможностью совместной работы.",
              selectable: true,
              styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                  p: bodyTextStyle(context),
                  listBullet: bodyTextStyle(context)),
            ),
            // <<< НАЧАЛО СТАНДАРТНОГО ФУТЕРА ИЗ ЗАПРОСА >>>
            const SizedBox(height: 40),
            // <<< НОВЫЙ БЛОК: Реакции >>>
            const Align(
              alignment: Alignment.center,
              child: Text("Как вам статья?", style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 16),
            const Center(
              child: ReactionsWidget(
                articleRouteName: PostForecastDevStory.name,
              ),
            ),
            const SizedBox(height: 60),
            divider(context),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: TagWrapper(tags: [
                Tag(tag: "Flutter"),
                Tag(tag: "Firebase"),
                Tag(tag: "Аутентификация"),
                Tag(tag: "Firestore"),
              ]),
            ),
            const SizedBox(height: 20),
            const ShareButtonsBlock(),
            const SizedBox(height: 40),
            // <<< НОВЫЙ БЛОК: Комментарии >>>
            const CommentsSection(
              articleRouteName: PostForecastDevStory.name,
            ),
            const SizedBox(height: 60),
            const RelatedArticles(
              currentArticleRouteName: PostForecastDevStory.name,
              category: 'dev',
            ),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(
                    bottom: 40.0), // Используем константу или прямое значение
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
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Breadcrumbs(
                items: [
                  BreadcrumbItem(text: "Главная", routeName: '/'),
                  BreadcrumbItem(text: "Полезное", routeName: '/useful'),
                  BreadcrumbItem(text: "Разработка", routeName: '/useful/dev'),
                  BreadcrumbItem(text: "История SEO-прогноза"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ...authorSection(
              context: context,
              imageUrl: "assets/images/avatar_default.webp",
              name: "Автор: Шастовский Даниил",
              bio:
                  "Разработчик этого инструмента и автор статьи. Люблю решать сложные задачи и делиться процессом их решения.",
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
