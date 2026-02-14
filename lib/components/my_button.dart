import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isEnabled;

  const MyButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: isEnabled ? onPressed : null,
        icon: Icon(icon, color: isEnabled ? Colors.white : Colors.white70),
        label: Text(
          label,
          style: TextStyle(color: isEnabled ? Colors.white : Colors.white70),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? Theme.of(context).colorScheme.primary
              : Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: isEnabled ? 3 : 0,
        ),
      ),
    );
  }
}
