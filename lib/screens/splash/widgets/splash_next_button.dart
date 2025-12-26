import 'package:flutter/material.dart';

class SplashNextButton extends StatelessWidget {
  final AnimationController controller;

  const SplashNextButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final scale = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.85, 1.0, curve: Curves.easeOutBack),
      ),
    );

    final opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.85, 1.0),
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Opacity(
          opacity: opacity.value,
          child: Transform.scale(
            scale: scale.value,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1B2B42),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () {},
              child: const Text("Berikutnya"),
            ),
          ),
        );
      },
    );
  }
}
