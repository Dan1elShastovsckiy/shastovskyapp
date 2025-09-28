// lib/components/pattern_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:minimal/models/design_pattern_model.dart';
import 'package:minimal/components/typography.dart';
import 'dart:ui';

class PatternCard extends StatefulWidget {
  final DesignPattern pattern;
  const PatternCard({super.key, required this.pattern});

  @override
  State<PatternCard> createState() => _PatternCardState();
}

class _PatternCardState extends State<PatternCard> {
  Offset? _tapPosition;

  void _showPatternDetails(BuildContext context) {
    final overlay = Overlay.of(context);
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final codeTheme = isDark ? atomOneDarkTheme : atomOneLightTheme;
        final screenSize = MediaQuery.of(context).size;

        // <<< КЛЮЧЕВОЕ ИСПРАВЛЕНИЕ: "Умное" позиционирование >>>
        double? top, bottom, left, right;
        final tapX = _tapPosition?.dx ?? 0;
        final tapY = _tapPosition?.dy ?? 0;
        const margin = 16.0; // Отступ от краев экрана

        // Определяем, где больше места по горизонтали
        if (tapX < screenSize.width / 2) {
          // Клик в левой половине экрана -> окно открывается вправо
          left = tapX + margin;
          right = margin;
        } else {
          // Клик в правой половине экрана -> окно открывается влево
          right = screenSize.width - tapX + margin;
          left = margin;
        }

        // Определяем, где больше места по вертикали
        if (tapY < screenSize.height / 2) {
          // Клик в верхней половине экрана -> окно открывается вниз
          top = tapY + margin;
          bottom = margin;
        } else {
          // Клик в нижней половине экрана -> окно открывается вверх
          bottom = screenSize.height - tapY + margin;
          top = margin;
        }

        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                overlayEntry?.remove();
              },
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Positioned(
              top: top,
              bottom: bottom,
              left: left,
              right: right,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 200),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(opacity: value, child: child),
                  );
                },
                child: Material(
                  elevation: 8.0,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.transparent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withAlpha(230),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(widget.pattern.title,
                                  style: headlineSecondaryTextStyle(context)),
                              const SizedBox(height: 8),
                              Text(widget.pattern.explanation,
                                  style: bodyTextStyle(context)),
                              const SizedBox(height: 24),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: HighlightView(
                                  widget.pattern.codeSnippet.trim(),
                                  language: 'dart',
                                  theme: codeTheme,
                                  padding: const EdgeInsets.all(16),
                                  textStyle: bodyTextStyle(context)
                                      .copyWith(fontFamily: 'monospace'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTapDown: (details) {
        _tapPosition = details.globalPosition;
      },
      onTap: () {
        _showPatternDetails(context);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.dividerColor),
            color: theme.colorScheme.surface,
          ),
          child: Row(
            children: [
              Icon(widget.pattern.icon, color: widget.pattern.color, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.pattern.title,
                        style: headlineSecondaryTextStyle(context)),
                    Text(widget.pattern.tagline,
                        style: subtitleTextStyle(context)),
                  ],
                ),
              ),
              Icon(
                Icons.open_in_new,
                color: theme.colorScheme.secondary.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
