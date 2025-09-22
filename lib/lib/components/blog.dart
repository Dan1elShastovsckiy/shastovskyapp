// lib/components/blog.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal/components/color.dart';
import 'package:minimal/components/spacing.dart';
import 'package:minimal/components/text.dart';
import 'package:minimal/components/typography.dart';
import 'package:minimal/pages/pages.dart';

// --- ВСЕ ОБЩИЕ КОМПОНЕНТЫ (без изменений) ---

class ImageWrapper extends StatelessWidget {
  final String image;
  // Параметр height больше не нужен, так как высота будет динамической
  const ImageWrapper({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    // Эта логика для кэширования остается, она полезна
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth > 800 ? 1200 : 800;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      // Мы убираем жесткий AspectRatio
      child: Image.asset(
        image,
        // BoxFit.fitWidth растягивает картинку по ширине,
        // а высоту подбирает автоматически, сохраняя пропорции.
        fit: BoxFit.fitWidth,
        cacheWidth: (maxWidth * devicePixelRatio).toInt(),
        // cacheHeight убираем, так как высота неизвестна заранее

        // Плейсхолдер и обработчик ошибок оставляем, они полезны
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) {
            return child;
          }
          // Плейсхолдер будет просто серой зоной без жесткой высоты
          return Container(
            height:
                200, // Можно задать примерную высоту, чтобы не было "скачка"
            color: Colors.grey[200],
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Text('Ошибка загрузки изображения'));
        },
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
        child: Wrap(spacing: 8, runSpacing: 0, children: [...tags]));
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
          return const BorderSide(color: textPrimary, width: 2);
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.hovered)) {
            return Colors.white;
          }
          return textPrimary;
        }),
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.hovered)) {
            return textPrimary;
          }
          return Colors.transparent;
        }),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16)),
      ),
      child: const Text("ЧИТАТЬ ДАЛЕЕ"),
    );
  }
}

const Widget divider = Divider(color: Color(0xFFEEEEEE), thickness: 1);
Widget dividerSmall = Container(
  width: 40,
  decoration: const BoxDecoration(
    border: Border(bottom: BorderSide(color: Color(0xFFA0A0A0), width: 1)),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (name != null) Text(name, style: headlineSecondaryTextStyle),
                if (bio != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(bio, style: bodyTextStyle),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  ];
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
  final VoidCallback onReadMore;

  const ListItem({
    super.key,
    required this.title,
    this.imageUrl,
    this.description,
    required this.onReadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (imageUrl != null) ImageWrapper(image: imageUrl!),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: marginBottom12,
            child: Text(title, style: headlineTextStyle),
          ),
        ),
        if (description != null)
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: marginBottom12,
              child: description,
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: marginBottom24,
            child: ReadMoreButton(onPressed: onReadMore),
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
    return Material(
      color: const Color(0xFFF5F5F5),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: isMobile ? 0 : 10, horizontal: isMobile ? 12 : 16),
        decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
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
                  context, '/', (route) => false),
              child: Padding(
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
    return [
      _buildMenuItem(
          context, "ГЛАВНАЯ", () => Navigator.pushNamed(context, '/')),
      const _DesktopDropdownMenuItem(
        title: "ПОЛЕЗНОЕ",
        items: {
          "Разработка": '/${UsefulDevPage.name}',
          "SEO": '/${UsefulSeoPage.name}',
        },
      ),
      _buildMenuItem(context, "ОБО МНЕ",
          () => Navigator.pushNamed(context, '/${AboutPage.name}')),
      _buildMenuItem(context, "ПОРТФОЛИО",
          () => Navigator.pushNamed(context, '/${PortfolioPage.name}')),
      _buildMenuItem(context, "ОБ ЭТОМ САЙТЕ",
          () => Navigator.pushNamed(context, '/${TypographyPage.name}')),
      _buildMenuItem(context, "КОНТАКТЫ",
          () => Navigator.pushNamed(context, '/${ContactsPage.name}')),
    ];
  }

  // <<< ИЗМЕНЕНИЕ №1: Виджет _buildMenuItem теперь использует InkWell >>>
  Widget _buildMenuItem(
      BuildContext context, String text, VoidCallback onPressed) {
    final menuStyle = GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.5,
      color: textPrimary,
    );
    // Используем InkWell для кликабельности без визуальных эффектов по умолчанию
    return InkWell(
      onTap: onPressed,
      // Отключаем все эффекты наведения и нажатия
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Text(
          text,
          style: menuStyle,
        ),
      ),
    );
  }
}

class _DesktopDropdownMenuItem extends StatefulWidget {
  final String title;
  final Map<String, String> items;
  const _DesktopDropdownMenuItem({required this.title, required this.items});

  @override
  _DesktopDropdownMenuItemState createState() =>
      _DesktopDropdownMenuItemState();
}

class _DesktopDropdownMenuItemState extends State<_DesktopDropdownMenuItem> {
  final _portalController = OverlayPortalController();
  final _link = LayerLink();

  @override
  Widget build(BuildContext context) {
    final menuStyle = GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.5,
      color: textPrimary,
    );

    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _portalController,
        overlayChildBuilder: (BuildContext context) {
          return CompositedTransformFollower(
            link: _link,
            targetAnchor: Alignment.bottomLeft,
            child: Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5).withAlpha(250),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.items.entries.map((entry) {
                      return SizedBox(
                        width: double.infinity,
                        // <<< ИЗМЕНЕНИЕ №2: Кнопки внутри выпадающего списка остаются TextButton для стандартного поведения >>>
                        child: TextButton(
                          onPressed: () {
                            _portalController.hide();
                            Navigator.pushNamed(context, entry.value);
                          },
                          style: TextButton.styleFrom(
                            alignment: Alignment.centerLeft,
                            foregroundColor: textPrimary,
                            textStyle: menuStyle.copyWith(
                                fontWeight: FontWeight.normal),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                          ),
                          child: Text(entry.key),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          );
        },
        // <<< ИЗМЕНЕНИЕ №3: Основная кнопка выпадающего меню теперь тоже InkWell >>>
        child: InkWell(
          onTap: () => _portalController.toggle(),
          // Отключаем все эффекты
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.title, style: menuStyle),
                const SizedBox(width: 4), // Небольшой отступ для иконки
                Icon(Icons.arrow_drop_down,
                    size: 20, color: textPrimary.withAlpha(178)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ... Остальной код файла (Drawer, Breadcrumbs) остается без изменений ...

Drawer buildAppDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: Colors.white,
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(color: Color(0xFFF5F5F5)),
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
            Navigator.pushNamed(context, '/');
          },
        ),
        ExpansionTile(
          title: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/${UsefulPage.name}');
            },
            child: const Text('ПОЛЕЗНОЕ'),
          ),
          childrenPadding: const EdgeInsets.only(left: 16),
          children: [
            ListTile(
              title: const Text('Разработка'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/${UsefulDevPage.name}');
              },
            ),
            ListTile(
              title: const Text('SEO'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/${UsefulSeoPage.name}');
              },
            ),
          ],
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

class BreadcrumbItem {
  final String text;
  final String? routeName;

  const BreadcrumbItem({required this.text, this.routeName});
}

class Breadcrumbs extends StatelessWidget {
  final List<BreadcrumbItem> items;
  const Breadcrumbs({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    // Стиль, который имитирует TextBodySecondary
    final breadcrumbStyle = bodyTextStyle.copyWith(color: textSecondary);

    final List<InlineSpan> spans = [];
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      if (item.routeName != null) {
        // Кликабельная часть
        spans.add(
          TextSpan(
            text: item.text,
            style: breadcrumbStyle.copyWith(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushNamed(context, item.routeName!);
              },
          ),
        );
      } else {
        // Некликабельная (последняя) часть
        spans.add(
          TextSpan(
            text: item.text,
            style: breadcrumbStyle,
          ),
        );
      }

      // Разделитель
      if (i < items.length - 1) {
        spans.add(
          TextSpan(
            text: '  /  ',
            style: breadcrumbStyle,
          ),
        );
      }
    }

    return RichText(
      text: TextSpan(
        children: spans,
      ),
    );
  }
}
