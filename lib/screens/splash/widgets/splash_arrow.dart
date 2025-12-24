import 'package:flutter/material.dart';

class SplashArrow extends StatelessWidget {
  final AnimationController controller;

  const SplashArrow({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final slide = Tween<double>(begin: -20, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.35, 0.55, curve: Curves.easeOut),
      ),
    );

    final opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.35, 0.55),
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Opacity(
          opacity: opacity.value,
          child: Transform.translate(
            offset: Offset(slide.value, 0),
            child: Icon(
              Icons.trending_up,
              color: Colors.blueGrey[200],
              size: 48,
            ),
          ),
        );
      },
    );
  }
}
