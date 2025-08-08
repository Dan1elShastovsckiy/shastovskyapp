import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/pages/page_post.dart';
import 'package:minimal/pages/page_under_construction.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart';

// Константы для постов
const String moroccoTitle =
    "МАРОККО: Заблудиться, чтобы найти себя в сердце пустоты";
const String moroccoDescription =
    "История о том, как я потерялся в лабиринте улиц Марокко. Ароматы специй, крики зазывал, скрытые риады — и уроки таксистов, которые подарила мне эта страна. […]";

const String phuketTitle = "ПХУКЕТ - НЕ ТОЛЬКО ПЛЯЖИ";
const String phuketDescription =
    "Да, пляжи Пхукета великолепны. Но эта статья — о том, как сойти с протоптанной тропы. Аренда байка, поиск нетуристических водопадов, уединенные бухты и мангровые заросли — мой гид по другому Пхукету […]";

// Новые константы для постов
const String vietnamTitle = "ВЬЕТНАМ: Бирюзовые берега Дананга";
const String vietnamDescription =
    "Солнечные пляжи, морепродукты и атмосфера приморского города — как провести идеальный день во Вьетнаме […]";

const String georgiaMountains1Title = "ГРУЗИЯ: Из Батуми в Кутаиси через горы";
const String georgiaMountains1Description =
    "Первое знакомство с Кавказом: серпантины, горные деревушки и гостеприимство местных жителей […]";

const String georgiaMountains2Title = "ГРУЗИЯ: От Тбилиси к границе с Россией";
const String georgiaMountains2Description =
    "Путешествие по Военно-Грузинской дороге: древние крепости, горные перевалы и виды на Кавказский хребет […]";

class ListPage extends StatelessWidget {
  static const String name = 'list';
  final ScrollController _scrollController = ScrollController();

  ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      drawer: isMobile ? buildAppDrawer(context) : null,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 410),
        child: const MinimalMenuBar(),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Привет, я Даниил!",
                    style: headlineTextStyle.copyWith(fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Это мой блог о путешествиях, работе и жизни в разных точках мира. Тут я делюсь своими историями, фотографиями и полезными материалами, которые помогают мне в работе.\n\n "
                    "Ниже можно найти последние посты из поездок.",
                    style: subtitleTextStyle.copyWith(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  IconButton(
                    icon: const Icon(Icons.arrow_downward, size: 36),
                    onPressed: () {
                      _scrollController.animateTo(
                        MediaQuery.of(context).size.height * 0.6,
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
              // Марокко (пустыня) - реальный пост
              ListItem(
                imageUrl: "assets/images/me_sachara_desert.jpg",
                title: moroccoTitle,
                description: moroccoDescription,
                onReadMore: () => Navigator.pushNamed(context, PostPage.name),
              ),
              divider,
              // Вьетнам (пляж) - заглушка
              ListItem(
                imageUrl: "assets/images/vietnam_beach.jpg",
                title: vietnamTitle,
                description: vietnamDescription,
                onReadMore: () => Navigator.pushNamed(
                  context,
                  PageUnderConstruction.name,
                  arguments: {'title': vietnamTitle},
                ),
              ),
              divider,
              // Грузия (горы 1) - заглушка
              ListItem(
                imageUrl: "assets/images/georgia_mountains.jpg",
                title: georgiaMountains1Title,
                description: georgiaMountains1Description,
                onReadMore: () => Navigator.pushNamed(
                  context,
                  PageUnderConstruction.name,
                  arguments: {'title': georgiaMountains1Title},
                ),
              ),
              divider,
              // Пхукет (остров) - заглушка
              ListItem(
                imageUrl: "assets/images/me_similan_island_colored.jpg",
                title: phuketTitle,
                description: phuketDescription,
                onReadMore: () => Navigator.pushNamed(
                  context,
                  PageUnderConstruction.name,
                  arguments: {'title': phuketTitle},
                ),
              ),
              divider,
              // Грузия (горы 2) - заглушка
              ListItem(
                imageUrl: "assets/images/me_georgia_mountains 2.jpg",
                title: georgiaMountains2Title,
                description: georgiaMountains2Description,
                onReadMore: () => Navigator.pushNamed(
                  context,
                  PageUnderConstruction.name,
                  arguments: {'title': georgiaMountains2Title},
                ),
              ),
              divider,
              Container(
                padding: const EdgeInsets.symmetric(vertical: 80),
                child: const ListNavigation(),
              ),
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
      ),
    );
  }
}
