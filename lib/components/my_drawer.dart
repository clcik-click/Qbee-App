import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbee/theme/theme_provider.dart';
import 'package:qbee/models/model_provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final modelProvider = context.watch<ModelProvider>();

    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),

            const Text(
              "Dark Mode",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CupertinoSwitch(
              value: themeProvider.isDarkMode,
              onChanged: (_) => context.read<ThemeProvider>().toggleTheme(),
            ),

            const SizedBox(height: 28),

            const Text("Model", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            DropdownButton<String>(
              isExpanded: true,
              value: modelProvider.modelPath,
              items: const [
                DropdownMenuItem(
                  value: "yolo11n",
                  child: Text("yolo11n (nano)"),
                ),
                DropdownMenuItem(
                  value: "yolo11s",
                  child: Text("yolo11s (small)"),
                ),
                DropdownMenuItem(
                  value: "yolo11m",
                  child: Text("yolo11m (medium)"),
                ),
                DropdownMenuItem(
                  value: "yolo11l",
                  child: Text("yolo11l (large)"),
                ),
                DropdownMenuItem(
                  value: "yolo26n",
                  child: Text("yolo26n (nano)"),
                ),
                DropdownMenuItem(
                  value: "yolo26s",
                  child: Text("yolo26s (small)"),
                ),
                DropdownMenuItem(
                  value: "yolo26m",
                  child: Text("yolo26m (medium)"),
                ),
                DropdownMenuItem(
                  value: "yolo26l",
                  child: Text("yolo26l (large)"),
                ),
              ],
              onChanged: (v) {
                if (v == null) return;
                context.read<ModelProvider>().setModel(v);
                Navigator.pop(context); // close drawer after selecting
              },
            ),
          ],
        ),
      ),
    );
  }
}
