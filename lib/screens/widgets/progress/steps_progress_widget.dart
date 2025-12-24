import 'package:flutter/material.dart';
import 'start_button.dart';

class StepsProgressWidget extends StatelessWidget {
  final int current;
  final int target;
  final VoidCallback onStart;

  const StepsProgressWidget({
    super.key,
    required this.current,
    required this.target,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (current / target).clamp(0.0, 1.0);

    return Column(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: CircularProgressIndicator(
            value: percent,
            strokeWidth: 10,
            backgroundColor: Colors.white24,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '$current / $target langkah',
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 12),
        StartButton(onStart: onStart),
      ],
    );
  }
}
