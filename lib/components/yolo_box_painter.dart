import 'package:flutter/material.dart';

class YoloNormBoxPainter extends CustomPainter {
  final List<Map<String, dynamic>> boxes;

  const YoloNormBoxPainter({required this.boxes});

  @override
  void paint(Canvas canvas, Size size) {
    if (boxes.isEmpty) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final b in boxes) {
      final x1 = _num(b['x1_norm']);
      final y1 = _num(b['y1_norm']);
      final x2 = _num(b['x2_norm']);
      final y2 = _num(b['y2_norm']);
      if (x1 == null || y1 == null || x2 == null || y2 == null) continue;

      final rect = Rect.fromLTRB(
        x1 * size.width,
        y1 * size.height,
        x2 * size.width,
        y2 * size.height,
      );

      canvas.drawRect(rect, paint);

      final name = (b['className'] ?? b['class'] ?? '').toString();
      final conf = (b['confidence'] is num)
          ? (b['confidence'] as num).toDouble()
          : null;

      final label = name.isEmpty
          ? ""
          : (conf == null ? name : "$name ${(conf * 100).toStringAsFixed(0)}%");

      if (label.isNotEmpty) {
        final tp = TextPainter(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              backgroundColor: Colors.black54,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        tp.paint(
          canvas,
          Offset(rect.left, (rect.top - tp.height).clamp(0, size.height)),
        );
      }
    }
  }

  double? _num(dynamic v) => (v is num) ? v.toDouble() : null;

  @override
  bool shouldRepaint(covariant YoloNormBoxPainter oldDelegate) {
    return oldDelegate.boxes != boxes;
  }
}
