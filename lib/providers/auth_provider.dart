import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // WAJIB: Untuk simpan nama
import 'package:healthtrack/core/services/storage_service.dart';
import 'package:healthtrack/core/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  final ApiService _apiService = ApiService();

  bool isLoading = false;
  String? error;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  // --- TAMBAHAN: VARIABLE NAMA USER ---
  String _userName = 'User';
  String get userName => _userName;

  // ================= LOAD USER (PENGGANTI checkLogin) =================
  // Fungsi ini yang dipanggil di home_screen.dart
  Future<void> loadUser() async {
    // 1. Cek Login Status (Logic bawaanmu)
    // Asumsi: default false jika belum ada method getLoggedIn
    _isLoggedIn = false;

    // 2. AMBIL NAMA DARI MEMORI HP
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('user_name') ?? 'User';

    notifyListeners();
  }

  // ================= LOGIN =================
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    if (email.isEmpty || password.isEmpty) {
      error = 'Email dan password wajib diisi';
      isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      bool success = await _apiService.login(email, password);

      if (success) {
        await _storageService.setLoggedIn(true);
        _isLoggedIn = true;

        // (Opsional) Ambil nama user jika API menyediakan,
        // tapi sementara kita pakai yang tersimpan/default

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        error = 'Email atau password salah';
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      error = 'Terjadi kesalahan koneksi: $e';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ================= REGISTER (UPDATE: SIMPAN NAMA) =================
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    if (password != confirmPassword) {
      error = 'Konfirmasi password tidak cocok';
      isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      final result = await _apiService.register(name, email, password);

      if (result['success'] == true) {
        // --- BAGIAN PENTING: SIMPAN NAMA KE MEMORI HP ---
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', name); // Simpan
        _userName = name; // Update variabel langsung

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        error = result['message'];
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      error = 'Terjadi kesalahan sistem: $e';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    await _apiService.logout();
    await _storageService.setLoggedIn(false);

    // HAPUS NAMA SAAT LOGOUT
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    _userName = 'User';

    _isLoggedIn = false;
    notifyListeners();
  }
}
