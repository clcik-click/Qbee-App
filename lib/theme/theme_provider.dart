import 'package:flutter/material.dart';

// Manages app theme (light / dark)
class ThemeProvider extends ChangeNotifier {
  // Stores current theme mode (default = light)
  ThemeMode _mode = ThemeMode.light;

  // Expose current mode (used in MaterialApp)
  ThemeMode get mode => _mode;

  // Helper: true if dark mode
  bool get isDarkMode => _mode == ThemeMode.dark;

  // Switch between light and dark
  void toggleTheme() {
    _mode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners(); // rebuild UI
  }

  // Set specific mode safely
  void setMode(ThemeMode newMode) {
    if (_mode == newMode) return; // avoid unnecessary rebuild
    _mode = newMode;
    notifyListeners();
  }
}
