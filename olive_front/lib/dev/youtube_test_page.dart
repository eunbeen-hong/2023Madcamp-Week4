import 'package:flutter/material.dart';
import 'package:untitled/youtube.dart';

class YoutubePage extends StatefulWidget {
  @override
  _YoutubePageState createState() => _YoutubePageState();
}

class _YoutubePageState extends State<YoutubePage> {
  String songTitle = '';
  String artist = '';
  String youtubeUrl = '';

  Future<void> _showDialogAndGetYouTubeUrl() async {
    TextEditingController songController = TextEditingController();
    TextEditingController artistController = TextEditingController();

    await showDialog( 
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Song and Artist Info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: songController,
                decoration: InputDecoration(labelText: 'Song Title'),
              ),
              TextField(
                controller: artistController,
                decoration: InputDecoration(labelText: 'Artist'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                songTitle = songController.text;
                artist = artistController.text;
                youtubeUrl = await getYouTubeUrl(songTitle, artist);
                Navigator.of(context).pop();
                _showResultDialog();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('YouTube URL'),
          content: Text(youtubeUrl),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube URL Viewer'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _showDialogAndGetYouTubeUrl,
          child: Text('Get YouTube URL'),
        ),
      ),
    );
  }
}
