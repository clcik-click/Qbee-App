import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qbee/components/my_card.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';

import 'package:qbee/components/my_button.dart';
import 'package:qbee/components/my_drawer.dart';
import 'package:qbee/components/my_list.dart';
import 'package:qbee/components/my_preview.dart';
import 'package:qbee/model/model_provider.dart';
import 'package:qbee/pages/video_page.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  final ImagePicker _picker = ImagePicker();

  YOLO? _yolo;
  bool _modelReady = false;
  bool _busy = false;

  String _status = "Pick an image to begin.";
  File? _selectedImage;

  List<Map<String, dynamic>> _boxes = [];
  String? _loadedModelPath;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final modelPath = context.watch<ModelProvider>().modelPath;

    if (_loadedModelPath != modelPath && !_busy) {
      setState(() {
        _status = "Switching to model ($modelPath)...";
        _modelReady = false;
        _boxes = [];
      });

      _loadModel(modelPath);
    }
  }

  Future<void> _loadModel(String modelPath) async {
    setState(() {
      _busy = true;
      _modelReady = false;
      _boxes = [];
      _status = "Loading model ($modelPath)...";
    });

    try {
      final y = YOLO(modelPath: modelPath, task: YOLOTask.detect);
      await y.loadModel();

      if (!mounted) return;
      setState(() {
        _yolo = y;
        _loadedModelPath = modelPath;
        _modelReady = true;
        _busy = false;
        _status = "Model: $modelPath ready";
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _status = "Model load failed: $e";
      });
    }
  }

  Future<void> _pick(ImageSource source) async {
    final XFile? x = await _picker.pickImage(source: source);
    if (x == null) return;

    setState(() {
      _selectedImage = File(x.path);
      _boxes = [];
      _status = _modelReady ? "Image loaded. Tap Detect." : "Image loaded.";
    });
  }

  Future<void> _detect() async {
    if (!_modelReady || _yolo == null || _selectedImage == null) return;

    setState(() {
      _busy = true;
      _boxes = [];
      _status = "Running detection...";
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
        _status = "Detection failed: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final canDetect = _modelReady && !_busy && _selectedImage != null;
    final modelPath = context.watch<ModelProvider>().modelPath;

    // Theme-driven styling
    final borderColor = cs.onSurface.withOpacity(0.12);
    final sectionBg = cs.surface.withOpacity(0.60);
    final statusTextStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: cs.onSurface,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Photo ($modelPath)"),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        elevation: 0,
        actions: [
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
      drawer: const MyDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // 1) Status
              MyCard(
                borderColor: borderColor,
                background: sectionBg,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_busy)
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(cs.primary),
                        ),
                      ),
                    if (_busy) const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        _status,
                        style: statusTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 2) Preview
              MyCard(
                borderColor: borderColor,
                background: sectionBg,
                padding: const EdgeInsets.all(10),
                child: MyPreview(image: _selectedImage, boxes: _boxes),
              ),

              const SizedBox(height: 12),

              // 3) Buttons
              MyCard(
                borderColor: borderColor,
                background: sectionBg,
                child: Row(
                  children: [
                    MyButton(
                      label: "Camera",
                      icon: Icons.camera_alt,
                      isEnabled: !_busy,
                      onPressed: () => _pick(ImageSource.camera),
                    ),
                    const SizedBox(width: 10),
                    MyButton(
                      label: "Gallery",
                      icon: Icons.photo_library,
                      isEnabled: !_busy,
                      onPressed: () => _pick(ImageSource.gallery),
                    ),
                    const SizedBox(width: 10),
                    MyButton(
                      label: "Detect",
                      icon: Icons.search,
                      isEnabled: canDetect,
                      onPressed: _detect,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 4) List
              Expanded(
                child: MyCard(
                  borderColor: borderColor,
                  background: sectionBg,
                  padding: EdgeInsets.zero,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: MyList(boxes: _boxes),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
