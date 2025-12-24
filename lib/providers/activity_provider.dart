import 'package:flutter/material.dart';

class ActivityProvider extends ChangeNotifier {
  // ================= CURRENT =================
  int water = 0;    // gelas
  int steps = 0;    // langkah
  int workout = 0;  // menit

  // ================= TARGET =================
  int waterTarget = 8;
  int stepsTarget = 5000;
  int workoutTarget = 30;

  // ================= ADD PROGRESS =================
  void addWater() {
    if (water < waterTarget) {
      water++;
      notifyListeners();
    }
  }

  void addSteps(int value) {
    steps += value;
    if (steps > stepsTarget) steps = stepsTarget;
    notifyListeners();
  }

  void addWorkout(int value) {
    workout += value;
    if (workout > workoutTarget) workout = workoutTarget;
    notifyListeners();
  }

  // ================= CREATE ACTIVITY (DARI ADD SCREEN) =================
  void addWaterActivity({
    required int target,
    required int period, // disimpan biar future-proof
  }) {
    waterTarget = target;
    water = 0;
    notifyListeners();
  }

  void addStepsActivity({
    required int target,
    required int period,
    required TimeOfDay reminder,
  }) {
    stepsTarget = target;
    steps = 0;
    notifyListeners();
  }

  void addWorkoutActivity({
    required String type,
    required int duration,
    required int period,
    required TimeOfDay reminder,
  }) {
    workoutTarget = duration;
    workout = 0;
    notifyListeners();
  }

  // ================= CHECK =================
  bool get hasActivity =>
      waterTarget > 0 || stepsTarget > 0 || workoutTarget > 0;
}
