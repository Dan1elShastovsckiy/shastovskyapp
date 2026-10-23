import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/components/semantic_widgets.dart'; // <<< ИМПОРТ СЕМАНТИКИ
import 'package:minimal/pages/travel_posts/page_sri_lanka_post.dart';
import 'package:minimal/pages/travel_posts/page_georgia_post.dart';
import 'package:minimal/pages/travel_posts/page_jordan_post.dart';
import 'package:minimal/pages/travel_posts/page_post.dart';
import 'package:minimal/pages/page_under_construction.dart';
import 'package:minimal/utils/max_width_extension.dart';

// Константы для постов
const String srilankaTitle =
    "ШРИ-ЛАНКА. От серф-провала до горных вершин Цейлона";
const String srilankaDescription =
    "6 месяцев жизни на острове. Вся правда о быте, ценах, серфинге, невероятных закатах и почему здесь нет доставки еды. Честный гайд […]";
const String jordanTitle = "ИОРДАНИЯ. От Мертвого моря до песков Арракиса";
const String jordanDescription =
    "Честный гид по стране, недооцененной российскими туристами. Цены, отели, Jordan Pass, аренда авто и, конечно, запах ослов в Петре […]";
const String moroccoTitle =
    "МАРОККО: Заблудиться, чтобы найти себя в сердце пустоты";
const String moroccoDescription =
    "История о том, как я потерялся в лабиринте улиц Марокко. Ароматы специй, крики зазывал, скрытые риады — и уроки таксистов, которые подарила мне эта страна. Внутри статьи можно найти ПОДАРОК! […]";

const String phuketTitle = "ПХУКЕТ - НЕ ТОЛЬКО ПЛЯЖИ";
const String phuketDescription =
    "Да, пляжи Пхукета великолепны. Но эта статья — о том, как сойти с протоптанной тропы. Аренда байка, поиск нетуристических водопадов, уединенные бухты и мангровые заросли — мой гид по другому Пхукету […]";

const String vietnamTitle = "ВЬЕТНАМ: Бирюзовые берега Дананга";
const String vietnamDescription =
    "Солнечные пляжи, морепродукты и атмосфера приморского города — как провести идеальный день во Вьетнаме […]";

const String georgiaMountains1Title = "ГРУЗИЯ: Из Батуми в Кутаиси через горы";
const String georgiaMountains1Description =
    "Первое знакомство с Грузией: апокалиптическая посадка в Батуми, огненная шаурма и хоррор-квест по ночным дорогам в деревню над облаками […]";

const String georgiaMountains2Title = "ГРУЗИЯ: От Тбилиси к границе с Россией";
const String georgiaMountains2Description =
    "Путешествие по Военно-Грузинской дороге: древние крепости, горные перевалы и виды на Кавказский хребет […]";

const String malaysiaTitle = "МАЛАЙЗИЯ: Небоскребы и джунгли Куала-Лумпура";
const String malaysiaDescription =
    "Контрасты столицы Малайзии: от башен-близнецов Петронас до скрытых в зелени храмов и уличной еды, которая вскружит вам голову […]";

const String dubaiTitle = "ДУБАЙ: Роскошь и пустыня от Абу-Даби";
const String dubaiDescription =
    "Путешествие из столицы в город будущего. Небоскребы, искусственные острова и величие пустыни — как увидеть все грани ОАЭ […]";

const String turkeyTitle = "ТУРЦИЯ: Душа двух континентов в Стамбуле";
const String turkeyDescription =
    "Прогулки по Гранд-базару, ароматы кальяна, величие Айя-Софии и коты, которые правят этим городом. Мой путеводитель по сердцу Турции […]";

class ListPage extends StatefulWidget {
  static const String name = 'list';

  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final ScrollController _scrollController = ScrollController();
  // <<< ФЛАГ РЕНДЕРИНГА >>>
  bool _isPrerendering = false;

  final List<String> _pageImages = [
    "assets/images/sri_banner.webp",
    "assets/images/jordan/jordan-banner.webp",
    "assets/images/me_sachara_desert.webp",
    "assets/images/georgia_mountains.webp",
    "assets/images/kuala_lumpur.webp",
    "assets/images/abu_dhabi.webp",
    "assets/images/me_istambul.webp",
    "assets/images/vietnam_beach.webp",
    "assets/images/me_similan_island_colored.webp",
    "assets/images/me_georgia_mountains_2.webp",
  ];

  @override
  void initState() {
    super.initState();
    // <<< ПРОВЕРКА URL >>>
    final uri = Uri.base;
    if (uri.queryParameters['prerender'] == 'true') {
      setState(() {
        _isPrerendering = true;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final imagePath in _pageImages) {
      precacheImage(AssetImage(imagePath), context);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // <<< БЛОК СЕМАНТИКИ ДЛЯ БОТОВ >>>
  Widget _buildPrerenderContent() {
    const String baseUrl = "https://shastovsky.com";
    String underConstructionUrl(String title) => Uri(
          scheme: 'https',
          host: 'shastovsky.com',
          path: '/${PageUnderConstruction.name}',
          queryParameters: {'title': title},
        ).toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // H1 и Описание
        const SemanticH1(
            "Блог Даниила Шастовского: Путешествия, SEO и Разработка"),
        const SemanticP(
            "Привет! Я Даниил. Это мой блог о жизни в разных точках мира, работе в SEO и разработке на Flutter."),

        // Меню (Абсолютные ссылки)
        const SemanticH2("Разделы сайта"),
        SemanticLink(text: "Обо мне", href: "$baseUrl/about"),
        SemanticLink(text: "Полезное", href: "$baseUrl/useful"),
        SemanticLink(text: "Проекты (Портфолио)", href: "$baseUrl/portfolio"),
        SemanticLink(text: "Контакты", href: "$baseUrl/contacts"),
        SemanticLink(text: "О сайте (PWA)", href: "$baseUrl/about-app"),

        // Статьи
        const SemanticH2("Истории из путешествий"),

        SemanticH3(srilankaTitle),
        const SemanticP(srilankaDescription),
        SemanticLink(text: "Читать статью", href: "$baseUrl/sri-lanka"),

        SemanticH3(jordanTitle),
        const SemanticP(jordanDescription),
        SemanticLink(text: "Читать статью", href: "$baseUrl/jordan"),

        SemanticH3(moroccoTitle),
        const SemanticP(moroccoDescription),
        SemanticLink(text: "Читать статью", href: "$baseUrl/marocco"),

        SemanticH3(georgiaMountains1Title),
        const SemanticP(georgiaMountains1Description),
        SemanticLink(text: "Читать статью", href: "$baseUrl/georgia-part1"),

        SemanticH3(georgiaMountains2Title),
        const SemanticP(georgiaMountains2Description),
        SemanticLink(
            text: "Читать статью",
            href: underConstructionUrl(georgiaMountains2Title)),

        SemanticH3(phuketTitle),
        const SemanticP(phuketDescription),
        SemanticLink(
            text: "Читать статью", href: underConstructionUrl(phuketTitle)),

        SemanticH3(vietnamTitle),
        const SemanticP(vietnamDescription),
        SemanticLink(
            text: "Читать статью", href: underConstructionUrl(vietnamTitle)),

        SemanticH3(malaysiaTitle),
        const SemanticP(malaysiaDescription),
        SemanticLink(
            text: "Читать статью", href: underConstructionUrl(malaysiaTitle)),

        SemanticH3(dubaiTitle),
        const SemanticP(dubaiDescription),
        SemanticLink(
            text: "Читать статью", href: underConstructionUrl(dubaiTitle)),

        SemanticH3(turkeyTitle),
        const SemanticP(turkeyDescription),
        SemanticLink(
            text: "Читать статью", href: underConstructionUrl(turkeyTitle)),

        // Футер
        const SemanticH2("Другое"),
        SemanticLink(text: "Игра FlutterSnake", href: "$baseUrl/fluttersnake"),
        SemanticLink(
            text: "Игра Wordle", href: "https://wordle.shastovsky.com/"),
        SemanticLink(text: "Правовая информация", href: "$baseUrl/copyright"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // <<< УСЛОВНЫЙ РЕНДЕРИНГ >>>
    if (_isPrerendering) {
      return Material(
          child: SingleChildScrollView(child: _buildPrerenderContent()));
    }

    final isMobile = MediaQuery.of(context).size.width < 800;

    // --- ВАШ ОРИГИНАЛЬНЫЙ КОД БЕЗ ИЗМЕНЕНИЙ ---
    return Scaffold(
        drawer: isMobile ? buildAppDrawer(context) : null,
        //backgroundColor: const Color.fromARGB(255, 255, 255, 255),// Убираем, чтобы использовать тему
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(isMobile ? 65 : 110),
          child: const MinimalMenuBar(),
        ),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Привет, я Даниил!",
                      style: headlineTextStyle(context).copyWith(fontSize: 26),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Это мой блог о путешествиях, работе и жизни в разных точках мира. Тут я делюсь своими историями, фотографиями и полезными материалами, которые помогают мне в работе.\n\n "
                      "Ниже можно найти последние посты из поездок.",
                      style: subtitleTextStyle(context).copyWith(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    IconButton(
                      icon: const Icon(Icons.arrow_downward, size: 36),
                      onPressed: () {
                        _scrollController.animateTo(
                          MediaQuery.of(context).size.height * 0.8,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverList.list(
              children: [
                // <<< НОВЫЙ ПОСТ: ШРИ-ЛАНКА >>>
                ListItem(
                  imageUrl: "assets/images/sri_banner_thumb.webp",
                  title: srilankaTitle,
                  description:
                      Text(srilankaDescription, style: bodyTextStyle(context)),
                  onReadMore: () =>
                      Navigator.pushNamed(context, '/${PostSriLankaPage.name}'),
                ),
                divider(context),
                // Иордания
                ListItem(
                  imageUrl: "assets/images/jordan/jordan-banner.webp",
                  title: jordanTitle,
                  description:
                      Text(jordanDescription, style: bodyTextStyle(context)),
                  onReadMore: () =>
                      Navigator.pushNamed(context, '/${PostJordanPage.name}'),
                ),
                divider(context),
                // Марокко
                ListItem(
                  imageUrl: "assets/images/me_sachara_desert.webp",
                  title: moroccoTitle,
                  onReadMore: () =>
                      Navigator.pushNamed(context, '/${PostPage.name}'),
                  description: RichText(
                    text: TextSpan(
                      style: bodyTextStyle(context),
                      children: <TextSpan>[
                        const TextSpan(
                          text:
                              "История о том, как я потерялся в лабиринте улиц Марокко. Ароматы специй, крики зазывал, скрытые риады — и уроки таксистов, которые подарила мне эта страна. ",
                        ),
                        TextSpan(
                          text: 'Внутри статьи можно найти ПОДАРОК! 🎁',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrangeAccent.shade400,
                          ),
                        ),
                        const TextSpan(text: ' […]'),
                      ],
                    ),
                  ),
                ),
                divider(context),

                // <<< 2. ПОСТ ПРО ГРУЗИЮ (ЧАСТЬ 1) ПЕРЕМЕЩЕН СЮДА >>>
                ListItem(
                  imageUrl: "assets/images/georgia_mountains.webp",
                  title: georgiaMountains1Title,
                  description: Text(georgiaMountains1Description,
                      style: bodyTextStyle(context)),
                  // <<< 3. ССЫЛКА ВЕДЕТ НА НОВУЮ СТРАНИЦУ >>>
                  onReadMore: () => Navigator.pushNamed(
                    context,
                    '/${PostGeorgiaPage.name}',
                  ),
                ),
                divider(context),

                // Малайзия
                ListItem(
                  imageUrl: "assets/images/kuala_lumpur.webp",
                  title: malaysiaTitle,
                  description:
                      Text(malaysiaDescription, style: bodyTextStyle(context)),
                  onReadMore: () => Navigator.pushNamed(
                    context,
                    '/${PageUnderConstruction.name}',
                    arguments: {'title': malaysiaTitle},
                  ),
                ),
                divider(context),

                // Дубай
                ListItem(
                  imageUrl: "assets/images/abu_dhabi.webp",
                  title: dubaiTitle,
                  description:
                      Text(dubaiDescription, style: bodyTextStyle(context)),
                  onReadMore: () => Navigator.pushNamed(
                    context,
                    '/${PageUnderConstruction.name}',
                    arguments: {'title': dubaiTitle},
                  ),
                ),
                divider(context),

                // Турция
                ListItem(
                  imageUrl: "assets/images/me_istambul.webp",
                  title: turkeyTitle,
                  description:
                      Text(turkeyDescription, style: bodyTextStyle(context)),
                  onReadMore: () => Navigator.pushNamed(
                    context,
                    '/${PageUnderConstruction.name}',
                    arguments: {'title': turkeyTitle},
                  ),
                ),
                divider(context),

                // Вьетнам
                ListItem(
                  imageUrl: "assets/images/vietnam_beach.webp",
                  title: vietnamTitle,
                  description:
                      Text(vietnamDescription, style: bodyTextStyle(context)),
                  onReadMore: () => Navigator.pushNamed(
                    context,
                    '/${PageUnderConstruction.name}',
                    arguments: {'title': vietnamTitle},
                  ),
                ),
                divider(context),

                // Пхукет
                ListItem(
                  imageUrl: "assets/images/me_similan_island_colored.webp",
                  title: phuketTitle,
                  description:
                      Text(phuketDescription, style: bodyTextStyle(context)),
                  onReadMore: () => Navigator.pushNamed(
                    context,
                    '/${PageUnderConstruction.name}',
                    arguments: {'title': phuketTitle},
                  ),
                ),
                divider(context),

                // Грузия 2 (заглушка)
                ListItem(
                  imageUrl: "assets/images/me_georgia_mountains_2.webp",
                  title: georgiaMountains2Title,
                  description: Text(georgiaMountains2Description,
                      style: bodyTextStyle(context)),
                  onReadMore: () => Navigator.pushNamed(
                    context,
                    '/${PageUnderConstruction.name}',
                    arguments: {'title': georgiaMountains2Title},
                  ),
                ),
                divider(context),

                const SizedBox(height: 80),
              ].toMaxWidth(),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: MaxWidthBox(maxWidth: 1200, child: Container()),
            ),
            ...[
              divider(context),
              const Footer(),
            ].toMaxWidthSliver(),
          ],
        ));
  }
}
