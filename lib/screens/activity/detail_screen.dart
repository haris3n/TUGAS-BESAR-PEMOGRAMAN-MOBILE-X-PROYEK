import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:healthtrack/providers/activity_provider.dart';
import 'package:healthtrack/providers/theme_provider.dart';

import 'package:healthtrack/screens/widgets/progress/water_progress_widget.dart';
import 'package:healthtrack/screens/widgets/progress/steps_progress_widget.dart';
import 'package:healthtrack/screens/widgets/progress/workout_progress_widget.dart';

enum ActivityType { water, steps, workout }

class ActivityDetailArgs {
  final ActivityType type;
  ActivityDetailArgs({required this.type});
}

class DetailActivityScreen extends StatelessWidget {
  final ActivityDetailArgs args;

  const DetailActivityScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final activity = context.watch<ActivityProvider>();
    final isDark = context.watch<ThemeProvider>().isDark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F2A44) : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text(
              'Detail Aktivitas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 32),
            _buildProgress(activity),
          ],
        ),
      ),
    );
  }

  Widget _buildProgress(ActivityProvider activity) {
    switch (args.type) {
      case ActivityType.water:
        return WaterProgressWidget(
          current: activity.water,
          target: activity.waterTarget,
          onStart: activity.addWater,
        );

      case ActivityType.steps:
        return StepsProgressWidget(
          current: activity.steps,
          target: activity.stepsTarget,
          onStart: () => activity.addSteps(500),
        );

      case ActivityType.workout:
        return WorkoutProgressWidget(
          current: activity.workout,
          target: activity.workoutTarget,
          onStart: () => activity.addWorkout(5),
        );
    }
  }
}
