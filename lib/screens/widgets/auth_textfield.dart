import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  // Saya sesuaikan nama variabelnya dengan panggilan di LoginScreen
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final IconData? icon; // Tambahan: Biar icon email/gembok muncul
  final Widget? suffixIcon; // Ganti nama suffix jadi suffixIcon biar standar

  const AuthTextField({
    super.key,
    required this.hintText, // Ganti hint -> hintText
    required this.controller,
    this.obscureText = false, // Ganti obscure -> obscureText
    this.icon, // Parameter baru untuk icon kiri
    this.suffixIcon, // Ganti suffix -> suffixIcon
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white54),

          // --- INI PERUBAHAN TAMPILANNYA (Icon di Kiri) ---
          prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,

          suffixIcon: suffixIcon, // Icon mata (di kanan)

          filled: true,
          fillColor: const Color(0xFF0F2A44), // Warna tetap sesuai punya kamu
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16), // Radius tetap 16
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}
