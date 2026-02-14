import 'package:flutter/material.dart';
import 'package:qbee/components/my_drawer.dart';
import 'package:qbee/pages/photo_page.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video"),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PhotoPage()),
              );
            },
          ),
        ],
      ),
      drawer: MyDrawer(),
    );
  }
}
