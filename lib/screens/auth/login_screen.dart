import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- IMPORTS ---
import 'package:healthtrack/providers/auth_provider.dart';
import 'package:healthtrack/screens/home/home_screen.dart';
import 'register_screen.dart';
// PERBAIKAN IMPORT (Sesuaikan dengan lokasi file widgets kamu)
import 'package:healthtrack/screens/widgets/auth_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Wajib dispose controller biar HP gak lemot/bocor memori
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              children: [
                // JUDUL
                const Text(
                  'HealthTrack',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),

                // INPUT EMAIL
                AuthTextField(
                  hintText: 'Email',
                  controller: _emailController,
                  icon: Icons.email_outlined,
                ),

                const SizedBox(height: 16),

                // INPUT PASSWORD
                AuthTextField(
                  hintText: 'Password',
                  controller: _passwordController,
                  obscureText:
                      true, // Pastikan di widget AuthTextField parameternya 'obscureText'
                  icon: Icons.lock_outline,
                ),

                const SizedBox(height: 12),

                // TAMPILKAN ERROR (Jika ada)
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

                // TOMBOL MASUK
                ElevatedButton(
                  onPressed: auth.isLoading
                      ? null
                      : () async {
                          // Tutup keyboard
                          FocusScope.of(context).unfocus();

                          // Panggil Provider Login
                          final success = await auth.login(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );

                          // Jika Sukses -> Pindah ke Home
                          if (success && context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomeScreen()),
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
                        horizontal: 48, vertical: 14),
                  ),
                  child: auth.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Masuk',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                ),

                const SizedBox(height: 20),

                // TOMBOL DAFTAR
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) =>  RegisterScreen()),
                    );
                  },
                  child: const Text(
                    'Belum punya akun? DAFTAR',
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
