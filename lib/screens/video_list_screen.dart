import 'package:flutter/material.dart';

class VideoListScreen extends StatelessWidget {
  const VideoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'VR Cinema',
          style: TextStyle(color: Colors.black),
        ),
        // backgroundColor: Colors.black,
      ),
      body: const Center(
          child: Text("VideoList Screen")
      ),
    );
  }
}