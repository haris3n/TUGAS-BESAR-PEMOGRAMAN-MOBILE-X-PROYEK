import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../setting/setting_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0B121C): Colors.white;
    final headerColor = const Color(0xFF183B5B);
    final textColor = Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
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

          // ================= AVATAR =================
          Transform.translate(
            offset: const Offset(0, -50),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade700,
                  child: const Icon(Icons.person,
                      size: 60, color: Colors.white),
                ),

                // ICON EDIT (PASTI BISA DIKLIK)
                Material(
                  shape: const CircleBorder(),
                  color: const Color(0xFF1B2B42),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const EditProfileScreen(),
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.edit,
                          size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ================= USER INFO =================
          Text(
            user.name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            user.email,
            style: TextStyle(
                color: (isDark ? Colors.white : Colors.black)
                    .withOpacity(0.7)),
          ),
          const SizedBox(height: 4),
          Text(
            user.phone,
            style: TextStyle(
                color: (isDark ? Colors.white : Colors.black)
                    .withOpacity(0.7)),
          ),

          const Spacer(),

          // ================= LOGOUT =================
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon:
                  const Icon(Icons.logout, color: Colors.red),
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
