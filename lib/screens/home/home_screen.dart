import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- IMPORTS PROVIDER ---
import '../../providers/activity_provider.dart';
import '../../providers/theme_provider.dart';

// --- IMPORTS SCREEN LAIN ---
import '../notification/notification_screen.dart';
import '../profile/profile_screen.dart';
import '../setting/setting_screen.dart';

// --- IMPORTS ACTIVITY FORM ---
import '../activity/add_water_screen.dart';
import '../activity/add_steps_screen.dart';
import '../activity/add_workout_screen.dart';

// --- IMPORT DETAIL SCREEN (WAJIB ADA BIAR TIDAK MERAH) ---
import '../activity/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // 1. Ambil State Tema
    final theme = context.watch<ThemeProvider>();
    final isDark = theme.isDark;

    // 2. Definisi Warna Dasar
    final bgColor = isDark ? const Color(0xFF0B121C) : Colors.white;
    final navColor = isDark ? const Color(0xFF102E4A) : Colors.white;
    final unselectedItemColor = isDark ? Colors.grey[500] : Colors.grey;

    return Scaffold(
      backgroundColor: bgColor,

      // ================= BODY =================
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _HomeContent(isDark: isDark), // Halaman Home (Index 0)
          const ProfileScreen(), // Halaman Profil (Index 1)
          const NotificationScreen(), // Halaman Notif (Index 2)
        ],
      ),

      // ================= BOTTOM NAV =================
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            backgroundColor: navColor,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: unselectedItemColor,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
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
        ),
      ),
    );
  }
}

// ================= WIDGET KONTEN HOME =================
class _HomeContent extends StatelessWidget {
  final bool isDark;

  const _HomeContent({required this.isDark});

  @override
  Widget build(BuildContext context) {
    // Mengambil data dari ActivityProvider
    final activityProvider = context.watch<ActivityProvider>();

    // Warna Text dan Elemen
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    const headerColor = Color(0xFF102E4A);

    // ================= LOGIC PENYUSUNAN DATA =================
    final List<Map<String, dynamic>> dataList = [];

    // Cek Water
    if (activityProvider.waterTarget > 0) {
      dataList.add({
        'type': 'water', // ID String untuk konversi ke Enum nanti
        'title': 'Minum air',
        'current': activityProvider.water,
        'target': activityProvider.waterTarget,
        'unit': 'gelas',
      });
    }

    // Cek Steps
    if (activityProvider.stepsTarget > 0) {
      dataList.add({
        'type': 'steps',
        'title': 'Langkah kaki',
        'current': activityProvider.steps,
        'target': activityProvider.stepsTarget,
        'unit': '',
      });
    }

    // Cek Workout
    if (activityProvider.workoutTarget > 0) {
      dataList.add({
        'type': 'workout',
        'title': 'Olahraga',
        'current': activityProvider.workout,
        'target': activityProvider.workoutTarget,
        'unit': 'menit',
      });
    }

    // Cek apakah ada aktivitas yang dipilih
    final bool hasActivity = dataList.isNotEmpty;
    // ==========================================================

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- HEADER ----------------
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(top: 50, left: 24, right: 24, bottom: 40),
            decoration: const BoxDecoration(
              color: headerColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(80),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'HealthTrack',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
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
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(Icons.person_outline,
                          size: 35, color: headerColor),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hello, User!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Selamat datang kembali',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // ---------------- PILIH AKTIVITAS (MENU GAMBAR) ----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Pilih Aktivitas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Menu Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildImageMenu(
                    context, 'assets/images/water.png', const AddWaterScreen()),
                _buildImageMenu(
                    context, 'assets/images/run.png', const AddStepsScreen()),
                _buildImageMenu(
                    context, 'assets/images/gym.png', const AddWorkoutScreen()),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // ---------------- SECTION: AKTIVITAS HARI INI ----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Aktivitas hari ini',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Logic Konten (Card vs Placeholder)
          Builder(
            builder: (context) {
              if (hasActivity) {
                // JIKA ADA DATA -> Tampilkan List Card
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    final item = dataList[index];
                    // --- PERBAIKAN UTAMA DI SINI ---
                    // Kita tambahkan parameter 'context' dan 'type' yang sebelumnya hilang
                    return _buildProgressCard(
                      context: context, // <--- INI YANG TADINYA ERROR
                      isDark: isDark,
                      type: item['type'], // <--- INI JUGA
                      title: item['title'],
                      current: item['current'],
                      target: item['target'],
                      unit: item['unit'],
                    );
                  },
                );
              } else {
                // JIKA KOSONG -> Tampilkan Placeholder (Icon & Teks)
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100, bottom: 20),
                    child: Column(
                      children: [
                        Icon(Icons.history_toggle_off,
                            size: 60, color: subTextColor.withOpacity(0.3)),
                        const SizedBox(height: 10),
                        Text(
                          'Tidak ada aktivitas',
                          style: TextStyle(
                            color: subTextColor.withOpacity(0.5),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }

  // ================= WIDGET HELPER: CARD PROGRESS =================
  Widget _buildProgressCard({
    required BuildContext context, // Parameter wajib untuk navigasi
    required bool isDark,
    required String type, // Parameter wajib untuk penanda jenis aktivitas
    required String title,
    required int current,
    required int target,
    required String unit,
  }) {
    double progressValue = (target == 0) ? 0 : (current / target);
    if (progressValue > 1.0) progressValue = 1.0;

    final int percentage = (progressValue * 100).toInt();
    final borderColor =
        isDark ? Colors.blueAccent.withOpacity(0.5) : Colors.blueAccent;

    return GestureDetector(
      onTap: () {
        // --- LOGIC KONVERSI STRING KE ENUM ---
        // Kita ubah String 'water' menjadi Enum ActivityType.water
        ActivityType enumType;
        if (type == 'water') {
          enumType = ActivityType.water;
        } else if (type == 'steps') {
          enumType = ActivityType.steps;
        } else {
          enumType = ActivityType.workout;
        }

        // --- NAVIGASI KE DETAIL SCREEN BARU ---
        // Pastikan 'DetailActivityScreen' dan 'ActivityDetailArgs' sudah diimport di atas
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailActivityScreen(
              args: ActivityDetailArgs(type: enumType),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.transparent : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: borderColor,
            width: 1.5,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$current/$target $unit',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$percentage %',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 12,
                backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? Colors.grey[400]! : Colors.grey[600]!,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper Menu Gambar
  Widget _buildImageMenu(
      BuildContext context, String assetPath, Widget targetScreen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            assetPath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, color: Colors.grey),
              );
            },
          ),
        ),
      ),
    );
  }
}
