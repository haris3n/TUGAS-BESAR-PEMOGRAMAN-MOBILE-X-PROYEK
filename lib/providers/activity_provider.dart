import 'package:flutter/material.dart';

class ActivityProvider extends ChangeNotifier {
  // ================= CURRENT =================
  int water = 0;
  int steps = 0;
  int workout = 0;

  // ================= TARGET =================
  int waterTarget = 0;
  int stepsTarget = 0;
  int workoutTarget = 0;

  // ================= INFO TAMBAHAN (DINAMIS) =================
  String workoutType = 'Aktivitas'; 
  
  // JAM PENGINGAT
  String stepsTime = '-- : --';
  String workoutTime = '-- : --';

  // TANGGAL PEMBUATAN (Dibuat tanggal berapa?)
  String waterDate = '-';
  String stepsDate = '-';
  String workoutDate = '-';

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

  // ================= CREATE ACTIVITY =================
  void addWaterActivity({
    required int target,
    required int period,
  }) {
    waterTarget = target;
    water = 0;
    // SIMPAN TANGGAL HARI INI
    waterDate = _getTodayDate(); 
    notifyListeners();
  }

  void addStepsActivity({
    required int target,
    required int period,
    required TimeOfDay reminder,
  }) {
    stepsTarget = target;
    steps = 0;
    // SIMPAN JAM & TANGGAL
    stepsTime = _formatTime(reminder); 
    stepsDate = _getTodayDate();
    notifyListeners();
  }

  void addWorkoutActivity({
    required String type,
    required int duration,
    required int period,
    required TimeOfDay reminder,
  }) {
    workoutType = type;
    workoutTarget = duration;
    workout = 0;
    // SIMPAN JAM & TANGGAL
    workoutTime = _formatTime(reminder);
    workoutDate = _getTodayDate();
    notifyListeners();
  }

  // ================= HELPER FORMATTER =================
  
  // Format Jam: "16 : 30"
  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour : $minute';
  }

  // Format Tanggal Indo: "25 Desember 2025"
  String _getTodayDate() {
    final now = DateTime.now();
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  // ================= CHECK =================
  bool get hasActivity =>
      waterTarget > 0 || stepsTarget > 0 || workoutTarget > 0;
}