import 'package:flutter/material.dart';
import 'start_button.dart';

class WaterProgressWidget extends StatelessWidget {
  final int current;
  final int target;
  final VoidCallback onStart;

  const WaterProgressWidget({
    super.key,
    required this.current,
    required this.target,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(target, (index) {
            final filled = index < current;
            return Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: filled ? Colors.blue : Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.local_drink, color: Colors.white),
            );
          }),
        ),
        const SizedBox(height: 16),
        Text(
          '$current / $target gelas',
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 12),
        StartButton(onStart: onStart),
      ],
    );
  }
}
