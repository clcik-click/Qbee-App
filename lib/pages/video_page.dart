import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ultralytics_yolo/yolo.dart';
import 'package:ultralytics_yolo/yolo_view.dart';

import 'package:qbee/components/my_drawer.dart';
import 'package:qbee/model/model_provider.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  int _frameCount = 0;
  double _fps = 0.0;
  int _detections = 0;
  DateTime _lastTick = DateTime.now();

  void _onResult(List<dynamic> results) {
    _frameCount++;
    _detections = results.length;

    final now = DateTime.now();
    final elapsedMs = now.difference(_lastTick).inMilliseconds;

    if (elapsedMs >= 500) {
      _fps = _frameCount / (elapsedMs / 1000);
      _frameCount = 0;
      _lastTick = now;
      if (mounted) setState(() {});
    }
  }

  void _resetStats() {
    _frameCount = 0;
    _fps = 0.0;
    _detections = 0;
    _lastTick = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final modelPath = context.watch<ModelProvider>().modelPath;

    final borderColor = cs.onSurface.withOpacity(0.12);
    final overlayBg = cs.surface.withOpacity(0.85);

    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: Text("Video ($modelPath)"),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: YOLOView(
                    key: ValueKey(modelPath),
                    modelPath: modelPath,
                    task: YOLOTask.detect,
                    onResult: (results) {
                      _onResult(results);
                    },
                  ),
                ),
              ),

              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: overlayBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: Text(
                    "FPS: ${_fps.toStringAsFixed(1)}\nDetections: $_detections",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // When model changes, widget rebuilds anyway; reset stats to avoid stale values.
    _resetStats();
  }
}
