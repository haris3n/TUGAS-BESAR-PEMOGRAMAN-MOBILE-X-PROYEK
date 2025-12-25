import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/activity_provider.dart';
import '../../providers/theme_provider.dart';

import '../notification/notification_screen.dart';
import '../profile/profile_screen.dart';
import '../setting/setting_screen.dart';

import '../activity/add_water_screen.dart';
import '../activity/add_steps_screen.dart';
import '../activity/add_workout_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final activity = context.watch<ActivityProvider>();
    final isDark = theme.isDark;

    final bgColor = isDark ? const Color(0xFF0F2A44) : Colors.white;
    final cardColor = isDark ? const Color(0xFF102E4A) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,

      // ================= BOTTOM NAV =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: cardColor,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _HomeContent(
            isDark: isDark,
            textColor: textColor,
            activity: activity,
          ),
          const ProfileScreen(),
          const NotificationScreen(),
        ],
      ),
    );
  }
}
class _HomeContent extends StatelessWidget {
  final bool isDark;
  final Color textColor;
  final ActivityProvider activity;

  const _HomeContent({
    required this.isDark,
    required this.textColor,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HealthTrack',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Hello!',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    Navigator.pushNamed(context, '/setting');
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
                _menu(context, 'MINUM AIR', Icons.local_drink,
                    const AddWaterScreen()),
                _menu(context, 'LANGKAH', Icons.directions_run,
                    const AddStepsScreen()),
                _menu(context, 'WORKOUT', Icons.fitness_center,
                    const AddWorkoutScreen()),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Expanded(
            child: activity.hasActivity
                ? ListView()
                : Center(
                    child: Text(
                      'Tidak ada aktivitas',
                      style:
                          TextStyle(color: textColor.withOpacity(0.6)),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _menu(
    BuildContext context,
    String label,
    IconData icon,
    Widget page,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
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
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
