// lib/pages/page_portfolio.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/meta_tag_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:responsive_framework/responsive_framework.dart';

// <<< ИЗМЕНЕНИЕ 1: StatelessWidget -> StatefulWidget >>>
class PortfolioPage extends StatefulWidget {
  static const String name = 'portfolio';

  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

// <<< ИЗМЕНЕНИЕ 2: СОЗДАН НОВЫЙ КЛАСС State >>>
class _PortfolioPageState extends State<PortfolioPage> {
  // <<< ИЗМЕНЕНИЕ 3: ДОБАВЛЕН initState С МЕТА-ТЕГАМИ >>>
  @override
  void initState() {
    super.initState();
    MetaTagService().updateAllTags(
      title: "Портфолио | Проекты Даниила Шастовского",
      description:
          "Обзор моих ключевых проектов в области SEO-продвижения, веб-разработки и контент-стратегий. Результаты, кейсы и технологии.",
      imageUrl:
          "https://shastovsky.ru/assets/assets/images/me_georgia_mountains_2.webp", // Убедитесь, что эта картинка существует
    );
  }

  // <<< ИЗМЕНЕНИЕ 4: ВЕСЬ КОД UI ПЕРЕНЕСЕН СЮДА >>>
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    final theme = Theme.of(context);
    final boldTextStyle =
        bodyTextStyle(context).copyWith(fontWeight: FontWeight.bold);

    return Scaffold(
      drawer: isMobile ? buildAppDrawer(context) : null,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 110),
        child: const MinimalMenuBar(),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveBreakpoints.of(context).isMobile ? 24 : 48,
            ),
            sliver: SliverToBoxAdapter(
              child: MaxWidthBox(
                maxWidth: 1200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: marginBottom12,
                        child:
                            Text("Проекты", style: headlineTextStyle(context)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: marginBottom24,
                        child: Text(
                            "Здесь вы можете найти проекты, которые я вел и выращивал в процессе своей карьеры. \nЯ продолжаю активно работать со многими из нижеперечисленных компаний, развивая их и достигая новых высот.",
                            textAlign: TextAlign.center,
                            style: subtitleTextStyle(context)),
                      ),
                    ),
                    divider(context),
                    const SizedBox(height: 40),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: marginBottom24,
                            child: Text(
                              "Мои проекты",
                              style: headlineSecondaryTextStyle(context)
                                  .copyWith(fontSize: 28),
                            ),
                          ),
                        ),
                        _buildProjectExpansionTile(
                          context: context,
                          title: "SEO для Genotek.ru",
                          children: [
                            _buildLogo('assets/portfolio/genotek_logo.webp'),
                            Text(
                              "Проект вел длительное время, и он продолжает показывать положительную динамику. За год работы удалось добиться роста органического трафика на +42% и вывести ключевые запросы по генетическим тестам в ТОП-3.",
                              style: bodyTextStyle(context),
                            ),
                            _buildMetricImage(
                                'assets/portfolio/genotek_metrics1.webp'),
                            _buildMetricImage(
                                'assets/portfolio/genotek_metrics2.webp'),
                            const SizedBox(height: 20),
                            Text("Ключевые задачи:", style: boldTextStyle),
                            Text("• Полный технический и конкурентный аудит.",
                                style: bodyTextStyle(context)),
                            Text(
                                "• Переработка архитектуры сайта и создание тематических кластеров.",
                                style: bodyTextStyle(context)),
                            Text(
                                "• Написание метатегов и экспертного контента.",
                                style: bodyTextStyle(context)),
                            Text(
                                "• Построение стратегии внешней оптимизации и цитирования в авторитетных медицинских источниках.",
                                style: bodyTextStyle(context)),
                            _buildMetricImage(
                                'assets/portfolio/genotek_metrics3.webp'),
                            const SizedBox(height: 20),
                            Text(
                              "Текущие результаты показывают стабильный рост и увеличение конверсии в заявки. Проект продолжает развиваться с фокусом на экспертном контенте и улучшении пользовательского опыта.",
                              style: bodyTextStyle(context),
                            ),
                          ],
                        ),
                        _buildProjectExpansionTile(
                          context: context,
                          title: "SEO для Vitateka.ee",
                          children: [
                            _buildLogo('assets/portfolio/vitateka_logo.webp'),
                            Text(
                              "Ключевая задача: реабилитация европейского проекта интернет-аптеки после взлома. За год работы средняя позиция по целевым запросам была улучшена на 35% по всем регионам Европы, а органический трафик вырос на 75% по сравнению с докризисным периодом.",
                              style: bodyTextStyle(context),
                            ),
                            const SizedBox(height: 16),
                            Text("Ключевые задачи:", style: boldTextStyle),
                            Text(
                                "• Восстановление сайта после взлома и комплексная техническая оптимизация.",
                                style: bodyTextStyle(context)),
                            Text(
                                "• Разработка многоязычной контент-стратегии с учетом требований GDPR.",
                                style: bodyTextStyle(context)),
                            _buildMetricImage(
                                'assets/portfolio/vitateka_metrics1.webp'),
                            Text(
                                "• Наращивание региональной ссылочной массы в странах Балтии и Европы.",
                                style: bodyTextStyle(context)),
                            _buildMetricImage(
                                'assets/portfolio/vitateka_metrics2.webp'),
                          ],
                        ),
                        _buildProjectExpansionTile(
                          context: context,
                          title: "SEO для блога Credistory.ru",
                          children: [
                            _buildLogo('assets/portfolio/credistory_logo.webp'),
                            Text(
                              "Результат: впечатляющий рост органического трафика на +55% к каждому месяцу в течение года. Ключевым фактором успеха стала разработка и реализация контент-стратегии.",
                              style: bodyTextStyle(context),
                            ),
                            _buildMetricImage(
                                'assets/portfolio/credistory_metrics1.webp'),
                            const SizedBox(height: 20),
                            Text("Ключевые задачи:", style: boldTextStyle),
                            Text(
                                "• Разработка и реализация контент-стратегии с нуля (более 150 статей).",
                                style: bodyTextStyle(context)),
                            Text(
                                "• Улучшение структуры сайта и внутренней перелинковки.",
                                style: bodyTextStyle(context)),
                            Text("• Рост времени пребывания на сайте на 40%.",
                                style: bodyTextStyle(context)),
                            _buildMetricImage(
                                'assets/portfolio/credistory_metrics2.webp'),
                          ],
                        ),
                        _buildProjectExpansionTile(
                          context: context,
                          title: "SEO для Leroymerlin.ru",
                          children: [
                            _buildLogo(
                                'assets/portfolio/leroymerlin_logo.webp'),
                            Text(
                                "Работал в качестве Middle SEO-специалиста в большой внутренней команде проекта до ухода компании из РФ. Ввиду NDA, могу поделиться общей стратегией и результатами на концептуальном уровне.",
                                style: bodyTextStyle(context)),
                            const SizedBox(height: 16),
                            _buildMetricImage(
                                'assets/portfolio/leroymerlin_metrics1.webp'),
                            Text(
                                "Ключевой задачей была реализация масштабной контент-стратегии (20-40 текстов в день) с целью вытеснения конкурентов из выдачи по всем возможным НЧ и СЧ запросам. Такой проактивный подход обеспечивал проекту колоссальные показатели роста и доминирование в нише.",
                                style: bodyTextStyle(context)),
                          ],
                        ),
                        _buildProjectExpansionTile(
                          context: context,
                          title: "SEO для sportmaster.ru",
                          children: [
                            _buildLogo(
                                'assets/portfolio/sportmaster_logo.webp'),
                            Text(
                                "В качестве Middle SEO-специалиста в составе сильной команды внес свой вклад в рост онлайн-продаж на +35% в крупнейших городах.",
                                style: bodyTextStyle(context)),
                            const SizedBox(height: 16),
                            Text("Мои зоны ответственности:",
                                style: boldTextStyle),
                            Text(
                                "• Контент-планирование для блога: от идеи и ТЗ до контроля копирайтинга.",
                                style: bodyTextStyle(context)),
                            Text(
                                "• Участие в реорганизации структуры сайта и брейншторме новых идей.",
                                style: bodyTextStyle(context)),
                          ],
                        ),
                        _buildProjectExpansionTile(
                          context: context,
                          title: "SEO для iek.ru",
                          children: [
                            _buildLogo('assets/portfolio/iek_logo.webp'),
                            Text(
                                "Работал над проектом в составе команды агентства. Нашей задачей было обеспечение стабильного роста в консервативной B2B-нише. Мы добились планомерного улучшения всех ключевых SEO-показателей (переходов, показов, CTR).",
                                style: bodyTextStyle(context)),
                            _buildMetricImage(
                                'assets/portfolio/iek_metrics1.webp'),
                            const SizedBox(height: 16),
                            Text(
                                "Стратегия была сфокусирована на двух ключевых направлениях:",
                                style: boldTextStyle),
                            Text(
                                "• Систематическое обновление и улучшение существующего контента.",
                                style: bodyTextStyle(context)),
                            Text(
                                "• Планомерное наращивание качественной ссылочной массы.",
                                style: bodyTextStyle(context)),
                          ],
                        ),
                        _buildProjectExpansionTile(
                          context: context,
                          title: "SEO для weitnauer.com",
                          children: [
                            _buildLogo('assets/portfolio/weitnauer_logo.webp'),
                            Text(
                                "Принял проект швейцарского бренда (поставщик Duty Free) и за короткий срок провел полный аудит, внедрил систему контент-менеджмента и составил стартовую стратегию для линкбилдинга.",
                                style: bodyTextStyle(context)),
                            const SizedBox(height: 16),
                            _buildMetricImage(
                                'assets/portfolio/weitnauer_metrics1.webp'),
                            Text(
                                "Затем я передал проект своему подопечному Антону (Антон если читаешь это - こんにちは), который блестяще его реализовал. С помощью стратегической базы проект вырос с нуля до ТОП-3 и ТОП-10 в ключевых регионах, а DR сайта увеличился до 15 всего за полгода.",
                                style: bodyTextStyle(context)),
                          ],
                        ),
                        _buildProjectExpansionTile(
                          context: context,
                          title: "SEO для askona.ru",
                          children: [
                            _buildLogo('assets/portfolio/askona_logo.webp'),
                            Text(
                                "Один из самых сложных и конкурентных проектов. В условиях высочайшей конкуренции в мебельной нише и внутренних сложностей с разработкой, под моим контролем проект показывает стабильный рост показателей от квартала к кварталу, нивелируя даже сезонные падения спроса.",
                                style: bodyTextStyle(context)),
                            _buildMetricImage(
                                'assets/portfolio/askona_metrics1.webp'),
                            const SizedBox(height: 16),
                            Text(
                                "Более подробной информацией, к сожалению, поделиться не могу ввиду строгого NDA.",
                                style: bodyTextStyle(context)),
                          ],
                        ),
                        _buildProjectExpansionTile(
                          context: context,
                          title: "SEO для rsk-factory.ru",
                          children: [
                            _buildLogo(
                                'assets/portfolio/rsk_factory_logo.webp'),
                            Text(
                                "Уникальный проект по созданию кастомной мебели. Нашей совместной стратегией стало: «заявлять о себе везде, делать это качественно и системно».",
                                style: bodyTextStyle(context)),
                            const SizedBox(height: 16),
                            _buildMetricImage(
                                'assets/portfolio/rsk_factory_metrics1.webp'),
                            Text("Результаты за год совместной работы:",
                                style: boldTextStyle),
                            Text(
                                "• Рост семантического ядра в ТОП-10 на 27% и в ТОП-3 на 12%.",
                                style: bodyTextStyle(context)),
                            Text(
                                "• Увеличение переходов по всем регионам на 63%.",
                                style: bodyTextStyle(context)),
                            Text(
                                "• Значительный рост конверсий и минимальный процент отказов.",
                                style: bodyTextStyle(context)),
                            const SizedBox(height: 16),
                            Text(
                                "Это было достигнуто за счет полной переработки блога, обновления контента и создания экспертных статей на внешних площадках.",
                                style: bodyTextStyle(context)),
                          ],
                        ),
                        _buildProjectExpansionTile(
                          context: context,
                          title: "SEO для vmeste.sber.ru",
                          children: [
                            _buildLogo(
                                'assets/portfolio/vmeste_sber_logo.webp'),
                            Text(
                                "Очень важный и добрый проект, где главная цель — сделать так, чтобы помощь всегда находила тех, кто в ней нуждается. Вся работа по SEO направлена на максимальное увеличение видимости сайта по запросам, связанным с благотворительностью.",
                                style: bodyTextStyle(context)),
                            const SizedBox(height: 16),
                            _buildMetricImage(
                                'assets/portfolio/vmeste_sber_metrics1.webp'),
                            Text(
                                "Мы растим блог и улучшаем сайт, чтобы каждый, кто хочет помочь, мог легко нас найти. Проект находится под NDA.",
                                style: bodyTextStyle(context)),
                          ],
                        ),
                        _buildProjectExpansionTile(
                          context: context,
                          title: "SEO для sbersova.ru",
                          children: [
                            _buildLogo('assets/portfolio/sbersova_logo.webp'),
                            Text(
                                "Большая платформа с курсами и блогом по инвестициям. Несмотря на молодость проекта и жесточайшую конкуренцию с гигантами вроде Тинькофф Журнала, мы показываем очень успешную годовую динамику.",
                                style: bodyTextStyle(context)),
                            const SizedBox(height: 16),
                            _buildMetricImage(
                                'assets/portfolio/sbersova_metrics1.webp'),
                            Text(
                                "Благодаря комплексной работе моей команды с контентом и внешними ссылками, мы добились значительного роста запросов в ТОП-10 и увеличения цитируемости сайта. Проект находится под NDA.",
                                style: bodyTextStyle(context)),
                          ],
                        ),
                        _buildProjectExpansionTile(
                          context: context,
                          title: "SEO для Maple Tattoo Supply CA",
                          children: [
                            _buildLogo('assets/portfolio/maple_logo.webp'),
                            Text(
                              "Задача: комплексная подготовка и запуск SEO-продвижения для канадского интернет-магазина с нуля. За время сотрудничества был выполнен полный комплекс работ по базовой оптимизации, что создало прочный фундамент для дальнейшего роста проекта.",
                              style: bodyTextStyle(context),
                            ),
                            _buildMetricImage(
                                'assets/portfolio/maple_metrics1.webp'),
                            const SizedBox(height: 16),
                            Text("Ключевые выполненные задачи:",
                                style: boldTextStyle),
                            Text(
                                "• Проведена базовая SEO-оптимизация сайта под регион Канады.",
                                style: bodyTextStyle(context)),
                            Text(
                                "• Собрано семантическое ядро для дальнейшей работы с мета-тегами и контентом.",
                                style: bodyTextStyle(context)),
                            Text(
                                "• Разработана стартовая стратегия для внешнего продвижения и наращивания ссылочной массы.",
                                style: bodyTextStyle(context)),
                            Text(
                                "• Проведены глубокие аудиты: конкурентный и E-E-A-T (Экспертиза, Опыт, Авторитетность, Доверие).",
                                style: bodyTextStyle(context)),
                            Text(
                                "• Внесены правки в дизайн и внедрены элементы для улучшения поведенческих факторов и удержания пользователей.",
                                style: bodyTextStyle(context)),
                            const SizedBox(height: 16),
                            _buildMetricImage(
                                'assets/portfolio/maple_metrics2.webp'),
                            _buildMetricImage(
                                'assets/portfolio/maple_metrics3.webp'),
                            const SizedBox(height: 20),
                            Text(
                              "По итогам моей работы проект был полностью готов к активной фазе контент-маркетинга и линкбилдинга, с четко определенной стратегией и исправленными техническими ошибками, мешавшими индексации.",
                              style: bodyTextStyle(context),
                            ),
                          ],
                        ),
                        _buildProjectExpansionTile(
                          context: context,
                          title: "Flutter разработка сайта shastovsky.ru",
                          isInitiallyExpanded: true,
                          children: [
                            _buildLogo('assets/portfolio/shastovsky_logo.webp'),
                            Text(
                              "Этот сайт - мой личный проект, разработанный с нуля на Flutter для демонстрации навыков в создании кроссплатформенных веб-приложений. Он служит живым примером моего подхода к чистому коду, адаптивному дизайну и производительности.",
                              style: bodyTextStyle(context),
                            ),
                            _buildMetricImage(
                                'assets/portfolio/shastovsky_in1.webp'),
                            const SizedBox(height: 16),
                            Text(
                              "Использование фреймворка Flutter позволило создать единую кодовую базу для веба и потенциально для мобильных приложений. Особое внимание уделено SEO-оптимизации на стороне сервера (Nginx) и настройке корректной обработки маршрутов для SPA.",
                              style: bodyTextStyle(context),
                            ),
                            _buildMetricImage(
                                'assets/portfolio/shastovsky_in2.webp'),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.center,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: bodyTextStyle(context),
                                  children: [
                                    const TextSpan(
                                        text:
                                            "Если вам интересно посмотреть подробно исходники: Исходный код проекта доступен на "),
                                    TextSpan(
                                      text: "GitHub",
                                      style: bodyTextStyle(context).copyWith(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => launchUrl(Uri.parse(
                                            'https://github.com/Dan1elShastovsckiy/shastovskyapp/')),
                                    ),
                                    const TextSpan(
                                        text:
                                            ". Далее развитие сайта планируется с учетом отзывов пользователей, поэтому если вам что-то показалось неудобным - напишите мне в личные сообщения, я бы хотел знать и исправить все возможные проблемы."),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: marginBottom12,
                        child: Text("Какой у меня подход к работе?",
                            style: headlineSecondaryTextStyle(context)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: marginBottom24,
                        child: Text(
                            "Я верю в важность качественного кода, ТЗ по SMART и чистого дизайна. Мой подход заключается в том, чтобы создавать продукты, которые не только функциональные, но и приятны в использовании. \n\n"
                            "Всегда стремлюсь к лучшим практикам SEO - оптимизации, разработки и использую современные технологии. Также ценю обратную связь и считаю, что она помогает мне расти как SEO специалисту и разработчику. \n"
                            "Я открыт к новым идеям и всегда готов учиться, люблю работать в команде и считаю, что совместная работа приводит к лучшим результатам.",
                            textAlign: TextAlign.center,
                            style: subtitleTextStyle(context)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: marginBottom24,
                        child: Text(
                            "Я считаю, что каждый проект — это возможность для роста и обучения и стремлюсь к тому, чтобы каждый мой проект был не только успешным, но и полезным для пользователей. Знаю, что технологии могут изменить мир к лучшему, и хочу быть частью этого изменения.",
                            textAlign: TextAlign.center,
                            style: subtitleTextStyle(context)),
                      ),
                    ),
                    Center(child: dividerSmall(context)),
                    const SizedBox(height: 24),
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
                                  ..onTap = () => launchUrl(
                                      Uri.parse('https://t.me/shastovscky')),
                              ),
                              const TextSpan(
                                text:
                                    " или подписаться на меня в инстаграм(запрещенная в РФ организация) ",
                              ),
                              TextSpan(
                                text: "@yellolwapple",
                                style: bodyTextStyle(context).copyWith(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => launchUrl(Uri.parse(
                                      'https://instagram.com/yellolwapple')),
                              ),
                              const TextSpan(
                                text:
                                    " в нем я делюсь фото и видео из своих поездок.",
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
                                onPressed: () => launchUrl(
                                    Uri.parse('https://t.me/switchleveler')),
                              ),
                              ElevatedButton.icon(
                                icon: Icon(Icons.campaign,
                                    color: theme.colorScheme.onSurface),
                                label: const Text('Telegram канал'),
                                style: elevatedButtonStyle(context),
                                onPressed: () => launchUrl(
                                    Uri.parse('https://t.me/shastovscky')),
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
                                onPressed: () => launchUrl(Uri.parse(
                                    'https://instagram.com/yellolwapple')),
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
                                onPressed: () => launchUrl(Uri.parse(
                                    'https://www.youtube.com/@itsmyadv')),
                              ),
                              ElevatedButton.icon(
                                icon: Icon(Icons.article_outlined,
                                    color: theme.colorScheme.onSurface),
                                label: const Text('VC.RU'),
                                style: elevatedButtonStyle(context),
                                onPressed: () => launchUrl(
                                    Uri.parse('https://vc.ru/id1145025')),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: MaxWidthBox(
                maxWidth: 1200,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    divider(context),
                    const Footer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectExpansionTile({
    required BuildContext context,
    required String title,
    required List<Widget> children,
    bool isInitiallyExpanded = false,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      child: ExpansionTile(
        key: PageStorageKey(title),
        backgroundColor: theme.colorScheme.surface,
        collapsedBackgroundColor: theme.colorScheme.surface,
        iconColor: theme.colorScheme.onSurface,
        collapsedIconColor: theme.colorScheme.onSurface,
        initiallyExpanded: isInitiallyExpanded,
        tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        title: Text(
          title,
          style: headlineSecondaryTextStyle(context).copyWith(fontSize: 22),
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(String path) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Image.asset(
          path,
          width: 200,
          height: 100,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              const SizedBox(height: 100),
        ),
      ),
    );
  }

  Widget _buildMetricImage(String path) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Image.asset(
          path,
          width: 400,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
