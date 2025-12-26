import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthtrack/core/services/storage_service.dart';
import 'package:healthtrack/core/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  final ApiService _apiService = ApiService();

  bool isLoading = false;
  String? error;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  String _userName = 'User';
  String get userName => _userName;

  // LOAD USER DARI HP
  Future<void> loadUser() async {
    _isLoggedIn = false; 
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('user_name') ?? 'User';
    notifyListeners();
  }

  // ================= LOGIN (DIPERBAIKI) =================
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
      // 1. Minta Token
      bool success = await _apiService.login(email, password);

      if (success) {
        await _storageService.setLoggedIn(true);
        _isLoggedIn = true;
        
        // 2. TOKEN SUDAH DAPAT -> SEKARANG MINTA DATA NAMA KE SERVER
        final userData = await _apiService.getUserProfile();
        
        if (userData.isNotEmpty && userData['name'] != null) {
            String serverName = userData['name'];
            
            // 3. SIMPAN NAMA KE MEMORI HP
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('user_name', serverName);
            
            // 4. Update Tampilan
            _userName = serverName;
        }

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

  // ================= REGISTER =================
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
        // Hapus token lama biar bersih
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('auth_token'); 
        
        // Simpan nama baru sementara (nanti pas login akan ditimpa lagi dari server)
        await prefs.setString('user_name', name); 
        _userName = name;
        
        _isLoggedIn = false;
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
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_name'); // Hapus nama
    _userName = 'User'; 
    
    _isLoggedIn = false;
    notifyListeners();
  }
}