import 'dart:typed_data';

import 'package:ultralytics_yolo/ultralytics_yolo.dart';

class YoloService {
  YOLO? _yolo;
  String? _loadedModelPath;

  bool get isReady => _yolo != null;
  String? get loadedModelPath => _loadedModelPath;

  Future<void> load(String modelPath) async {
    final y = YOLO(modelPath: modelPath, task: YOLOTask.detect);
    await y.loadModel();
    _yolo = y;
    _loadedModelPath = modelPath;
  }

  Future<List<Map<String, dynamic>>> detect(Uint8List bytes) async {
    final y = _yolo;
    if (y == null) return [];

    final res = await y.predict(bytes);
    final raw = (res['boxes'] as List<dynamic>?) ?? const [];

    return raw
        .whereType<Map>()
        .map((b) => Map<String, dynamic>.from(b))
        .toList();
  }
}
