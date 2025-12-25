import 'dart:async';
import 'package:flutter/material.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // LOGO
  double _logoScale = 0;
  double _logoOpacity = 0;

  // TEXT
  String _typedText = '';
  final String _fullText = 'HealthTrack';

  // BUTTON
  double _buttonScale = 0;
  double _buttonOpacity = 0;

  @override
  void initState() {
    super.initState();
    _runAnimation();
  }

  Future<void> _runAnimation() async {
    // === LOGO POP ===
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _logoScale = 1;
      _logoOpacity = 1;
    });

    // === TYPEWRITER TEXT ===
    await Future.delayed(const Duration(milliseconds: 600));
    for (int i = 0; i < _fullText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 120));
      setState(() {
        _typedText += _fullText[i];
      });
    }

    // === BUTTON POP ===
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _buttonScale = 1;
      _buttonOpacity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B2B42),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ===== LOGO =====
            AnimatedOpacity(
              opacity: _logoOpacity,
              duration: const Duration(milliseconds: 400),
              child: AnimatedScale(
                scale: _logoScale,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutBack,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 180,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ===== TYPEWRITER TEXT =====
            Text(
              _typedText,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 36),

            // ===== BUTTON =====
            AnimatedOpacity(
              opacity: _buttonOpacity,
              duration: const Duration(milliseconds: 300),
              child: AnimatedScale(
                scale: _buttonScale,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutBack,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1B2B42),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OnboardingScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Berikutnya',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
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
