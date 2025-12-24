import 'package:flutter/material.dart';
import '../core/services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  bool isLoading = false;
  String? error;

  bool _isLoggedIn = false;
bool get isLoggedIn => _isLoggedIn;

Future<void> checkLogin() async {
  // sementara dummy
  _isLoggedIn = false;
}


  Future<bool> login({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.isEmpty) {
      error = 'Email dan password wajib diisi';
      isLoading = false;
      notifyListeners();
      return false;
    }

    // simulasi login sukses
    await _storageService.setLoggedIn(true);

    isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      error = 'Semua field wajib diisi';
      isLoading = false;
      notifyListeners();
      return false;
    }

    if (password != confirmPassword) {
      error = 'Password tidak sama';
      isLoading = false;
      notifyListeners();
      return false;
    }

    await _storageService.setLoggedIn(true);

    isLoading = false;
    notifyListeners();
    return true;
  }
}
