// lib/components/animated_arrow.dart

import 'package:flutter/material.dart';

class AnimatedArrow extends StatefulWidget {
  final Color? color;
  final double size;

  const AnimatedArrow({
    super.key,
    this.color,
    this.size = 32.0,
  });

  @override
  _AnimatedArrowState createState() => _AnimatedArrowState();
}

class _AnimatedArrowState extends State<AnimatedArrow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // Запускаем анимацию в бесконечном цикле

    _animation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Icon(
            Icons.arrow_downward,
            // Используем цвет из параметров или цвет темы по умолчанию
            color: widget.color ?? Theme.of(context).colorScheme.secondary,
            size: widget.size,
          ),
        );
      },
    );
  }
}
