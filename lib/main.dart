import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart'; // For setting device orientation and hiding UI

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VideoGridScreen(),
    );
  }
}

class VideoGridScreen extends StatefulWidget {
  @override
  _VideoGridScreenState createState() => _VideoGridScreenState();
}

class _VideoGridScreenState extends State<VideoGridScreen> {
  List<String> videoPaths = [
    'assets/videos/yoriichi.mp4',
    'assets/videos/zenitsu.mp4',
    'assets/videos/tanjiro.mp4',
  ];

  List<String> filteredVideos = [];

  @override
  void initState() {
    super.initState();
    filteredVideos = videoPaths; // Initially show all videos
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search Videos'),
          content: TextField(
            decoration: const InputDecoration(
              hintText: 'Enter video name',
            ),
            onChanged: (value) {
              _filterVideos(value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Filter the video list based on the search query
  void _filterVideos(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredVideos = videoPaths;
      } else {
        filteredVideos = videoPaths
            .where((video) => video.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog(context); // Call search dialog
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two videos per row
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: filteredVideos.length,
        itemBuilder: (context, index) {
          String videoName = filteredVideos[index].split('/').last;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(videoPath: filteredVideos[index]),
                ),
              );
            },
            child: GridTile(
              footer: GridTileBar(
                backgroundColor: Colors.black54,
                title: Text(
                  videoName,
                  textAlign: TextAlign.center,
                ),
              ),
              child: Container(
                color: Colors.grey[500],
                child: Icon(
                  Icons.play_circle_outline,
                  size: 50,
                  color: Colors.orange,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;

  const VideoPlayerScreen({super.key, required this.videoPath});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _controlsVisible = true; // Track whether the controls are visible or not

  @override
  void initState() {
    super.initState();

    // Force landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    // Hide system UI (status bar and navigation buttons) for fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _controller = VideoPlayerController.asset(widget.videoPath);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    // Reset the system UI and orientation settings when closing the video
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge); // Show system UI again

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              onTap: () {
                // Toggle visibility of controls when tapping anywhere on the screen
                setState(() {
                  _controlsVisible = !_controlsVisible;
                });
              },
              child: Stack(
                children: [
                  Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                  // Show controls only if _controlsVisible is true
                  if (_controlsVisible) _buildVideoControls(),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildVideoControls() {
    return Positioned(
      bottom: 30,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10, color: Colors.white, size: 40),
                onPressed: () {
                  setState(() {
                    _controller.seekTo(
                      _controller.value.position - const Duration(seconds: 10),
                    );
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying ? _controller.pause() : _controller.play();
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.forward_10, color: Colors.white, size: 40),
                onPressed: () {
                  setState(() {
                    _controller.seekTo(
                      _controller.value.position + const Duration(seconds: 10),
                    );
                  });
                },
              ),
            ],
          ),
          // Video Progress Bar with timestamps
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Current Position Text
                Text(
                  _formatDuration(_controller.value.position),
                  style: const TextStyle(color: Colors.black),
                ),
                // Progress Bar
                Expanded(
                  child: VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      backgroundColor: Colors.grey,
                      bufferedColor: Colors.white.withOpacity(0.5),
                      playedColor: Colors.orange,
                    ),
                  ),
                ),
                // Total Duration Text
                Text(
                  _formatDuration(_controller.value.duration),
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to format the duration as mm:ss
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}