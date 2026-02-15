import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qbee/components/yolo_box_painter.dart';

class MyPreview extends StatelessWidget {
  final File? image;
  final List<Map<String, dynamic>> boxes;

  const MyPreview({super.key, required this.image, required this.boxes});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: image == null
          ? const Center(child: Text("No image selected"))
          : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(image!, fit: BoxFit.contain),
                      CustomPaint(painter: YoloNormBoxPainter(boxes: boxes)),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
