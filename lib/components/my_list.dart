import 'package:flutter/material.dart';

class MyList extends StatelessWidget {
  final List<Map<String, dynamic>> boxes;

  const MyList({super.key, required this.boxes});

  @override
  Widget build(BuildContext context) {
    final borderColor = Colors.grey.shade300;

    if (boxes.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text(
            "No detections yet",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    return Expanded(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: borderColor, width: 1.5),
              ),
            ),
            child: Row(
              children: const [
                Expanded(
                  child: Text(
                    "Object",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "Confidence",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Table body
          Expanded(
            child: ListView.builder(
              itemCount: boxes.length,
              itemBuilder: (context, i) {
                final b = boxes[i];

                final name = (b['className'] ?? b['class'] ?? 'Unknown')
                    .toString();

                final conf = (b['confidence'] is num)
                    ? (b['confidence'] as num).toDouble()
                    : 0.0;

                final isLast = i == boxes.length - 1;

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: isLast
                        ? null
                        : Border(
                            bottom: BorderSide(color: borderColor, width: 1),
                          ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(name, overflow: TextOverflow.ellipsis),
                      ),
                      Text(
                        "${(conf * 100).toStringAsFixed(1)}%",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
