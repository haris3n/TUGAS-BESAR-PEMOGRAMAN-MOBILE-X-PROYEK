import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:healthtrack/providers/activity_provider.dart';
import 'package:healthtrack/providers/theme_provider.dart';

// --- PERBAIKAN IMPORT DI SINI ---
// Hapus 'screens/' karena folder widgets ada di root lib
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
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0F2A44) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detail Aktivitas',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: _buildProgress(context, activity),
          ),
        ),
      ),
    );
  }

  Widget _buildProgress(BuildContext context, ActivityProvider activity) {
    switch (args.type) {
      case ActivityType.water:
        return WaterProgressWidget(
          current: activity.water,
          target: activity.waterTarget,
          date: activity.waterDate, // KIRIM TANGGAL
          onStart: activity.addWater,
        );

      case ActivityType.steps:
        return StepsProgressWidget(
          current: activity.steps,
          target: activity.stepsTarget,
          time: activity.stepsTime,
          date: activity.stepsDate, // KIRIM TANGGAL
          onStart: () => activity.addSteps(500),
        );

      case ActivityType.workout:
        return WorkoutProgressWidget(
          current: activity.workout,
          target: activity.workoutTarget,
          type: activity.workoutType,
          time: activity.workoutTime,
          date: activity.workoutDate, // KIRIM TANGGAL
          onStart: () => activity.addWorkout(5),
        );
    }
  }
}
