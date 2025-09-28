// lib/components/blog.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// <<< ШАГ 5.1: Импортируем провайдер для доступа к состоянию темы >>>
import 'package:minimal/components/theme_provider.dart';
import 'package:provider/provider.dart';
// <<< ШАГ 5.2: Больше не используем старые константы цветов напрямую >>>
// import 'package:minimal/components/color.dart';
import 'package:minimal/components/spacing.dart';
import 'package:minimal/components/text.dart';
import 'package:minimal/components/typography.dart';
import 'package:minimal/pages/pages.dart';

// --- Компоненты ImageWrapper, TagWrapper (без изменений, но с адаптацией цветов) ---

class ImageWrapper extends StatelessWidget {
  final String image;
  const ImageWrapper({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth > 800 ? 1200 : 800;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      child: Image.asset(
        image,
        fit: BoxFit.fitWidth,
        cacheWidth: (maxWidth * devicePixelRatio).toInt(),
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) {
            return child;
          }
          return Container(
            height: 200,
            // <<< ШАГ 5.3: Используем цвет из темы для плейсхолдера >>>
            color: Theme.of(context).colorScheme.surface,
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
      // <<< ШАГ 5.4: Адаптируем цвета тега для темной и светлой темы >>>
      fillColor: Theme.of(context).colorScheme.onSurface,
      hoverColor: Theme.of(context).colorScheme.secondary,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      focusElevation: 0,
      child: Text(
        tag,
        style: GoogleFonts.openSans(
            color: Theme.of(context).colorScheme.surface, fontSize: 14),
      ),
    );
  }
}

class ReadMoreButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ReadMoreButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // <<< ШАГ 5.5: Адаптируем цвета кнопки "Читать далее" >>>
    final theme = Theme.of(context);
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all<Color>(theme.colorScheme.primary),
        side: WidgetStateProperty.resolveWith((states) {
          return BorderSide(color: theme.colorScheme.primary, width: 2);
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.hovered)) {
            return theme.colorScheme.onPrimary;
          }
          return theme.colorScheme.primary;
        }),
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.hovered)) {
            return theme.colorScheme.primary;
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

// <<< ШАГ 5.6: Адаптируем цвета разделителей >>>
Widget divider(BuildContext context) =>
    Divider(color: Theme.of(context).dividerColor, thickness: 1);
Widget dividerSmall(BuildContext context) => Container(
      width: 40,
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: Theme.of(context).colorScheme.secondary, width: 1)),
      ),
    );

List<Widget> authorSection(
    {required BuildContext context,
    String? imageUrl,
    String? name,
    String? bio}) {
  // <<< ИСПРАВЛЕНИЕ: Переменная переписана в локальную функцию >>>
  void navigateToAbout() {
    Navigator.pushNamed(context, '/${AboutPage.name}');
  }

  return [
    // <<< ШАГ 5.7: Передаем context в виджет divider >>>
    divider(context),
    Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Row(
        children: [
          if (imageUrl != null)
            InkWell(
              onTap: navigateToAbout,
              customBorder: const CircleBorder(),
              child: Container(
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
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (name != null)
                  InkWell(
                    onTap: navigateToAbout,
                    // <<< ШАГ 5.8: Заменяем жестко заданные стили на стили из темы >>>
                    child:
                        Text(name, style: headlineSecondaryTextStyle(context)),
                  ),
                if (bio != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(bio, style: bodyTextStyle(context)),
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
            // <<< ШАГ 5.9: Заменяем жестко заданные стили на стили из темы >>>
            child: Text(title, style: headlineTextStyle(context)),
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
    // <<< ШАГ 5.10: Получаем доступ к провайдеру и теме >>>
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Material(
      // <<< ШАГ 5.11: Используем цвета из темы >>>
      color: theme.colorScheme.surface,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: isMobile ? 0 : 10, horizontal: isMobile ? 12 : 16),
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: theme.dividerColor, width: 1)),
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
                    // <<< ШАГ 5.12: Адаптируем цвет текста >>>
                    color: theme.colorScheme.onSurface,
                    fontSize: isMobile ? 20 : 24,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            if (isMobile)
              // <<< ШАГ 5.13: Добавляем переключатель темы для мобильной версии >>>
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      themeProvider.isDarkMode
                          ? Icons.wb_sunny_outlined
                          : Icons.nightlight_round,
                      size: 24,
                      color: theme.colorScheme.onSurface,
                    ),
                    onPressed: () {
                      themeProvider.toggleTheme(!themeProvider.isDarkMode);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.menu,
                        size: 28, color: theme.colorScheme.onSurface),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ],
              )
            else
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // <<< ШАГ 5.14: Добавляем переключатель темы для десктопной версии >>>
                      ..._buildMenuItems(context),
                      IconButton(
                        icon: Icon(
                          themeProvider.isDarkMode
                              ? Icons.wb_sunny_outlined
                              : Icons.nightlight_round,
                          color: theme.colorScheme.onSurface,
                        ),
                        onPressed: () {
                          themeProvider.toggleTheme(!themeProvider.isDarkMode);
                        },
                      ),
                    ],
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
          "Попробуй кодить": '/${TryCodingPage.name}', // <-- ДОБАВИТЬ
        },
      ),
      _buildMenuItem(context, "ОБО МНЕ",
          () => Navigator.pushNamed(context, '/${AboutPage.name}')),
      _buildMenuItem(context, "ПРОЕКТЫ",
          () => Navigator.pushNamed(context, '/${PortfolioPage.name}')),
      _buildMenuItem(context, "ОБ ЭТОМ САЙТЕ",
          () => Navigator.pushNamed(context, '/${TypographyPage.name}')),
      _buildMenuItem(context, "КОНТАКТЫ",
          () => Navigator.pushNamed(context, '/${ContactsPage.name}')),
    ];
  }

  Widget _buildMenuItem(
      BuildContext context, String text, VoidCallback onPressed) {
    // <<< ШАГ 5.15: Адаптируем цвет текста в пунктах меню >>>
    final menuStyle = GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.5,
      color: Theme.of(context).colorScheme.onSurface,
    );
    return InkWell(
      onTap: onPressed,
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
    // <<< ШАГ 5.16: Адаптируем цвета выпадающего меню >>>
    final theme = Theme.of(context);
    final menuStyle = GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.5,
      color: theme.colorScheme.onSurface,
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
                    color: theme.colorScheme.surface.withAlpha(250),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.items.entries.map((entry) {
                      return SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            _portalController.hide();
                            Navigator.pushNamed(context, entry.value);
                          },
                          style: TextButton.styleFrom(
                            alignment: Alignment.centerLeft,
                            foregroundColor: theme.colorScheme.onSurface,
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
        child: InkWell(
          onTap: () => _portalController.toggle(),
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.title, style: menuStyle),
                const SizedBox(width: 4),
                Icon(Icons.arrow_drop_down,
                    size: 20,
                    color: theme.colorScheme.onSurface.withAlpha(178)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Drawer buildAppDrawer(BuildContext context) {
  // <<< ШАГ 5.17: Получаем доступ к провайдеру и теме для бокового меню >>>
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  final theme = Theme.of(context);

  return Drawer(
    // <<< ШАГ 5.18: Адаптируем цвета бокового меню >>>
    backgroundColor: theme.scaffoldBackgroundColor,
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: theme.colorScheme.surface),
          child: Text(
            "SHASTOVSKY.",
            style: GoogleFonts.montserrat(
              color: theme.colorScheme.onSurface,
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
            ListTile(
              title: const Text('Попробуй кодить'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/${TryCodingPage.name}');
              },
            ),
          ],
        ),
        // ... (остальные ListTile навигации)
        ListTile(
          title: const Text('ОБО МНЕ'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/${AboutPage.name}');
          },
        ),
        ListTile(
          title: const Text('ПРОЕКТЫ'),
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
        // <<< ШАГ 5.19: Добавляем переключатель темы в боковое меню >>>
        const Divider(),
        ListTile(
          leading: Icon(
            themeProvider.isDarkMode
                ? Icons.wb_sunny_outlined
                : Icons.nightlight_round,
            color: theme.colorScheme.onSurface,
          ),
          title:
              Text(themeProvider.isDarkMode ? 'Светлая тема' : 'Темная тема'),
          onTap: () {
            themeProvider.toggleTheme(!themeProvider.isDarkMode);
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

// Классы BreadcrumbItem и Breadcrumbs остаются без изменений,
// но их цвета также будут адаптироваться благодаря тому, что
// bodyTextStyle и textSecondary теперь берутся из темы.

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
    final breadcrumbStyle = bodyTextStyle(context)
        .copyWith(color: Theme.of(context).colorScheme.secondary);

    final List<InlineSpan> spans = [];
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      if (item.routeName != null) {
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
        spans.add(
          TextSpan(
            text: item.text,
            style: breadcrumbStyle,
          ),
        );
      }

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
