import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/pages/page_georgia_post.dart'; // <<< 1. ИМПОРТ НОВОЙ СТРАНИЦЫ
import 'package:minimal/pages/page_post.dart';
import 'package:minimal/pages/page_under_construction.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart';

// Константы для постов
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

  final List<String> _pageImages = [
    "assets/images/me_sachara_desert.webp",
    "assets/images/georgia_mountains.webp", // <-- Картинка для Грузии (остается)
    "assets/images/kuala_lumpur.jpg",
    "assets/images/abu_dhabi.jpg",
    "assets/images/me_istambul.jpg",
    "assets/images/vietnam_beach.webp",
    "assets/images/me_similan_island_colored.webp",
    "assets/images/me_georgia_mountains 2.webp",
  ];

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

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
        drawer: isMobile ? buildAppDrawer(context) : null,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                      style: headlineTextStyle.copyWith(fontSize: 26),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Это мой блог о путешествиях, работе и жизни в разных точках мира. Тут я делюсь своими историями, фотографиями и полезными материалами, которые помогают мне в работе.\n\n "
                      "Ниже можно найти последние посты из поездок.",
                      style: subtitleTextStyle.copyWith(fontSize: 16),
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
                // Марокко
                ListItem(
                  imageUrl: "assets/images/me_sachara_desert.webp",
                  title: moroccoTitle,
                  onReadMore: () =>
                      Navigator.pushNamed(context, '/${PostPage.name}'),
                  description: RichText(
                    text: TextSpan(
                      style: bodyTextStyle,
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
                divider,

                // <<< 2. ПОСТ ПРО ГРУЗИЮ (ЧАСТЬ 1) ПЕРЕМЕЩЕН СЮДА >>>
                ListItem(
                  imageUrl: "assets/images/georgia_mountains.webp",
                  title: georgiaMountains1Title,
                  description:
                      Text(georgiaMountains1Description, style: bodyTextStyle),
                  // <<< 3. ССЫЛКА ВЕДЕТ НА НОВУЮ СТРАНИЦУ >>>
                  onReadMore: () => Navigator.pushNamed(
                    context,
                    '/${PostGeorgiaPage.name}',
                  ),
                ),
                divider,

                // Малайзия
                ListItem(
                  imageUrl: "assets/images/kuala_lumpur.jpg",
                  title: malaysiaTitle,
                  description: Text(malaysiaDescription, style: bodyTextStyle),
                  onReadMore: () => Navigator.pushNamed(
                    context,
                    '/${PageUnderConstruction.name}',
                    arguments: {'title': malaysiaTitle},
                  ),
                ),
                divider,

                // Дубай
                ListItem(
                  imageUrl: "assets/images/abu_dhabi.jpg",
                  title: dubaiTitle,
                  description: Text(dubaiDescription, style: bodyTextStyle),
                  onReadMore: () => Navigator.pushNamed(
                    context,
                    '/${PageUnderConstruction.name}',
                    arguments: {'title': dubaiTitle},
                  ),
                ),
                divider,

                // Турция
                ListItem(
                  imageUrl: "assets/images/me_istambul.jpg",
                  title: turkeyTitle,
                  description: Text(turkeyDescription, style: bodyTextStyle),
                  onReadMore: () => Navigator.pushNamed(
                    context,
                    '/${PageUnderConstruction.name}',
                    arguments: {'title': turkeyTitle},
                  ),
                ),
                divider,

                // Вьетнам
                ListItem(
                  imageUrl: "assets/images/vietnam_beach.webp",
                  title: vietnamTitle,
                  description: Text(vietnamDescription, style: bodyTextStyle),
                  onReadMore: () => Navigator.pushNamed(
                    context,
                    '/${PageUnderConstruction.name}',
                    arguments: {'title': vietnamTitle},
                  ),
                ),
                divider,

                // Пхукет
                ListItem(
                  imageUrl: "assets/images/me_similan_island_colored.webp",
                  title: phuketTitle,
                  description: Text(phuketDescription, style: bodyTextStyle),
                  onReadMore: () => Navigator.pushNamed(
                    context,
                    '/${PageUnderConstruction.name}',
                    arguments: {'title': phuketTitle},
                  ),
                ),
                divider,

                // Грузия 2 (заглушка)
                ListItem(
                  imageUrl: "assets/images/me_georgia_mountains 2.webp",
                  title: georgiaMountains2Title,
                  description:
                      Text(georgiaMountains2Description, style: bodyTextStyle),
                  onReadMore: () => Navigator.pushNamed(
                    context,
                    '/${PageUnderConstruction.name}',
                    arguments: {'title': georgiaMountains2Title},
                  ),
                ),
                divider,

                const SizedBox(height: 80),
              ].toMaxWidth(),
            ),
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
        ));
  }
}