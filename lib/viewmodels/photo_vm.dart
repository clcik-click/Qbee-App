import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../services/yolo_service.dart';

class PhotoVM extends ChangeNotifier {
  PhotoVM({ImagePicker? picker, YoloService? yoloService})
    : _picker = picker ?? ImagePicker(),
      _yolo = yoloService ?? YoloService();

  final ImagePicker _picker;
  final YoloService _yolo;

  bool busy = false;
  String status = "Pick an image to begin.";
  File? selectedImage;
  List<Map<String, dynamic>> boxes = [];

  String? _targetModelPath;

  bool get modelReady =>
      _targetModelPath != null &&
      _yolo.loadedModelPath == _targetModelPath &&
      _yolo.isReady;

  bool get canDetect => modelReady && !busy && selectedImage != null;

  Future<void> setModelPath(String modelPath) async {
    if (_targetModelPath == modelPath) return;
    _targetModelPath = modelPath;

    // reset UI-ish state
    boxes = [];
    status = "Switching to model ($modelPath)...";
    notifyListeners();

    await _loadModel(modelPath);
  }

  Future<void> _loadModel(String modelPath) async {
    busy = true;
    status = "Loading model ($modelPath)...";
    notifyListeners();

    try {
      await _yolo.load(modelPath);
      busy = false;
      status = "Model: $modelPath ready";
      notifyListeners();
    } catch (e) {
      busy = false;
      status = "Model load failed: $e";
      notifyListeners();
    }
  }

  Future<void> pick(ImageSource source) async {
    final x = await _picker.pickImage(source: source);
    if (x == null) return;

    selectedImage = File(x.path);
    boxes = [];
    status = modelReady ? "Image loaded. Tap Detect." : "Image loaded.";
    notifyListeners();
  }

  Future<void> detect() async {
    if (!canDetect) return;

    busy = true;
    boxes = [];
    status = "Running detection...";
    notifyListeners();

    try {
      final bytes = await selectedImage!.readAsBytes();
      final parsed = await _yolo.detect(bytes);

      boxes = parsed;
      busy = false;
      status = "Done (${boxes.length} detections)";
      notifyListeners();
    } catch (e) {
      busy = false;
      status = "Detection failed: $e";
      notifyListeners();
    }
  }
}
