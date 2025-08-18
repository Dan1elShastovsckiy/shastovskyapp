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
  final double? height;

  const ImageWrapper({super.key, required this.image, this.height});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final maxWidth = width > 800 ? 1200 : 800;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.asset(
          image,
          fit: BoxFit.cover,
          cacheWidth: (maxWidth * devicePixelRatio).toInt(),
          cacheHeight: ((maxWidth * 9 / 16) * devicePixelRatio).toInt(),
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded || frame != null) {
              return child;
            }
            return Container(
              color: Colors.grey[200],
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Text('Ошибка загрузки изображения',
                  style: TextStyle(color: Colors.white)),
            );
          },
        ),
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
              Text("НОВЫЕ ПОСТЫ", style: buttonTextStyle),
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
  final String title;
  final String? imageUrl;
  final Widget? description;
  final double? imageHeight;
  final VoidCallback onReadMore; // Добавляем callback

  const ListItem({
    super.key,
    required this.title,
    this.imageUrl,
    this.description,
    this.imageHeight,
    required this.onReadMore, // Обязательный параметр
  });

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
              child: description!, // <-- Теперь просто вставляем виджет
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: marginBottom24,
            child: ReadMoreButton(
              onPressed: onReadMore, // Используем переданный callback
            ),
          ),
        ),
      ],
    );
  }
}

class MinimalMenuBar extends StatelessWidget {
  const MinimalMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    // ОПТИМИЗАЦИЯ: Виджет переделан для исправления бага на мобильных.
    // Вместо Column используется Container с BoxDecoration для нижней границы.
    return Material(
      color: const Color(0xFFF5F5F5),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: isMobile ? 0 : 10, horizontal: isMobile ? 12 : 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                context,
                Navigator.defaultRouteName,
                ModalRoute.withName(Navigator.defaultRouteName),
              ),
              child: Padding(
                // Добавлен вертикальный padding для логотипа, чтобы он не прилипал к краям
                padding: const EdgeInsets.symmetric(vertical: 12.0),
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
            ),
            if (isMobile)
              IconButton(
                icon: const Icon(Icons.menu, size: 28),
                onPressed: () => Scaffold.of(context).openDrawer(),
              )
            else
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: _buildMenuItems(context),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    final menuStyle = GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.5,
      color: textPrimary,
    );
    final menuButtonStyle = ButtonStyle(
      overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
      foregroundColor: WidgetStateProperty.all<Color>(textPrimary),
      textStyle: WidgetStateProperty.all<TextStyle>(menuStyle),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
    );

    return [
      // ИСПРАВЛЕНИЕ: Используем простой pushNamed для ГЛАВНОЙ
      _buildMenuItem(
        "ГЛАВНАЯ",
        menuStyle,
        menuButtonStyle,
        () => Navigator.pushNamed(context, '/'), // Просто переходим на '/'
      ),
      _buildMenuItem(
        "ОБО МНЕ",
        menuStyle,
        menuButtonStyle,
        // ИСПРАВЛЕНИЕ: Добавляем слеш к имени маршрута
        () => Navigator.pushNamed(context, '/${AboutPage.name}'),
      ),
      _buildMenuItem(
        "ПОРТФОЛИО",
        menuStyle,
        menuButtonStyle,
        () => Navigator.pushNamed(context, '/${PortfolioPage.name}'),
      ),
      _buildMenuItem(
        "ОБ ЭТОМ САЙТЕ",
        menuStyle,
        menuButtonStyle,
        () => Navigator.pushNamed(context, '/${TypographyPage.name}'),
      ),
      _buildMenuItem(
        "КОНТАКТЫ",
        menuStyle,
        menuButtonStyle,
        () => Navigator.pushNamed(context, '/${ContactsPage.name}'),
      ),
    ];
  }

  Widget _buildMenuItem(String text, TextStyle style, ButtonStyle buttonStyle,
      VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: Text(text, style: style),
    );
  }
}

// в конец файла blog.dart
Drawer buildAppDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: Colors.white,
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
            Navigator.pop(context); // Сначала закрываем Drawer
            Navigator.pushNamed(context, '/'); // Потом переходим
          },
        ),
        ListTile(
          title: const Text('ОБО МНЕ'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/${AboutPage.name}');
          },
        ),
        ListTile(
          title: const Text('ПОРТФОЛИО'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/${PortfolioPage.name}');
          },
        ),
        ListTile(
          title: const Text('ОБ ЭТОМ САЙТЕ'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/${TypographyPage.name}');
          },
        ),
        ListTile(
          title: const Text('КОНТАКТЫ'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/${ContactsPage.name}');
          },
        ),
      ],
    ),
  );
}
