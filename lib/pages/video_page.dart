import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ultralytics_yolo/yolo.dart';
import 'package:ultralytics_yolo/yolo_view.dart';

import 'package:qbee/components/my_drawer.dart';
import 'package:qbee/models/model_provider.dart';
import 'package:qbee/viewmodels/video_vm.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final borderColor = cs.onSurface.withOpacity(0.12);
    final overlayBg = cs.surface.withOpacity(0.85);

    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<ModelProvider, VideoVM>(
          create: (_) => VideoVM(),
          update: (_, modelProvider, vm) {
            vm ??= VideoVM();
            vm.setModelPath(modelProvider.modelPath);
            return vm;
          },
        ),
      ],
      child: Consumer2<ModelProvider, VideoVM>(
        builder: (context, modelProvider, vm, _) {
          final modelPath = modelProvider.modelPath;

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
                          // key forces YOLOView to re-create when model changes
                          key: ValueKey(modelPath),
                          modelPath: modelPath,
                          task: YOLOTask.detect,
                          onResult: vm.onResult,
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
                          "FPS: ${vm.fps.toStringAsFixed(1)}\nDetections: ${vm.detections}",
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
        },
      ),
    );
  }
}
