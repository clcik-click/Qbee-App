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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: ElevatedButton.icon(
        onPressed: isEnabled ? onPressed : null,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? colorScheme.primary
              : colorScheme.surface, // softer disabled background
          foregroundColor: isEnabled
              ? colorScheme.onPrimary
              : colorScheme.onSurface.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: isEnabled ? 3 : 0,
        ),
      ),
    );
  }
}
