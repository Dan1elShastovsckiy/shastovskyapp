// lib/utils/max_width_extension.dart

import 'package:flutter/material.dart';

// Мы создадим виджет MaxWidthBox отдельно, чтобы избежать дублирования
class MaxWidthBox extends StatelessWidget {
  final double maxWidth;
  final Widget child;
  final EdgeInsets padding;
  // Убираем backgroundColor, он больше не нужен
  
  const MaxWidthBox({
    super.key, 
    required this.maxWidth, 
    required this.child, 
    this.padding = const EdgeInsets.symmetric(horizontal: 32)
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: padding,
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}


extension MaxWidthExtension on List<Widget> {
  List<Widget> toMaxWidth() {
    return [
      MaxWidthBox(
        maxWidth: 1200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: this,
        ),
      ),
    ];
  }

  List<Widget> toMaxWidthSliver() {
    return [
      SliverToBoxAdapter(
        child: MaxWidthBox(
          maxWidth: 1200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: this,
          ),
        ),
      ),
    ];
  }
}