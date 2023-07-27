import 'package:flutter/material.dart';
import 'package:untitled/functions/recommend_functions.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:untitled/functions/user_info.dart';

class YoutubePlayerPage extends StatefulWidget {
  final List<Map<String, dynamic>> song_imageUrl_list;
  int index;
  YoutubePlayerPage(
      {required this.song_imageUrl_list, required this.index, Key? key})
      : super(key: key);

  @override
  _YoutubePlayerPageState createState() => _YoutubePlayerPageState();
}

class _YoutubePlayerPageState extends State<YoutubePlayerPage> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  List<String> _ids = [];

  void _playNext() {
    setState(() {
      widget.index++;
      if (widget.index < _ids.length) {
        _controller.load(_ids[widget.index]);
      } else {
        widget.index =
            0; // If we reach the end of the list, restart from the first video.
        _controller.load(_ids[widget.index]);
      }
    });
  }

  void _playPrevious() {
    setState(() {
      widget.index--;
      if (widget.index >= 0) {
        _controller.load(_ids[widget.index]);
      } else {
        widget.index = _ids.length -
            1; // If we reach the beginning of the list, go to the last video.
        _controller.load(_ids[widget.index]);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    for (var song_url in widget.song_imageUrl_list) {
      _ids.add(song_url['song'].songId);
    }

    _controller = YoutubePlayerController(
      initialVideoId: widget.song_imageUrl_list[widget.index]['song'].songId,
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
          if (details.primaryVelocity! > 0) {
            // When drag down
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
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: player,
                  ),
                ),
                Center(
                  child: Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        // Use the image URL from Firebase Storage
                        image: NetworkImage(
                            widget.song_imageUrl_list[0]['imageUrl']),
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
                          ValueListenableBuilder(
                            valueListenable: _controller,
                            builder: (context, value, child) {
                              return IconButton(
                                onPressed: () {
                                  if (_controller.value.isPlaying) {
                                    _controller.pause();
                                  } else {
                                    _controller.play();
                                  }
                                },
                                icon: Icon(
                                  _controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
                                iconSize: 48.0,
                              );
                            },
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