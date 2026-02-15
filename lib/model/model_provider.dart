import 'package:flutter/material.dart';

class ModelProvider extends ChangeNotifier {
  String _modelPath = "yolo11n";

  String get modelPath => _modelPath;

  void setModel(String newModel) {
    if (_modelPath == newModel) return;
    _modelPath = newModel;
    notifyListeners();
  }
}
