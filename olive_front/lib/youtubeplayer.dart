import 'package:flutter/material.dart';
import 'package:untitled/recommend_functions.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerPage extends StatefulWidget {
  @override
  _YoutubePlayerPageState createState() => _YoutubePlayerPageState();
}

class _YoutubePlayerPageState extends State<YoutubePlayerPage> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late List<String> _ids;
  int _currentIndex = 0;

  Future<void> _loadIds() async {
    List<String> urls = await imageToUrls();
    _ids = await UrlsToYoutubeIds(urls);
    _controller.load(_ids[_currentIndex]);
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
      appBar: null,
      body: YoutubePlayerBuilder(
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
                      image: AssetImage('assets/example.jpg'),
                      fit:BoxFit.cover,
                    )
                  ),
                )

              ),
              Positioned(
                bottom: 16.0,
                left: 16.0,
                right: 16.0,
                child: Column(
                  children: [
                    // 버튼들
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
                          onPressed:
                              _playPrevious, // You will need to implement _playPrevious
                          icon: Icon(Icons.skip_previous),
                          iconSize: 48.0, // Set the icon size as desired
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
                          iconSize: 48.0, // Set the icon size as desired
                        ),
                        IconButton(
                          onPressed: _playNext,
                          icon: Icon(Icons.skip_next),
                          iconSize: 48.0, // Set the icon size as desired
                        ),
                      ],
                    ), // closing the IconButton Row
                  ], // closing the Column
                ), // closing the Positioned
              )
            ], // closing the Stack
          ); // closing the return
        }, // closing the builder
      ), // closing the YoutubePlayerBuilder
    ); // closing the Scaffold
  }
}


                  


                      // mainAxisAlignment: MainAxisAlignment.center,
                      // children: [
                      //   IconButton(
                      //     onPressed: _controller.value.isPlaying
                      //         ? _controller.pause
                      //         : _controller.play,
                      //     icon: Icon(
                      //       _controller.value.isPlaying
                      //           ? Icons.pause
                      //           : Icons.play_arrow,
                      //     ),
                      //   ),

                      //   IconButton(
                      //     onPressed: _playNext,
                      //     icon: Icon(Icons.skip_next),
                      //   ),

                      //   // Progress Bar
                      //   Expanded(
                      //     child: ProgressBar(
                      //       controller: _controller,
                      //       isExpanded: true,