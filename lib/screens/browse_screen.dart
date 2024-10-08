import 'package:flutter/material.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text(
          'VR Cinema',
          style: TextStyle(color: Colors.black),
        ),
        // backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: Icon(
              Icons.apps,
              color: Colors.black,
            ),
            onPressed: () {
              _showAppsDialog(context);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onPressed: () {
              _showMoreOptions(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          // Favorites Section
          _sectionTitle('Favorites', Colors.orange),
          _buildFavoriteItem(context, Icons.folder, 'Download', '0', '0', 'Download Folder'),
          _buildFavoriteItem(context, Icons.folder, 'Movies', '0', '0', 'Movies Folder'),
          _buildFavoriteItem(context, Icons.music_note, 'Music', '0', '0', 'Music Folder'),
          _buildFavoriteItem(context, Icons.folder, 'WhatsApp Video', '0', '0', 'WhatsApp Video Folder'),
          _buildFavoriteItem(context, Icons.folder, 'History', '0', '0', 'History Folder'),

          SizedBox(height: 20),

          // Storages Section
          _sectionTitle('Storages', Colors.orange),
          _buildStorageItem(context, Icons.folder, 'Internal memory', 'Internal Storage'),

          SizedBox(height: 20),

          // Local Network Section
          _sectionTitle('Local Network', Colors.orange),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'Looking for network shares..',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Colors.black87,
      //   selectedItemColor: Colors.orange,
      //   unselectedItemColor: Colors.grey,
      //   currentIndex: 2, // Set Browse as the current screen
      //   onTap: (index) => _onBottomNavigationTapped(index, context),
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.videocam),
      //       label: 'Video',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.audiotrack),
      //       label: 'Audio',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.folder),
      //       label: 'Browse',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.playlist_play),
      //       label: 'Playlists',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.more_horiz),
      //       label: 'More',
      //     ),
      //   ],
      // ),
    );
  }

  // Widget for Section Title
  Widget _sectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Widget for each Favorite Item
  Widget _buildFavoriteItem(BuildContext context, IconData icon, String title, String folderCount, String fileCount, String folderName) {
    return ListTile(
      leading: Icon(icon, size: 40, color: Colors.grey),
      title: Text(title, style: TextStyle(fontSize: 18)),
      subtitle: Text('$folderCount folder · $fileCount file'),
      trailing: Icon(Icons.more_vert),
      onTap: () {
        _openFolder(context, folderName);
      },
    );
  }

  // Widget for Storage Item
  Widget _buildStorageItem(BuildContext context, IconData icon, String title, String storageName) {
    return ListTile(
      leading: Icon(icon, size: 40, color: Colors.grey),
      title: Text(title, style: TextStyle(fontSize: 18)),
      trailing: Icon(Icons.more_vert),
      onTap: () {
        _openFolder(context, storageName);
      },
    );
  }

  // Function to handle bottom navigation taps
  void _onBottomNavigationTapped(int index, BuildContext context) {
    String screenName;
    switch (index) {
      case 0:
        screenName = 'Video Screen';
        break;
      case 1:
        screenName = 'Audio Screen';
        break;
      case 2:
        screenName = 'Browse Screen';
        break;
      case 3:
        screenName = 'Playlists Screen';
        break;
      case 4:
        screenName = 'More Screen';
        break;
      default:
        screenName = 'Unknown';
    }
    _showScreen(context, screenName);
  }

  // Show a dialog for the Apps button
  void _showAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Apps"),
          content: Text("This is where apps will be displayed."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Show a dialog for the More button
  void _showMoreOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("More Options"),
          content: Text("This is where more options will be displayed."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Open a folder and show a placeholder screen
  void _openFolder(BuildContext context, String folderName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FolderScreen(folderName: folderName),
      ),
    );
  }

  // Show a different screen from bottom navigation
  void _showScreen(BuildContext context, String screenName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenericScreen(screenName: screenName),
      ),
    );
  }
}

class FolderScreen extends StatelessWidget {
  final String folderName;

  FolderScreen({required this.folderName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(folderName),
      ),
      body: Center(
        child: Text('Contents of $folderName will be shown here'),
      ),
    );
  }
}

class GenericScreen extends StatelessWidget {
  final String screenName;

  GenericScreen({required this.screenName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(screenName),
      ),
      body: Center(
        child: Text('This is the $screenName'),
      ),
    );
  }
}