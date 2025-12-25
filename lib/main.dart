import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/activity_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';

import 'screens/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // AUTH (login / register)
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),

        // ACTIVITY (minum air, langkah, workout)
        ChangeNotifierProvider(
          create: (_) => ActivityProvider(),
        ),

        // THEME (dark / light dari setting)
        ChangeNotifierProvider(
          create: (_) => ThemeProvider()..loadTheme(),
        ),

        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'HealthTrack',

            theme: ThemeData(
              brightness:
                  themeProvider.isDark ? Brightness.dark : Brightness.light,
              scaffoldBackgroundColor:
                  themeProvider.isDark ? const Color(0xFF0F2A44) : Colors.white,
              fontFamily: 'Roboto',
            ),

            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
