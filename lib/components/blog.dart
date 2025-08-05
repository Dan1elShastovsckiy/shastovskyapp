import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:minimal/components/color.dart";
import 'package:minimal/components/spacing.dart';
import 'package:minimal/components/text.dart';
import 'package:minimal/components/typography.dart';
import 'package:minimal/pages/pages.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ImageWrapper extends StatelessWidget {
  final String image;

  const ImageWrapper({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    //TODO Listen to inherited widget width updates.
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      child: Image.asset(
        image,
        width: width,
        height: width / 1.618,
        fit: BoxFit.cover,
      ),
    );
  }
}

class TagWrapper extends StatelessWidget {
  final List<Tag> tags;

  const TagWrapper({super.key, this.tags = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: paddingBottom24,
        child: Wrap(
          spacing: 8,
          runSpacing: 0,
          children: [...tags],
        ));
  }
}

class Tag extends StatelessWidget {
  final String tag;

  const Tag({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {},
      fillColor: const Color(0xFF242424),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 0,
      hoverElevation: 0,
      hoverColor: const Color(0xFFC7C7C7),
      highlightElevation: 0,
      focusElevation: 0,
      child: Text(
        tag,
        style: GoogleFonts.openSans(color: Colors.white, fontSize: 14),
      ),
    );
  }
}

class ReadMoreButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ReadMoreButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all<Color>(textPrimary),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.focused) ||
              states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.pressed)) {
            return const BorderSide(color: textPrimary, width: 2);
          }

          return const BorderSide(color: textPrimary, width: 2);
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.focused) ||
              states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.pressed)) {
            return Colors.white;
          }

          return textPrimary;
        }),
        textStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
          if (states.contains(WidgetState.focused) ||
              states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.pressed)) {
            return GoogleFonts.montserrat(
              textStyle: const TextStyle(
                  fontSize: 14, color: Colors.white, letterSpacing: 1),
            );
          }

          return GoogleFonts.montserrat(
            textStyle: const TextStyle(
                fontSize: 14, color: textPrimary, letterSpacing: 1),
          );
        }),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16)),
      ),
      child: const Text(
        "ЧИТАТЬ ДАЛЕЕ",
      ),
    );
  }
}

const Widget divider = Divider(color: Color(0xFFEEEEEE), thickness: 1);
Widget dividerSmall = Container(
  width: 40,
  decoration: const BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: Color(0xFFA0A0A0),
        width: 1,
      ),
    ),
  ),
);

List<Widget> authorSection({String? imageUrl, String? name, String? bio}) {
  return [
    divider,
    Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Row(
        children: [
          if (imageUrl != null)
            Container(
              margin: const EdgeInsets.only(right: 25),
              child: Material(
                shape: const CircleBorder(),
                clipBehavior: Clip.hardEdge,
                color: Colors.transparent,
                child: Image.asset(
                  imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          Expanded(
            child: Column(
              children: [
                if (name != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextHeadlineSecondary(text: name),
                  ),
                if (bio != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      bio,
                      style: bodyTextStyle,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
    divider,
  ];
}

class PostNavigation extends StatelessWidget {
  const PostNavigation({super.key});

  // TODO Get PostID from Global Routing Singleton.
  // Example: String currentPage = RouteController.of(context).currentPage;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.keyboard_arrow_left,
              size: 25,
              color: textSecondary,
            ),
            Text("ПРЕДЫДУЩИЙ ПОСТ", style: buttonTextStyle),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            Text("СЛЕДУЮЩИЙ ПОСТ", style: buttonTextStyle),
            const Icon(
              Icons.keyboard_arrow_right,
              size: 25,
              color: textSecondary,
            ),
          ],
        )
      ],
    );
  }
}

class ListNavigation extends StatelessWidget {
  const ListNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.keyboard_arrow_left,
              size: 25,
              color: textSecondary,
            ),
            if (ResponsiveBreakpoints.of(context).largerThan(MOBILE))
              Text("БОЛЕЕ НОВЫЕ ПОСТЫ", style: buttonTextStyle),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            if (ResponsiveBreakpoints.of(context).largerThan(MOBILE))
              Text("СТАРЫЕ ПОСТЫ", style: buttonTextStyle),
            const Icon(
              Icons.keyboard_arrow_right,
              size: 25,
              color: textSecondary,
            ),
          ],
        )
      ],
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  // TODO Add additional footer components (i.e. about, links, logos).
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: const Align(
        alignment: Alignment.centerRight,
        child: TextBody(text: "Copyright © 2025"),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  // TODO replace with Post item model.
  final String title;
  final String? imageUrl;
  final String? description;

  const ListItem(
      {super.key, required this.title, this.imageUrl, this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (imageUrl != null)
          ImageWrapper(
            image: imageUrl!,
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: marginBottom12,
            child: Text(
              title,
              style: headlineTextStyle,
            ),
          ),
        ),
        if (description != null)
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: marginBottom12,
              child: Text(
                description!,
                style: bodyTextStyle,
              ),
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: marginBottom24,
            child: ReadMoreButton(
              onPressed: () => Navigator.pushNamed(context, PostPage.name),
            ),
          ),
        ),
      ],
    );
  }
}

// ignore: slash_for_doc_comments
/**
 * Menu/Navigation Bar
 *
 * A top menu bar with a text or image logo and
 * navigation links. Navigation links collapse into
 * a hamburger menu on screens smaller than 400px.
 */
class MinimalMenuBar extends StatefulWidget {
  const MinimalMenuBar({super.key});

  @override
  State<MinimalMenuBar> createState() => _MinimalMenuBarState();
}

class _MinimalMenuBarState extends State<MinimalMenuBar> {
  bool isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Material(
      elevation: 0,
      color: const Color(0xFFF5F5F5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Верхняя панель
          Container(
            margin: EdgeInsets.symmetric(
              vertical: isMobile ? 10 : 20,
              horizontal: isMobile ? 12 : 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Логотип остается без изменений
                InkWell(
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    Navigator.defaultRouteName,
                    ModalRoute.withName(Navigator.defaultRouteName),
                  ),
                  child: Text(
                    "SHASTOVSKY.",
                    style: GoogleFonts.montserrat(
                      color: textPrimary,
                      fontSize: isMobile ? 20 : 24,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Меню
                if (isMobile)
                  IconButton(
                    icon: Icon(
                      isMenuOpen ? Icons.close : Icons.menu,
                      size: 28,
                    ),
                    onPressed: () => setState(() => isMenuOpen = !isMenuOpen),
                  )
                else
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: _buildMenuItems(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Мобильное меню
          if (isMobile && isMenuOpen)
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _buildMenuItems().map((item) {
                  return Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFEEEEEE),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Center(child: item),
                    ),
                  );
                }).toList(),
              ),
            ),
          Container(
            height: 1,
            color: const Color(0xFFEEEEEE),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMenuItems() {
    final isMobile = MediaQuery.of(context).size.width < 800;
    final menuStyle = TextStyle(
      fontSize: isMobile ? 16 : 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.5,
      color: textPrimary,
    );

    final items = [
      TextButton(
        onPressed: () {
          if (isMobile) setState(() => isMenuOpen = false);
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            (route) => false,
          );
        },
        style: menuButtonStyle,
        child: Text("ГЛАВНАЯ", style: menuStyle),
      ),
      TextButton(
        onPressed: () {
          if (isMobile) setState(() => isMenuOpen = false);
          Navigator.pushNamed(context, PortfolioPage.name);
        },
        style: menuButtonStyle,
        child: Text("ПОРТФОЛИО", style: menuStyle),
      ),
      TextButton(
        onPressed: () {
          if (isMobile) setState(() => isMenuOpen = false);
          Navigator.pushNamed(context, TypographyPage.name);
        },
        style: menuButtonStyle,
        child: Text("ОБ ЭТОМ САЙТЕ", style: menuStyle),
      ),
      TextButton(
        onPressed: () {
          if (isMobile) setState(() => isMenuOpen = false);
          Navigator.pushNamed(context, AboutPage.name);
        },
        style: menuButtonStyle,
        child: Text("ОБО МНЕ", style: menuStyle),
      ),
      TextButton(
        onPressed: () {
          if (isMobile) setState(() => isMenuOpen = false);
          Navigator.pushNamed(context, ContactsPage.name);
        },
        style: menuButtonStyle,
        child: Text("КОНТАКТЫ", style: menuStyle),
      ),
    ];

    return items;
  }
}
