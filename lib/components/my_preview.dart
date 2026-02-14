import 'dart:io';

import 'package:flutter/material.dart';

class MyPreview extends StatelessWidget {
  final File? image;

  const MyPreview({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
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
                child: Image.file(image!, fit: BoxFit.contain),
              ),
      ),
    );
  }
}
