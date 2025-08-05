import 'package:flutter/material.dart';
import 'package:minimal/components/components.dart';
import 'package:minimal/utils/max_width_extension.dart';
import 'package:responsive_framework/responsive_framework.dart';

// TODO Replace with object model.
const String listItemTitleText =
    "МАРОККО: Заблудиться, чтобы найти себя в сердце пустоты";
const String listItemPreviewText =
    "История о том, как я потерялся в лабиринте улиц Марокко. Ароматы специй, крики зазывал, скрытые риады — и уроки таксистов, которые подарила мне эта страна. […]";
const String listItemTitleText1 = "ПХУКЕТ - НЕ ТОЛЬКО ПЛЯЖИ";
const String listItemPreviewText1 =
    "Да, пляжи Пхукета великолепны. Но эта статья — о том, как сойти с протоптанной тропы. Аренда байка, поиск нетуристических водопадов, уединенные бухты и мангровые заросли — мой гид по другому Пхукету […]";

class ListPage extends StatelessWidget {
  static const String name = 'list';

  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      // фиксированный AppBar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
            ResponsiveBreakpoints.of(context).smallerThan(TABLET) ? 60 : 410),
        child: const MinimalMenuBar(),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList.list(
            children: [
              // const MinimalMenuBar(),
              const ListItem(
                  imageUrl: "assets/images/me_sachara_desert.jpg",
                  title: listItemTitleText,
                  description: listItemPreviewText),
              divider,
              const ListItem(
                  imageUrl: "assets/images/vietnam_beach.jpg",
                  title: listItemTitleText1,
                  description: listItemPreviewText1),
              divider,
              const ListItem(
                  imageUrl: "assets/images/georgia_mountains.jpg",
                  title: listItemTitleText,
                  description: listItemPreviewText),
              divider,
              const ListItem(
                  imageUrl: "assets/images/me_similan_island_colored.jpg",
                  title: listItemTitleText1,
                  description: listItemPreviewText1),
              divider,
              const ListItem(
                  imageUrl: "assets/images/marocco_canyons.jpg",
                  title: listItemTitleText,
                  description: listItemPreviewText),
              divider,
              const ListItem(
                  imageUrl: "assets/images/me_georgia_mountains 2.jpg",
                  title: listItemTitleText1,
                  description: listItemPreviewText1),
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
