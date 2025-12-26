import 'package:flutter/material.dart';

import '../../core/services/storage_service.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final StorageService _storageService = StorageService();

  int _currentPage = 0;

  final List<_OnboardData> _pages = [
    _OnboardData(
      image: 'assets/images/onboard1.png',
      text:
          'Aplikasi HealthTrack membantumu mencatat aktivitas penting seperti minum air, jumlah langkah, dan olahraga dengan cara yang sederhana.',
      buttonText: 'Berikutnya',
    ),
    _OnboardData(
      image: 'assets/images/onboard2.png',
      text:
          'Cukup sekali klik untuk menambahkan aktivitas. Semua data akan tersimpan rapi dan bisa kamu lihat kapan saja.',
      buttonText: 'Berikutnya',
    ),
    _OnboardData(
      image: 'assets/images/onboard3.png',
      text:
          'Lihat grafik dan perkembangan aktivitasmu. Capai target minum air, langkah, atau workout setiap harinya.',
      buttonText: 'Berikutnya',
    ),
    _OnboardData(
      image: 'assets/images/onboard4.png',
      text: 'Tingkatkan kebiasaan sehatmu bersama HealthTrack!',
      buttonText: 'Mulai Sekarang',
    ),
  ];

  void _next() async {
    if (_currentPage == _pages.length - 1) {
      await _storageService.setOnboardingDone();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) =>LoginScreen()),
      );
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2A44),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        page.image,
                        width: 180,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          page.text,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 16 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Button
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: ElevatedButton(
                onPressed: _next,
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
                child: Text(_pages[_currentPage].buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardData {
  final String image;
  final String text;
  final String buttonText;

  _OnboardData({
    required this.image,
    required this.text,
    required this.buttonText,
  });
}
