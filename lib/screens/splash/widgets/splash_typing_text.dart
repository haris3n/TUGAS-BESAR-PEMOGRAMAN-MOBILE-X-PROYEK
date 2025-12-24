import 'package:flutter/material.dart';

class SplashTypingText extends StatelessWidget {
  final AnimationController controller;
  const SplashTypingText({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final progress = ((controller.value - 0.55) / 0.25)
            .clamp(0.0, 1.0);
        final count = (progress * "HealthTrack".length).floor();

        return Text(
          "HealthTrack".substring(0, count),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFamily: 'Manrope',
          ),
        );
      },
    );
  }
}
