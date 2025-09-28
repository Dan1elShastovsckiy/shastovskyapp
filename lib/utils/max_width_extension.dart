// lib/utils/max_width_extension.dart

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MaxWidthBox extends StatelessWidget {
  final double maxWidth;
  final Widget child;
  // Убираем padding и backgroundColor отсюда, они будут в расширении

  const MaxWidthBox({
    super.key,
    required this.maxWidth,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

extension MaxWidthExtension on List<Widget> {
  List<Widget> toMaxWidth() {
    return map(
      (item) => MaxWidthBox(
        maxWidth: 1200,
        child: item,
      ),
    ).toList();
  }

  List<Widget> toMaxWidthSliver() {
    return [
      SliverToBoxAdapter(
        // <<< КЛЮЧЕВОЕ ИСПРАВЛЕНИЕ: Оборачиваем MaxWidthBox в Padding >>>
        // Теперь отступы будут применяться ко всему блоку, а не к каждому элементу
        child: Builder(builder: (context) {
          // Делаем отступы адаптивными
          final horizontalPadding =
              ResponsiveBreakpoints.of(context).isMobile ? 24.0 : 48.0;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: MaxWidthBox(
              maxWidth: 1200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: this,
              ),
            ),
          );
        }),
      ),
    ];
  }
}
