import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final Color background;
  final EdgeInsetsGeometry padding;

  const MyCard({
    super.key,
    required this.child,
    required this.borderColor,
    required this.background,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}
