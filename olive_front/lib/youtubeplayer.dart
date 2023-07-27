import 'package:flutter/material.dart';
import 'package:untitled/functions/recommend_functions.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:untitled/functions/user_info.dart';

class YoutubePlayerPage extends StatefulWidget {
  final Map<String, dynamic> song_imageUrl;
  YoutubePlayerPage({required this.song_imageUrl, Key? key}) : super(key: key);

  @override
  _YoutubePlayerPageState createState() => _YoutubePlayerPageState();
}

class _YoutubePlayerPageState extends State<YoutubePlayerPage> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late List<String> _ids;
  int _currentIndex = 0;

  Future<void> _loadIds() async {
    _controller.load(widget.song_imageUrl['song'].songId);
  }

  void _playNext() {
    setState(() {
      _currentIndex++;
      if (_currentIndex < _ids.length) {
        _controller.load(_ids[_currentIndex]);
      } else {
        _currentIndex =
            0; // If we reach the end of the list, restart from the first video.
        _controller.load(_ids[_currentIndex]);
      }
    });
  }

  void _playPrevious() {
    setState(() {
      _currentIndex--;
      if (_currentIndex >= 0) {
        _controller.load(_ids[_currentIndex]);
      } else {
        _currentIndex = _ids.length -
            1; // If we reach the beginning of the list, go to the last video.
        _controller.load(_ids[_currentIndex]);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _controller = YoutubePlayerController(
      initialVideoId: '', // 사용자가 입력한 URL에 해당하는 비디오를 재생하기 위해 초기 값은 비워둡니다.
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
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if(details.primaryVelocity! > 0) { // When drag down
            Navigator.pop(context);
          }
        },
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: false,
          ),
          builder: (context, player) {
            return Stack(
              children: [
                Container(
                  height: screenHeight,
                  child: player,
                ),
                Center(
                  child: Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        // Use the image URL from Firebase Storage
                        image: NetworkImage(widget.song_imageUrl['imageUrl']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 16.0,
                  right: 16.0,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                    iconSize: 30.0,
                  ),
                ),
                Positioned(
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                  child: Column(
                    children: [
                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ProgressBar(
                              controller: _controller,
                              isExpanded: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: _playPrevious,
                            icon: Icon(Icons.skip_previous),
                            iconSize: 48.0,
                          ),
                          IconButton(
                            onPressed: _controller.value.isPlaying
                                ? _controller.pause
                                : _controller.play,
                            icon: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                            iconSize: 48.0,
                          ),
                          IconButton(
                            onPressed: _playNext,
                            icon: Icon(Icons.skip_next),
                            iconSize: 48.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

}