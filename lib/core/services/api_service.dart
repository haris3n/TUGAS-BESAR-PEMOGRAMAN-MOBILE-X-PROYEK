import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthtrack/core/constants/api_url.dart';

class ApiService {
  final Dio _dio = Dio();

  // Helper Header
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
      validateStatus: (status) => status! < 600,
    );
  }

  // --- FITUR BARU: AMBIL PROFIL USER (BIAR NAMA GAK HILANG) ---
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final options = await _getOptions();
      final response = await _dio.get(ApiUrl.user, options: options);

      if (response.statusCode == 200) {
        return response.data; // Mengembalikan data user (id, name, email, dll)
      }
      return {};
    } catch (e) {
      print("Get User Error: $e");
      return {};
    }
  }

  // 1. GET DASHBOARD
  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final options = await _getOptions();
      final response = await _dio.get(ApiUrl.targets, options: options);
      if (response.statusCode == 200) {
        return {
          'targets': response.data,
          'logs': {'water_today': 0, 'step_today': 0, 'workout_today': 0}
        };
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  // 2. SET TARGET
  Future<bool> setTarget({String? type, int? target, String? time}) async {
    try {
      final options = await _getOptions();
      Map<String, dynamic> data = {};
      if (type == 'water') data['water_target'] = target;
      if (type == 'step') data['step_target'] = target;
      if (type == 'workout') data['workout_target'] = target;

      final response = await _dio.post(ApiUrl.targets, data: data, options: options);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // 3. LOG ACTIVITY
  Future<bool> logActivity({required String type, required int value, String? workoutName}) async {
    try {
      final options = await _getOptions();
      String url = '';
      Map<String, dynamic> data = {};

      if (type == 'water') { url = ApiUrl.water; data = {'amount': value}; } 
      else if (type == 'step') { url = ApiUrl.steps; data = {'steps': value}; } 
      else if (type == 'workout') { url = ApiUrl.workout; data = {'duration': value, 'activity_type': workoutName ?? 'Olahraga'}; }

      final response = await _dio.post(url, data: data, options: options);
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // 4. LOGIN
  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post(ApiUrl.login, data: {
        'email': email, 'password': password,
      }, options: Options(validateStatus: (status) => true));

      if (response.statusCode == 200) {
        final token = response.data['access_token'] ?? response.data['token']; 
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        return true;
      }
      return false;
    } catch (e) { return false; }
  }

  // 5. REGISTER
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await _dio.post(ApiUrl.register, data: {
        'name': name, 'email': email, 'password': password, 'password_confirmation': password,
      }, options: Options(validateStatus: (status) => true));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true};
      } else {
        return {'success': false, 'message': response.data['message'] ?? 'Gagal'};
      }
    } catch (e) { return {'success': false, 'message': '$e'}; }
  }

  // 6. LOGOUT
  Future<void> logout() async {
    try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('auth_token');
    } catch (e) {}
  }
}