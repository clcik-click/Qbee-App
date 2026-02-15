import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF4C6FFF), // Electric blue
    secondary: Color(0xFF9B5DE5), // Vibrant purple
    surface: Color(0xFF121826), // Deep navy (better than pure black)
    tertiary: Color(0xFF1E293B),
    inversePrimary: Color(0xFFE2E8F0),
  ),

  scaffoldBackgroundColor: const Color(0xFF0F172A),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF121826),
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF4C6FFF),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    ),
  ),
);
