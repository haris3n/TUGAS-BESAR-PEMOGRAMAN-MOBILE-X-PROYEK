import 'package:flutter/material.dart';
import '../core/services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  bool _isDark = true;
  bool get isDark => _isDark;

  Future<void> loadTheme() async {
    _isDark = await _storageService.getTheme();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDark = !_isDark;
    await _storageService.setTheme(_isDark);
    notifyListeners();
  }
}
