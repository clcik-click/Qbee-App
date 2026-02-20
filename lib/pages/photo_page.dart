import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qbee/models/model_provider.dart';
import '../components/my_button.dart';
import '../components/my_card.dart';
import '../components/my_drawer.dart';
import '../components/my_list.dart';
import '../components/my_preview.dart';
import '../viewmodels/photo_vm.dart';
import 'video_page.dart';

class PhotoPage extends StatelessWidget {
  const PhotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<ModelProvider, PhotoVM>(
          create: (_) => PhotoVM(),
          update: (_, modelProvider, vm) {
            vm ??= PhotoVM();
            vm.setModelPath(modelProvider.modelPath);
            return vm;
          },
        ),
      ],
      child: Consumer2<ModelProvider, PhotoVM>(
        builder: (context, modelProvider, vm, _) {
          final theme = Theme.of(context);
          final borderColor = cs.onSurface.withOpacity(0.12);
          final sectionBg = cs.surface.withOpacity(0.60);

          return Scaffold(
            appBar: AppBar(
              title: Text("Photo (${modelProvider.modelPath})"),
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const VideoPage()),
                  ),
                ),
              ],
            ),
            drawer: const MyDrawer(),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // Status
                    MyCard(
                      borderColor: borderColor,
                      background: sectionBg,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (vm.busy)
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(cs.primary),
                              ),
                            ),
                          if (vm.busy) const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              vm.status,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: cs.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Preview
                    MyCard(
                      borderColor: borderColor,
                      background: sectionBg,
                      padding: const EdgeInsets.all(10),
                      child: MyPreview(
                        image: vm.selectedImage,
                        boxes: vm.boxes,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Buttons
                    MyCard(
                      borderColor: borderColor,
                      background: sectionBg,
                      child: Row(
                        children: [
                          MyButton(
                            label: "Camera",
                            icon: Icons.camera_alt,
                            isEnabled: !vm.busy,
                            onPressed: () => vm.pick(ImageSource.camera),
                          ),
                          const SizedBox(width: 10),
                          MyButton(
                            label: "Gallery",
                            icon: Icons.photo_library,
                            isEnabled: !vm.busy,
                            onPressed: () => vm.pick(ImageSource.gallery),
                          ),
                          const SizedBox(width: 10),
                          MyButton(
                            label: "Detect",
                            icon: Icons.search,
                            isEnabled: vm.canDetect,
                            onPressed: vm.detect,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // List
                    Expanded(
                      child: MyCard(
                        borderColor: borderColor,
                        background: sectionBg,
                        padding: EdgeInsets.zero,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: MyList(boxes: vm.boxes),
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
