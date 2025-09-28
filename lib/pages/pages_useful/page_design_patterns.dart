import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/components/pattern_card.dart';
import 'package:minimal/data/design_patterns_data.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:minimal/utils/meta_tag_service.dart';
import 'package:responsive_framework/responsive_framework.dart'
    hide MaxWidthBox;
import 'package:url_launcher/url_launcher.dart';
import 'package:minimal/pages/pages.dart';

class DesignPatternsPage extends StatefulWidget {
  static const String name = 'useful/dev/design-patterns';
  const DesignPatternsPage({super.key});

  @override
  State<DesignPatternsPage> createState() => _DesignPatternsPageState();
}

class _DesignPatternsPageState extends State<DesignPatternsPage> {
  @override
  void initState() {
    super.initState();
    MetaTagService().updateAllTags(
      title: "Паттерны проектирования на Dart | Блог Даниила Шастовского",
      description:
          "Интерактивная галерея паттернов проектирования с примерами на Dart. Тапни на паттерн, чтобы увидеть код и объяснение.",
      imageUrl: "https://shastovsky.ru/assets/assets/images/dev_article_3.webp",
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),
      drawer: isMobile ? buildAppDrawer(context) : null,
      body: CustomScrollView(
        slivers: [
          // <<< ИСПОЛЬЗУЕМ ИСПРАВЛЕННОЕ РАСШИРЕНИЕ ДЛЯ ВЕРХНЕЙ ЧАСТИ >>>
          ...[
            const SizedBox(height: 24),
            const Breadcrumbs(items: [
              BreadcrumbItem(text: "Главная", routeName: '/'),
              BreadcrumbItem(text: "Полезное", routeName: '/useful'),
              BreadcrumbItem(text: "Разработка", routeName: '/useful/dev'),
              BreadcrumbItem(text: "Паттерны"),
            ]),
            const SizedBox(height: 24),
            Text("Интерактивные паттерны проектирования",
                style: headlineTextStyle(context), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Text(
              "Паттерны — это не готовые классы или библиотеки, а проверенные временем решения типичных проблем в проектировании программ. Это как рецепты для кода. Нажмите на любой паттерн (В любом месте прям можно:) ), чтобы увидеть его 'рецепт' и объяснение.",
              style: subtitleTextStyle(context),
              textAlign: TextAlign.center,
            ),
          ].toMaxWidthSliver(),

          // <<< СЕТКА С КАРТОЧКАМИ ТЕПЕРЬ ТОЖЕ ВНУТРИ РАСШИРЕНИЯ >>>
          SliverToBoxAdapter(
            child: MaxWidthBox(
              maxWidth: 1200,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 24.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 600,
                    mainAxisExtent: 120,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                  ),
                  itemCount: designPatterns.length,
                  itemBuilder: (context, index) {
                    return PatternCard(pattern: designPatterns[index]);
                  },
                ),
              ),
            ),
          ),

          // <<< ИСПОЛЬЗУЕМ ИСПРАВЛЕННОЕ РАСШИРЕНИЕ ДЛЯ НИЖНЕЙ ЧАСТИ >>>
          ...[
            const SizedBox(height: 24),
            Text("Особенности ООП в Dart", style: headlineTextStyle(context)),
            const SizedBox(height: 16),
            Text(
              "Хотя Dart является классическим ООП-языком, похожим на C#, Java или Kotlin, он обладает рядом уникальных особенностей, которые влияют на реализацию паттернов. Понимание этих нюансов — ключ к написанию эффективного и идиоматичного кода.",
              style: bodyTextStyle(context),
            ),
            const SizedBox(height: 24),
            _buildFeatureTile(
              context,
              icon: Icons.layers_clear,
              title: "Нет интерфейсов, но есть `implements`",
              content:
                  "В Dart нет ключевого слова `interface`. Вместо этого любой класс (абстрактный или нет) может выступать в роли интерфейса. Когда класс `implements` другой класс, он обязан реализовать все его методы, но не наследует их код. Это мощный способ задать 'контракт', не навязывая конкретную реализацию.",
            ),
            _buildFeatureTile(
              context,
              icon: Icons.factory,
              title: "Factory-конструкторы",
              content:
                  "В отличие от обычных конструкторов, `factory` не всегда создает новый экземпляр класса. Это позволяет реализовывать сложные сценарии, такие как возврат объекта из кэша (паттерн Singleton) или создание экземпляра подкласса в зависимости от входных данных (паттерн Abstract Factory).",
            ),
            _buildFeatureTile(
              context,
              icon: Icons.extension,
              title: "Миксины (Mixins) и Расширения (Extensions)",
              content:
                  "Миксины позволяют 'подмешивать' функциональность в класс без наследования, решая проблему множественного наследования. Это идеально для добавления сквозных функций, например, логирования. Расширения, в свою очередь, дают возможность добавлять новые методы к уже существующим классам, даже из стандартной библиотеки, делая код более читаемым и выразительным.",
            ),
            _buildFeatureTile(
              context,
              icon: Icons.lock_outline,
              title: "Приватность и `const` конструкторы",
              content:
                  "Приватность в Dart определяется просто: если имя поля или метода начинается с подчеркивания (`_`), оно приватно для своей библиотеки. Для создания неизменяемых объектов (immutability) используются `final` поля и `const` конструкторы, которые создают канонические, компилируемые на этапе сборки экземпляры, что повышает производительность.",
            ),
            const SizedBox(height: 24),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: subtitleTextStyle(context),
                children: [
                  const TextSpan(
                    text:
                        "Эти особенности делают Dart гибким и мощным инструментом. Понимание их поможет вам писать чистый и эффективный код. Подробнее о паттернах можно узнать из ",
                  ),
                  TextSpan(
                    text: "статьи на Хабре.",
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(Uri.parse(
                            'https://habr.com/ru/companies/otus/articles/678714/'));
                      },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const TagWrapper(tags: [
              Tag(tag: "Dart"),
              Tag(tag: "Паттерны"),
              Tag(tag: "Архитектура")
            ]),
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
            const Breadcrumbs(items: [
              BreadcrumbItem(text: "Главная", routeName: '/'),
              BreadcrumbItem(text: "Полезное", routeName: '/useful'),
              BreadcrumbItem(text: "Разработка", routeName: '/useful/dev'),
              BreadcrumbItem(text: "Паттерны"),
            ]),
            ...authorSection(
              context: context,
              imageUrl: "assets/images/avatar_default.png",
              name: "Автор: Шастовский Даниил",
              bio:
                  "SEO-специалист и разработчик этого приложения. Люблю находить элегантные решения для сложных задач, как в коде, так и в поисковой оптимизации.",
            ),
            divider(context),
            const Footer(),
          ].toMaxWidthSliver(),
        ],
      ),
    );
  }

  Widget _buildFeatureTile(BuildContext context,
      {required IconData icon,
      required String title,
      required String content}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ExpansionTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title,
            style: headlineSecondaryTextStyle(context).copyWith(fontSize: 18)),
        childrenPadding: const EdgeInsets.all(16),
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        children: [
          Text(content, style: bodyTextStyle(context)),
        ],
      ),
    );
  }
}
