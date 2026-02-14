import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qbee/components/my_button.dart';
import 'package:qbee/components/my_drawer.dart';
import 'package:qbee/components/my_preview.dart';
import 'package:qbee/pages/video_page.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  final ImagePicker _picker = ImagePicker();

  // YOLO
  static const String _modelPath = 'yolo11n';
  YOLO? _yolo;
  bool _modelReady = false;

  // UI state
  File? _selectedImage;
  String _status = "Pick and image to begin.";
  bool _busy = false;

  // Dectect
  List<Map<String, dynamic>> _boxes = [];

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    setState(() {
      _busy = true;
      _modelReady = false;
      _status = "Loading model...";
    });

    try {
      final y = YOLO(modelPath: _modelPath, task: YOLOTask.detect);
      await y.loadModel();

      if (!mounted) return;

      setState(() {
        _yolo = y;
        _modelReady = true;
        _busy = false; // 👈 move this here
        _status = "Model ready ✅";
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _busy = false; // 👈 and here
        _status = "Model load failed ❌\n$e";
      });
    }
  }

  Future<void> _pick(ImageSource source) async {
    final XFile? x = await _picker.pickImage(source: source);
    if (x == null) return;

    setState(() {
      _selectedImage = File(x.path);
      _boxes = [];
      _status = _modelReady
          ? "Image loaded. Tap Detect."
          : "Image loaded. (Model not ready yet)";
    });
  }

  Future<void> _detect() async {
    if (!_modelReady || _yolo == null || _selectedImage == null) return;

    setState(() {
      _busy = true;
      _boxes = [];
      _status = "Runing detection ...";
    });

    try {
      final Uint8List bytes = await _selectedImage!.readAsBytes();
      final Map<String, dynamic> res = await _yolo!.predict(bytes);

      final raw = (res['boxes'] as List<dynamic>?) ?? const [];
      final parsed = <Map<String, dynamic>>[];

      for (final b in raw) {
        if (b is Map) parsed.add(Map<String, dynamic>.from(b));
      }

      if (!mounted) return;
      setState(() {
        _boxes = parsed;
        _busy = false;
        _status = "Done (${_boxes.length} detections)";
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _status = "Dectection failed: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photo"),
        actions: [
          IconButton(
            tooltip: "Reload model",
            icon: const Icon(Icons.refresh),
            onPressed: _busy ? null : _loadModel,
          ),

          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VideoPage()),
              );
            },
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Preview
            MyPreview(image: _selectedImage),

            // Status row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_busy)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  if (_busy) const SizedBox(width: 10),
                  Text(
                    _status,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Pick buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  MyButton(
                    label: "Camera",
                    icon: Icons.camera_alt,
                    isEnabled: !_busy,
                    onPressed: _busy ? null : () => _pick(ImageSource.camera),
                  ),

                  const SizedBox(width: 10),

                  MyButton(
                    label: "Gallery",
                    icon: Icons.photo_library,
                    isEnabled: !_busy,
                    onPressed: _busy ? null : () => _pick(ImageSource.gallery),
                  ),

                  const SizedBox(width: 10),

                  MyButton(
                    label: "Detect",
                    icon: Icons.search,
                    isEnabled: _modelReady && !_busy && _selectedImage != null,
                    onPressed: _detect,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            const Divider(height: 18),

            Expanded(
              child: _boxes.isEmpty
                  ? const Center(child: Text("No detections yet"))
                  : ListView.separated(
                      itemCount: _boxes.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final b = _boxes[i];
                        final name = (b['className'] ?? b['class'] ?? 'Unknown')
                            .toString();
                        final conf = (b['confidence'] is num)
                            ? (b['confidence'] as num).toDouble()
                            : 0.0;

                        return ListTile(
                          title: Text(name),
                          subtitle: Text(
                            "Confidence: ${(conf * 100).toStringAsFixed(1)}%",
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
