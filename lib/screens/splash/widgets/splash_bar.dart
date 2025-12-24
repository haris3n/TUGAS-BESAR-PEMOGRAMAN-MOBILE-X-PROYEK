import 'package:flutter/material.dart';

class SplashBar extends StatelessWidget {
  final int index;
  final AnimationController controller;

  const SplashBar({
    super.key,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final animation = Tween<double>(begin: 20, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.05 * index,
          0.05 * index + 0.15,
          curve: Curves.easeOut,
        ),
      ),
    );

    final opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.05 * index,
          0.05 * index + 0.15,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Opacity(
          opacity: opacity.value,
          child: Transform.translate(
            offset: Offset(0, animation.value),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 28,
              height: 40.0 + index * 14,
              decoration: BoxDecoration(
                color: Colors.blueGrey[200 + index * 100],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        );
      },
    );
  }
}
