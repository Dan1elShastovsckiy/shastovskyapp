import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/pages/page_about.dart';
import 'package:minimal/pages/page_contacts.dart';
import 'package:minimal/pages/page_typography.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';

class PortfolioPage extends StatelessWidget {
  static const String name = 'portfolio';

  const PortfolioPage({super.key});

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
            ),
            child: Text(
              "SHASTOVSKY.",
              style: GoogleFonts.montserrat(
                color: textPrimary,
                fontSize: 24,
                letterSpacing: 3,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ListTile(
            title: const Text('ГЛАВНАЯ'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
          ListTile(
            title: const Text('ОБО МНЕ'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AboutPage.name);
            },
          ),
          ListTile(
            title: const Text('ПОРТФОЛИО'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, PortfolioPage.name);
            },
          ),
          ListTile(
            title: const Text('ОБ ЭТОМ САЙТЕ'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, TypographyPage.name);
            },
          ),
          ListTile(
            title: const Text('КОНТАКТЫ'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, ContactsPage.name);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(String label, IconData icon, String url) {
    return SizedBox(
      width: 300,
      height: 80,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.black, size: 32),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          side: const BorderSide(color: Colors.black),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        ),
        onPressed: () => launchUrl(Uri.parse(url)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      drawer: isMobile ? buildAppDrawer(context) : null,
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 410),
        child: const MinimalMenuBar(),
      ),
      body: CustomScrollView(
        slivers: [
          ...[
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text(" ", style: headlineTextStyle),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text("Портфолио", style: headlineTextStyle),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom24,
                child: Text(
                    "Здесь вы можете найти мои проекты и работы, которые я вырастил в процессе своей карьеры. ",
                    style: subtitleTextStyle),
              ),
            ),
            divider,
            Container(
              margin: marginBottom40,
            ),
            // Заголовок раздела проектов
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: marginBottom24,
                      child: Text(
                        "Мои проекты",
                        style:
                            headlineSecondaryTextStyle.copyWith(fontSize: 28),
                      ),
                    ),
                  ),

                  // Проект 1: Maple Tattoo Supply CA
                  Container(
                    color: Colors.white,
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 24),
                      childrenPadding: EdgeInsets.zero,
                      title: Text(
                        "SEO для Maple Tattoo Supply CA",
                        style:
                            headlineSecondaryTextStyle.copyWith(fontSize: 22),
                      ),
                      children: [
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Логотип проекта
                              Center(
                                child: Image.asset(
                                  'assets/portfolio/maple_logo.webp',
                                  width: 200,
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Я вел этот проект по продвижению канадского интернет-магазина товаров для татуировок в течение ограниченного периода. К сожалению, сотрудничество было непродолжительным - заказчик принял решение прекратить SEO-продвижение после выполнения начального этапа работ. ",
                                style: bodyTextStyle,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "За отведенное время были выполнены следующие задачи:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                  "• Полный анализ внешней и внутренней оптимизации"),
                              const Text("• Технический аудит сайта"),
                              const Text(
                                  "• Анализ и аудит конкурентов в сегменте"),
                              const SizedBox(height: 20),
                              // Изображения показателей
                              Center(
                                child: Image.asset(
                                  'assets/portfolio/maple_metrics1.webp',
                                  width: 300,
                                ),
                              ),
                              Center(
                                child: Image.asset(
                                  'assets/portfolio/maple_metrics2.webp',
                                  width: 300,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Был проведен комплексный анализ текущего состояния сайта, включая технический аудит, оценку внешней ссылочной массы и анализ конкурентной среды в нише товаров для тату. Особое внимание уделялось выявлению технических ошибок, мешающих корректной индексации ресурса.",
                                style: bodyTextStyle,
                              ),
                              const SizedBox(height: 16),
                              // Дополнительное изображение
                              Center(
                                child: Image.asset(
                                  'assets/portfolio/maple_metrics3.webp',
                                  width: 300,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "По результатам аудита был подготовлен детальный отчет с рекомендациями по оптимизации, включая план по улучшению структуры сайта, исправлению технических ошибок и разработке контент-стратегии. Несмотря на преждевременное завершение проекта, все базовые работы по SEO были качественно выполнены.",
                                style: bodyTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1, color: Colors.grey),

                  // Проект 2: Genotek.ru
                  Container(
                    color: Colors.white,
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 24),
                      childrenPadding: EdgeInsets.zero,
                      title: Text(
                        "SEO для Genotek.ru",
                        style:
                            headlineSecondaryTextStyle.copyWith(fontSize: 22),
                      ),
                      children: [
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Логотип проекта
                              Center(
                                child: Image.asset(
                                  'assets/portfolio/genotek_logo.webp',
                                  width: 200,
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Проект вел длительное время, продолжает показывать положительную динамику по всем позициям. Особенно заметен рост позиций по генетическим тестированиям, которые вошли в TOP3 по запросам.",
                                style: bodyTextStyle,
                              ),
                              const SizedBox(height: 16),
                              // Изображения показателей
                              Center(
                                child: Image.asset(
                                  'assets/portfolio/genotek_metrics1.webp',
                                  width: 300,
                                ),
                              ),
                              Center(
                                child: Image.asset(
                                  'assets/portfolio/genotek_metrics2.webp',
                                  width: 300,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "На старте проекта была проведена глубокая аналитическая работа: технический аудит выявил проблемы с индексацией, анализ конкурентов показал слабые места в нашей стратегии, а семантическое ядро было расширено до 5000+ запросов. Особое внимание уделялось медицинской тематике и соответствию требованиям E-A-T.",
                                style: bodyTextStyle,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "На начальных этапах работы:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                  "• Проведен полный анализ внешней и внутренней оптимизации"),
                              const Text("• Выполнен технический аудит сайта"),
                              const SizedBox(height: 16),
                              const Text(
                                "В процессе работы:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                  "• Составлена расширенная архитектура сайта"),
                              const Text(
                                  "• Собраны ключевые запросы и сгруппированы по страницам"),
                              const Text(
                                  "• Написаны метатеги для низкоранжируемых страниц"),
                              const Text(
                                  "• Проанализированы конкуренты и построена стратегия внешней оптимизации"),
                              const Text(
                                  "• Улучшено цитирование на внешних источниках"),
                              const SizedBox(height: 20),
                              // Дополнительное изображение
                              Center(
                                child: Image.asset(
                                  'assets/portfolio/genotek_metrics3.webp',
                                  width: 300,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "В процессе работы мы полностью переработали архитектуру сайта, создали систему тематических кластеров и значительно улучшили контент. Для внешней оптимизации была разработана стратегия цитирования в авторитетных медицинских источниках, что повысило доверие к ресурсу.",
                                style: bodyTextStyle,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Текущие результаты показывают стабильный рост органического трафика (+42% за год) и увеличение конверсии в заявки на генетические исследования. Проект продолжает развиваться с фокусом на экспертном контенте и улучшении пользовательского опыта.",
                                style: bodyTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1, color: Colors.grey),

                  // Проект 3: Vitateka.ee
                  Container(
                    color: Colors.white,
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 24),
                      childrenPadding: EdgeInsets.zero,
                      title: Text(
                        "SEO для Vitateka.ee",
                        style:
                            headlineSecondaryTextStyle.copyWith(fontSize: 22),
                      ),
                      children: [
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Логотип проекта
                              Center(
                                child: Image.asset(
                                  'assets/portfolio/vitateka_logo.webp',
                                  width: 200,
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Европейский проект интернет-аптеки столкнулся с серьезным кризисом - сайт был взломан, что привело к полной потере позиций в поисковых системах. Моей задачей было не только восстановить прежние позиции, но и превзойти их. За год работы нам удалось улучшить среднюю позицию по ключевым запросам на 35% по всем целевым регионам Европы.",
                                style: bodyTextStyle,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "После восстановления сайта от последствий взлома была разработана комплексная стратегия, включающая техническую оптимизацию, создание многоязычного контента и построение региональной ссылочной массы. Особое внимание уделялось соответствию европейским требованиям GDPR.",
                                style: bodyTextStyle,
                              ),
                              const SizedBox(height: 16),
                              // Изображение показателей
                              Center(
                                child: Image.asset(
                                  'assets/portfolio/vitateka_metrics1.webp',
                                  width: 300,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Динамика позиций отслеживалась по неизменному семантическому ядру, чтобы точно оценить эффект от проделанной работы. Ядро обновлялось только в отдельных разделах, которые были исключены из общей статистики для чистоты анализа.",
                                style: bodyTextStyle,
                              ),
                              const SizedBox(height: 20),
                              // Дополнительное изображение
                              Center(
                                child: Image.asset(
                                  'assets/portfolio/vitateka_metrics2.webp',
                                  width: 300,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Результатом стала не только полная реабилитация проекта после взлома, но и увеличение органического трафика на 75% по сравнению с докризисным периодом. Особенно заметен рост в Эстонии и странах Балтии, где проект вышел в ТОП-3-5 по основным коммерческим запросам.",
                                style: bodyTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1, color: Colors.grey),

                  // Проект 4: Credistory.ru
                  Container(
                    color: Colors.white,
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 24),
                      childrenPadding: EdgeInsets.zero,
                      title: Text(
                        "SEO для блога Credistory.ru",
                        style:
                            headlineSecondaryTextStyle.copyWith(fontSize: 22),
                      ),
                      children: [
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Логотип проекта
                              Center(
                                child: Image.asset(
                                  'assets/portfolio/credistory_logo.webp',
                                  width: 200,
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Для этого финансового проекта был достигнут впечатляющий рост органического трафика - +55% к каждому месяцу(!) за год благодаря комплексной работе с блогом и основными коммерческими страницами. Ключевым фактором успеха стала разработка контент-стратегии, ориентированной на решение проблем целевой аудитории.",
                                style: bodyTextStyle,
                              ),
                              const SizedBox(height: 16),
                              // Изображение показателей
                              Center(
                                child: Image.asset(
                                  'assets/portfolio/credistory_metrics1.webp',
                                  width: 300,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Мы создали новые разделы блога, посвященные финансовой грамотности, кредитованию и инвестициям. Каждая статья тщательно прорабатывалась с точки зрения полезности для пользователя и SEO-оптимизации. Контент-план включал более 150 материалов, охватывающих все аспекты финансовой тематики.",
                                style: bodyTextStyle,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "В рамках проекта:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const Text("• Созданы новые разделы для блога"),
                              const Text("• Разработан контент-план"),
                              const Text(
                                  "• Написаны экспертные статьи по финансовой тематике"),
                              const Text("• Оптимизирована структура сайта"),
                              const Text("• Улучшена внутренняя перелинковка"),
                              const SizedBox(height: 20),
                              // Дополнительное изображение
                              Center(
                                child: Image.asset(
                                  'assets/portfolio/credistory_metrics2.webp',
                                  width: 300,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Оптимизация структуры сайта и улучшение внутренней перелинковки позволили равномерно распределить ссылочный вес и повысить авторитетность ключевых коммерческих страниц. Была внедрена система контекстных ссылок, связывающая полезный контент с услугами компании. В результате не только вырос трафик, но и увеличилось время пребывания на сайте на 40%.",
                                style: bodyTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1, color: Colors.grey),

                  // Проект 5: shastovsky.ru
                  Container(
                    color: Colors.white,
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 24),
                      childrenPadding: EdgeInsets.zero,
                      title: Text(
                        "flutter разработка сайта shastovsky.ru",
                        style:
                            headlineSecondaryTextStyle.copyWith(fontSize: 22),
                      ),
                      children: [
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Логотип проекта
                              Center(
                                child: Image.asset(
                                  'assets/portfolio/shastovsky_logo.webp',
                                  width: 200,
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Этот сайт - мой личный проект, который я разработал с нуля на Flutter. Он демонстрирует мои навыки в разработке кроссплатформенных приложений и веб-сайтов. Я использовал современные технологии и подходы, чтобы создать удобный и функциональный интерфейс.",
                                style: bodyTextStyle,
                              ),
                              const SizedBox(height: 16),
                              // Изображение показателей
                              Center(
                                child: Image.asset(
                                  'assets/portfolio/shastovsky_in1.webp',
                                  width: 300,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Сайт был разработан с акцентом на производительность и отзывчивость. Я использовал язык Dart, а точнее его фреймворк Flutter для создания кроссплатформенного приложения, которое работает как на мобильных устройствах, так и в веб-браузерах. Это позволяет пользователям легко получать доступ к моему портфолио и контактной информации с любого устройства. \n\n"
                                "Я также применил принципы matherial design и сделал его адаптивным, чтобы сайт выглядел отлично на любых экранах. Использование Flutter позволяет мне быстро вносить изменения и обновления, что делает этот проект гибким и масштабируемым. \n",
                                style: bodyTextStyle,
                              ),
                              const SizedBox(height: 20),
                              // Дополнительное изображение
                              Center(
                                child: Image.asset(
                                  'assets/portfolio/shastovsky_in2.webp',
                                  width: 300,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: marginBottom24,
                                  child: RichText(
                                    text: TextSpan(
                                      style: bodyTextStyle,
                                      children: [
                                        const TextSpan(
                                          text:
                                              "Масштабируемость особенно важна для ",
                                        ),
                                        TextSpan(
                                          text: "этого проекта",
                                          style: bodyTextStyle.copyWith(
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () => launchUrl(Uri.parse(
                                                'https://github.com/Dan1elShastovsckiy/shastovskyapp/')),
                                        ),
                                        const TextSpan(
                                          text:
                                              ", так как я планирую регулярно обновлять контент(особенно в блоге) и добавлять новые разделы(например в будущем хочу сделать магазин с авторизацией и заказом для своих фото, чтобы монетизировать свои путешествия). Я также использую возможности Flutter для интеграции с различными API и внешними сервисами, что позволяет расширять функциональность сайта без значительных затрат времени на разработку.\n",
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1, color: Colors.grey),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text(" ", style: headlineTextStyle),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom12,
                child: Text("Какой у меня подход к работе?",
                    style: headlineSecondaryTextStyle),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom24,
                child: Text(
                    "Я верю в важность качественного кода, ТЗ по SMART и чистого дизайна. Мой подход заключается в том, чтобы создавать продукты, которые не только функциональны, но и приятны в использовании. \n\n"
                    "Я всегда стремлюсь к лучшим практикам SEO - оптимизации, разработки и использую современные технологии. Я также ценю обратную связь и считаю, что она помогает мне расти как SEO специалисту и разработчику. Я открыт к новым идеям и всегда готов учиться. Я люблю работать в команде и считаю, что совместная работа приводит к лучшим результатам.",
                    style: subtitleTextStyle),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: marginBottom24,
                child: Text(
                    "Я считаю, что каждый проект — это возможность для роста и обучения. Я стремлюсь к тому, чтобы каждый мой проект был не только успешным, но и полезным для пользователей. Я верю, что технологии могут изменить мир к лучшему, и я хочу быть частью этого изменения.",
                    style: subtitleTextStyle),
              ),
            ),
            dividerSmall,
            Container(
              margin: marginBottom24,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: marginBottom24,
                child: Text("P.S.", style: subtitleTextStyle),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: marginBottom40,
                child: RichText(
                  text: TextSpan(
                    style: bodyTextStyle,
                    children: [
                      const TextSpan(
                        text:
                            "Если вам понравился этот сайт или то, что я делаю - вы можете поддержать меня в моем телеграм канале ",
                      ),
                      TextSpan(
                        text: "@shastovscky",
                        style: bodyTextStyle.copyWith(
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
                        style: bodyTextStyle.copyWith(
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
            // кнопки соц.сетей
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              width: double.infinity, // Растягиваем контейнер на всю ширину
              child: Center(
                // Центрируем содержимое
                child: Container(
                  constraints: const BoxConstraints(
                      maxWidth:
                          600), // Ограничиваем максимальную ширину блока с кнопками
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.telegram, color: Colors.black),
                        label: const Text('Telegram личный'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                        ),
                        onPressed: () =>
                            launchUrl(Uri.parse('https://t.me/switchleveler')),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.campaign, color: Colors.black),
                        label: const Text('Telegram канал'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                        ),
                        onPressed: () =>
                            launchUrl(Uri.parse('https://t.me/shastovscky')),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt, color: Colors.black),
                        label: const Text('Instagram'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                        ),
                        onPressed: () => launchUrl(
                            Uri.parse('https://instagram.com/yellolwapple')),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.work, color: Colors.black),
                        label: const Text('LinkedIn'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                        ),
                        onPressed: () => launchUrl(Uri.parse(
                            'https://hh.ru/resume/b94af167ff049031c70039ed1f746c61797571')),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.smart_display_outlined,
                            color: Colors.black), // YouTube
                        label: const Text('YouTube'), // текст кнопки
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                        ),
                        onPressed: () => launchUrl(Uri.parse(
                            'https://www.youtube.com/@itsmyadv')), // ссылка на YouTube
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.article_outlined,
                            color: Colors.black),
                        label: const Text('VC.RU'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                        ),
                        onPressed: () =>
                            launchUrl(Uri.parse('https://vc.ru/id1145025')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ].toMaxWidthSliver(),
          SliverFillRemaining(
            hasScrollBody: false,
            child: MaxWidthBox(
                maxWidth: 1200,
                backgroundColor: Colors.white,
                child: Container()),
          ),
          ...[
            divider,
            const Footer(),
          ].toMaxWidthSliver(),
        ],
      ),
    );
  }
}
