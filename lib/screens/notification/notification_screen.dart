import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../setting/setting_screen.dart';
import '../home/home_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final bool isDark = theme.isDark;

    final Color bgColor =
        isDark ? const Color(0xFF0B121C) : Colors.white;
    final Color headerColor =
        isDark ? const Color(0xFF183B5B) : const Color(0xFF183B5B);
    final Color textColor =
        isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, left: 24, right: 24, bottom: 40),
            decoration: const BoxDecoration(
              color:const Color(0xFF183B5B),
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
                      'Notifikasi',
                      style: TextStyle(
                        fontSize: 22.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                        icon: const Icon(Icons.settings_outlined, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SettingScreen()),
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

            // ================= EMPTY STATE =================
            Text(
              'Tidak ada Riwayat',
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
