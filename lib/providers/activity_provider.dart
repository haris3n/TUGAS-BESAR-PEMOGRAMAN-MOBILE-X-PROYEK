import 'package:flutter/material.dart';
import 'package:healthtrack/core/services/api_service.dart';

class ActivityProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // STATE DATA
  int water = 0;
  int steps = 0;
  int workout = 0;

  int waterTarget = 0;
  int stepsTarget = 0;
  int workoutTarget = 0;

  String workoutType = 'Aktivitas';

  // Variabel Jam & Tanggal (Wajib ada biar Detail Screen gak error)
  String stepsTime = '-- : --';
  String workoutTime = '-- : --';

  String waterDate = '-';
  String stepsDate = '-';
  String workoutDate = '-';

  // ================= RESET DATA (PENTING BIAR GAK NYANGKUT) =================
  void resetData() {
    water = 0;
    steps = 0;
    workout = 0;

    waterTarget = 0;
    stepsTarget = 0;
    workoutTarget = 0;

    // Reset tanggal juga biar bersih
    waterDate = '-';
    stepsDate = '-';
    workoutDate = '-';

    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ================= FETCH DATA =================
  Future<void> fetchDashboardData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _apiService.getDashboardData();
      final targets = data['targets'] ?? {};
      final logs = data['logs'] ?? {};

      waterTarget = int.tryParse(targets['water_target'].toString()) ?? 0;
      water = int.tryParse(logs['water_today'].toString()) ?? 0;

      stepsTarget = int.tryParse(targets['step_target'].toString()) ?? 0;
      steps = int.tryParse(logs['step_today'].toString()) ?? 0;

      workoutTarget = int.tryParse(targets['workout_target'].toString()) ?? 0;
      workout = int.tryParse(logs['workout_today'].toString()) ?? 0;
      workoutType = logs['activity_type'] ?? 'Aktivitas';

      String today = _getTodayDate();
      if (waterTarget > 0) waterDate = today;
      if (stepsTarget > 0) stepsDate = today;
      if (workoutTarget > 0) workoutDate = today;

      if (stepsTime == '-- : --' && stepsTarget > 0) stepsTime = "07 : 00";
      if (workoutTime == '-- : --' && workoutTarget > 0)
        workoutTime = "16 : 00";
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ================= LOGIKA NAMBAH (SIMULASI & MANUAL) =================

  // WATER (Nambah 1)
  Future<void> addWater() async {
    if (water < waterTarget) {
      water += 1; // Optimistic update
      notifyListeners();
      await _apiService.logActivity(type: 'water', value: 1);
    }
  }

  // STEPS (Nambah Custom, misal 500)
  Future<void> addSteps(int value) async {
    if (steps < stepsTarget) {
      steps += value;
      if (steps > stepsTarget) steps = stepsTarget; // Biar gak bablas
      notifyListeners();
      await _apiService.logActivity(type: 'step', value: value);
    }
  }

  // WORKOUT (Nambah Custom, misal 5)
  Future<void> addWorkout(int value) async {
    if (workout < workoutTarget) {
      workout += value;
      if (workout > workoutTarget) workout = workoutTarget;
      notifyListeners();

      await _apiService.logActivity(
          type: 'workout', value: value, workoutName: workoutType);
    }
  }

  // ================= SET TARGET (DARI ADD SCREEN) =================

  Future<void> addWaterActivity(
      {required int target, required int period}) async {
    waterTarget = target;
    water = 0; // Reset progress harian kalau target baru
    waterDate = _getTodayDate();
    notifyListeners();
    await _apiService.setTarget(type: 'water', target: target);
  }

  Future<void> addStepsActivity(
      {required int target,
      required int period,
      required TimeOfDay reminder}) async {
    stepsTarget = target;
    steps = 0;
    stepsTime = _formatTime(reminder);
    stepsDate = _getTodayDate();
    notifyListeners();
    await _apiService.setTarget(type: 'step', target: target, time: stepsTime);
  }

  Future<void> addWorkoutActivity({
    required String type,
    required int duration,
    required int period,
    required TimeOfDay reminder,
  }) async {
    workoutType = type;
    workoutTarget = duration;
    workout = 0;
    workoutTime = _formatTime(reminder);
    workoutDate = _getTodayDate();
    notifyListeners();
    await _apiService.setTarget(
        type: 'workout', target: duration, time: workoutTime);
  }

  // ================= HELPER =================
  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour : $minute';
  }

  String _getTodayDate() {
    final now = DateTime.now();
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  bool get hasActivity =>
      waterTarget > 0 || stepsTarget > 0 || workoutTarget > 0;
}
