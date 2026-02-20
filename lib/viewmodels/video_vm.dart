import 'package:flutter/foundation.dart';

class VideoVM extends ChangeNotifier {
  int _frameCount = 0;
  double fps = 0.0;
  int detections = 0;

  DateTime _lastTick = DateTime.now();
  String? _activeModelPath;

  // Call this whenever the modelPath changes
  void setModelPath(String modelPath) {
    if (_activeModelPath == modelPath) return;
    _activeModelPath = modelPath;
    resetStats();
  }

  void onResult(List<dynamic> results) {
    _frameCount++;
    detections = results.length;

    final now = DateTime.now();
    final elapsedMs = now.difference(_lastTick).inMilliseconds;

    // update every ~0.5s so we don't spam rebuilds
    if (elapsedMs >= 500) {
      fps = _frameCount / (elapsedMs / 1000.0);
      _frameCount = 0;
      _lastTick = now;
      notifyListeners();
    }
  }

  void resetStats() {
    _frameCount = 0;
    fps = 0.0;
    detections = 0;
    _lastTick = DateTime.now();
    notifyListeners();
  }
}
