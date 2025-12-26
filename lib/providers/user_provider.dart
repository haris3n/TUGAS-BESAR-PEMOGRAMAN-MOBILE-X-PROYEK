import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String name = '';
  String email = '';
  String phone = '';
  String? avatarPath;

  void setUser({
    required String name,
    required String email,
    required String phone,
  }) {
    this.name = name;
    this.email = email;
    this.phone = phone;
    notifyListeners();
  }

  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? avatarPath,
  }) {
    if (name != null) this.name = name;
    if (email != null) this.email = email;
    if (phone != null) this.phone = phone;
    if (avatarPath != null) this.avatarPath = avatarPath;
    notifyListeners();
  }
}
