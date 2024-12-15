import 'package:flutter/material.dart';
import 'package:frontend/screens/admin/admin.dart';
import 'package:frontend/screens/home/home.dart';

import 'screens/admin/screens/view_users.dart';
import 'screens/auth/login.dart';
import 'screens/auth/signup.dart';
import 'screens/home/screens/autism_diagnosis.dart';
import 'screens/home/screens/depression_diagnosis.dart';

import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color _seedColor = Colors.lightBlueAccent;
  static const bool _isDarkMode = false;

  static ColorScheme lightColorScheme =
      ColorScheme.fromSeed(seedColor: _seedColor, brightness: Brightness.light);

  static ColorScheme darkColorScheme =
      ColorScheme.fromSeed(seedColor: _seedColor, brightness: Brightness.dark);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => const HomeScreen(),
        '/allUsers': (context) => const ViewUsersScreen(),
        '/admin': (context) => const AdminScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/m-chat': (context) => const AutismDiagnosis(),
        '/pq9': (context) => const DepressionDiagnosis(),
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: MyApp.lightColorScheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: MyApp.darkColorScheme,
      ),
      themeMode: MyApp._isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
