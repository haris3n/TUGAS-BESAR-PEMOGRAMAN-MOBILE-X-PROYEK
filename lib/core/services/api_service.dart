import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthtrack/core/constants/api_url.dart';

class ApiService {
  final Dio _dio = Dio();

  // Helper untuk Header
  Future<Options> _getOptions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    return Options(
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
      // Validasi status code agar kita bisa handle error manual
      validateStatus: (status) {
        return status! < 600;
      },
    );
  }

  // 1. GET DASHBOARD DATA
  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final options = await _getOptions();

      // Kita ambil data Target dulu sebagai basis dashboard
      // (Pastikan ApiUrl.targets ada di api_url.dart kamu)
      final response = await _dio.get(ApiUrl.targets, options: options);

      if (response.statusCode == 200) {
        // Kita format manual return-nya biar sesuai Provider
        return {
          'targets': response.data,
          'logs': {
            // Default 0 dulu, nanti provider bisa fetch detail kalau perlu
            'water_today': 0,
            'step_today': 0,
            'workout_today': 0
          }
        };
      } else {
        // Kalau gagal atau data kosong, return map kosong biar gak crash
        return {};
      }
    } catch (e) {
      print("API Error (Dashboard): $e");
      return {};
    }
  }

  // 2. SET TARGET
  Future<bool> setTarget({
    String? type,
    int? target,
    String? time,
  }) async {
    try {
      final options = await _getOptions();

      // Mapping data agar sesuai dengan Controller Laravel (updateTargets)
      Map<String, dynamic> data = {};
      if (type == 'water') data['water_target'] = target;
      if (type == 'step') data['step_target'] = target;
      if (type == 'workout') data['workout_target'] = target;

      // Panggil endpoint /targets
      final response =
          await _dio.post(ApiUrl.targets, data: data, options: options);
      return response.statusCode == 200;
    } catch (e) {
      print("API Error (SetTarget): $e");
      return false;
    }
  }

  // 3. LOG AKTIVITAS (INI BAGIAN UTAMA YANG DIPERBAIKI)
  Future<bool> logActivity({
    required String type,
    required int value,
    String? workoutName,
  }) async {
    try {
      final options = await _getOptions();

      String url = '';
      Map<String, dynamic> data = {};

      // LOGIKA PEMILIHAN JALUR (SESUAI BACKEND BARU)
      if (type == 'water') {
        url = ApiUrl.water; // Pastikan ini ada di api_url.dart
        data = {'amount': value};
      } else if (type == 'step') {
        url = ApiUrl.steps; // Pastikan ini ada di api_url.dart
        data = {'steps': value};
      } else if (type == 'workout') {
        url = ApiUrl.workout; // Pastikan ini ada di api_url.dart
        data = {'duration': value, 'activity_type': workoutName ?? 'Olahraga'};
      }

      print("Sending to $url : $data"); // Debugging

      final response = await _dio.post(url, data: data, options: options);
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("API Error (LogActivity): $e");
      return false;
    }
  }

  // 4. LOGIN (Simpan Token)
  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post(ApiUrl.login,
          data: {
            'email': email,
            'password': password,
          },
          options: Options(validateStatus: (status) => true));

      if (response.statusCode == 200) {
        final token = response.data['access_token'] ?? response.data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        return true;
      }
      return false;
    } catch (e) {
      print("Login Error: $e");
      return false;
    }
  }

  // 5. REGISTER
  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      final response = await _dio.post(
        ApiUrl.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'ngrok-skip-browser-warning': 'true',
          },
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': 'Registrasi Berhasil'};
      } else {
        final msg = response.data['message'] ?? 'Gagal Mendaftar';
        return {'success': false, 'message': msg};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error Koneksi: $e'};
    }
  }

  // 6. LOGOUT (INI SUDAH ADA, JADI AUTH PROVIDER BAKAL AMAN)
  Future<void> logout() async {
    try {
      // Hapus token lokal
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    } catch (e) {
      // ignore error
    }
  }
}
  