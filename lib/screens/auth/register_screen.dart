import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:healthtrack/providers/auth_provider.dart';
import 'package:healthtrack/screens/home/home_screen.dart';
import 'login_screen.dart';
// PERBAIKAN IMPORT (Sesuai struktur folder kamu)
import 'package:healthtrack/screens/widgets/auth_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F2A44),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFF183B5B),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // JANGAN ADA const DI SINI
              children: [
                const Text(
                  'HealthTrack',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),

                // --- FORM INPUT ---

                // NAMA
                AuthTextField(
                  hintText: 'Nama Lengkap', // Ganti hint -> hintText
                  controller: _nameController,
                  icon: Icons.person_outline, // Tambah Icon
                ),
                const SizedBox(height: 16),

                // EMAIL
                AuthTextField(
                  hintText: 'Email/No.Telpon',
                  controller: _emailController,
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),

                // PASSWORD
                AuthTextField(
                  hintText: 'Password',
                  controller: _passwordController,
                  obscureText: true, // Ganti obscure -> obscureText
                  icon: Icons.lock_outline,
                ),
                const SizedBox(height: 16),

                // KONFIRMASI PASSWORD
                AuthTextField(
                  hintText: 'Konfirmasi Password',
                  controller: _confirmController,
                  obscureText: true,
                  icon: Icons.lock_outline,
                ),

                const SizedBox(height: 12),

                // ERROR MESSAGE
                if (auth.error != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      auth.error!,
                      style: const TextStyle(
                          color: Colors.redAccent, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 10),

                // TOMBOL DAFTAR
                ElevatedButton(
                  onPressed: auth.isLoading
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();

                          final success = await auth.register(
                            name: _nameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                            confirmPassword: _confirmController.text,
                          );

                          if (success && context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HomeScreen(),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 14,
                    ),
                  ),
                  child: auth.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Daftar',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                ),

                const SizedBox(height: 20),

                // TOMBOL PINDAH KE LOGIN
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Sudah punya akun? MASUK',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
