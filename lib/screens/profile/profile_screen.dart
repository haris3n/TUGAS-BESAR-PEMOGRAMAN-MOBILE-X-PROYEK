import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- IMPORT PROVIDER ---
import '../../providers/auth_provider.dart';
import '../../providers/activity_provider.dart'; // <--- WAJIB TAMBAH INI BIAR BISA RESET DATA

// --- IMPORT SCREENS ---
import '../setting/setting_screen.dart';
import 'edit_profile_screen.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil AuthProvider untuk Nama & Fungsi Logout
    final authProvider = context.watch<AuthProvider>();
    final userName = authProvider.userName;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0B121C) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // ================= HEADER =================
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(top: 50, left: 24, right: 24, bottom: 40),
            decoration: const BoxDecoration(
              color: Color(0xFF183B5B),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(80),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Row(
                  children: [
                    const SizedBox(width: 16),
                    const Text(
                      'Profil',
                      style: TextStyle(
                        fontSize: 22.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined,
                          color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SettingScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          // ================= AVATAR =================
          Transform.translate(
            offset: const Offset(0, -50),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade700,
                  child:
                      const Icon(Icons.person, size: 60, color: Colors.white),
                ),
                Material(
                  shape: const CircleBorder(),
                  color: const Color(0xFF1B2B42),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfileScreen(),
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.edit, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ================= USER INFO =================
          Text(
            userName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Pengguna HealthTrack',
            style: TextStyle(
                color: (isDark ? Colors.white : Colors.black).withOpacity(0.7)),
          ),

          const Spacer(),

          // ================= LOGOUT (PEMBERSIHAN DATA) =================
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: TextButton.icon(
              onPressed: () async {
                // 1. BERSIHKAN DATA AKTIVITAS (RESET JADI 0)
                // Ini kuncinya supaya data Ucup tidak terbawa ke Hahrus
                context.read<ActivityProvider>().resetData();

                // 2. Logout (Hapus Token & Nama)
                await context.read<AuthProvider>().logout();

                // 3. Pindah ke Halaman Login & Hapus History
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                'Keluar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
