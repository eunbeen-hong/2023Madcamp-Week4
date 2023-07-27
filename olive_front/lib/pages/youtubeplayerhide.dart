import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerhide extends StatefulWidget {
  final List<Map<String, dynamic>> song_imageUrl_list;
  final int index;
  YoutubePlayerhide(
      {required this.song_imageUrl_list, required this.index, Key? key})
      : super(key: key);

  @override
  _YoutubePlayerhideState createState() => _YoutubePlayerhideState();
}

class _YoutubePlayerhideState extends State<YoutubePlayerhide> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  List<String> ids = [];
  int _currentIndex = 0;

  void _controllerCallback() {
    if (_controller.value.playerState == PlayerState.ended) {
      _playNext();
    }
  }

  void _playNext() {
    if (mounted) {
      // Check if the widget is still in the tree
      setState(() {
        _currentIndex++;
        if (_currentIndex < ids.length) {
          _controller.load(ids[_currentIndex]);
        } else {
          _currentIndex = 0;
          _controller.load(ids[_currentIndex]);
        }
      });
    }
  }

  void _playPrevious() {
    if (mounted) {
      // Check if the widget is still in the tree
      setState(() {
        _currentIndex--;
        if (_currentIndex >= 0) {
          _controller.load(ids[_currentIndex]);
        } else {
          _currentIndex = ids.length - 1;
          _controller.load(ids[_currentIndex]);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.index;

    for (var song_url in widget.song_imageUrl_list) {
      ids.add(song_url['song'].songId);
    }

    _controller = YoutubePlayerController(
      initialVideoId: widget.song_imageUrl_list[_currentIndex]['song'].songId,
      flags: const YoutubePlayerFlags(
        hideControls: true,
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
    _controller.addListener(_controllerCallback);
  }

  @override
  void dispose() {
    _controller.removeListener(_controllerCallback);
    _controller.dispose();
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(controller: _controller);
  }
}
