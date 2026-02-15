import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,

  colorScheme: ColorScheme.light(
    primary: const Color(0xFF3B5BDB), // Deep Blue
    secondary: const Color(0xFF7950F2), // Purple
    surface: const Color(0xFFF8F9FF), // Soft blue-ish background
    tertiary: Colors.white,
    inversePrimary: const Color(0xFF1E1E2E),
  ),

  scaffoldBackgroundColor: const Color(0xFFF8F9FF),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF3B5BDB),
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF3B5BDB),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    ),
  ),
);
