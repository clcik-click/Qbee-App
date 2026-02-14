import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbee/pages/photo_page.dart';
import 'package:qbee/theme/dark_mode.dart';
import 'package:qbee/theme/light_mode.dart';
import 'package:qbee/theme/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PhotoPage(),

      theme: lightMode,
      darkTheme: darkMode,
      themeMode: themeProvider.mode,
    );
  }
}
