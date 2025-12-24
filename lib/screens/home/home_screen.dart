import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/activity_provider.dart';
import '../../providers/theme_provider.dart';

import '../activity/add_water_screen.dart';
import '../activity/add_steps_screen.dart';
import '../activity/add_workout_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final activity = context.watch<ActivityProvider>();

    final bool isDark = theme.isDark;

    final Color bgColor = isDark ? const Color(0xFF0F2A44) : Colors.white;
    final Color cardColor =
        isDark ? const Color(0xFF102E4A) : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,

      // ================= BOTTOM NAV =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: cardColor,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifikasi',
          ),
        ],
      ),

      // ================= BODY =================
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= HEADER =================
            Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF183B5B)
                    : Colors.blue.shade100,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'HealthTrack',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Hello, Chizbu!',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      theme.toggleTheme(); // sementara
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= PILIH AKTIVITAS =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Pilih Aktivitas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ActivityMenu(
                    label: 'MINUM AIR',
                    icon: Icons.local_drink,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddWaterScreen(),
                        ),
                      );
                    },
                  ),
                  _ActivityMenu(
                    label: 'LANGKAH KAKI',
                    icon: Icons.directions_run,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddStepsScreen(),
                        ),
                      );
                    },
                  ),
                  _ActivityMenu(
                    label: 'WORKOUT',
                    icon: Icons.fitness_center,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddWorkoutScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ================= AKTIVITAS HARI INI =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Aktivitas hari ini',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: activity.hasActivity
                    ? ListView(
                        children: [
                          _ActivityProgressCard(
                            title: 'Minum air',
                            subtitle: '${activity.water}/2000 ml',
                            percent:
                                (activity.water / 2000 * 100).clamp(0, 100).toInt(),
                          ),
                          _ActivityProgressCard(
                            title: 'Langkah kaki',
                            subtitle: '${activity.steps}/5000',
                            percent:
                                (activity.steps / 5000 * 100).clamp(0, 100).toInt(),
                          ),
                          _ActivityProgressCard(
                            title: 'Olahraga',
                            subtitle: '${activity.workout}/30 menit',
                            percent:
                                (activity.workout / 30 * 100).clamp(0, 100).toInt(),
                          ),
                        ],
                      )
                    : Center(
                        child: Text(
                          'Tidak ada aktivitas',
                          style: TextStyle(
                            color: textColor.withOpacity(0.6),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= WIDGET MENU =================
class _ActivityMenu extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ActivityMenu({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ================= PROGRESS CARD =================
class _ActivityProgressCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int percent;

  const _ActivityProgressCard({
    required this.title,
    required this.subtitle,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(subtitle),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: percent / 100,
            minHeight: 6,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$percent%',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
