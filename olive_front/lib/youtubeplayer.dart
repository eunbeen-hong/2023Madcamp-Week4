import 'package:flutter/material.dart';
import 'package:untitled/functions/recommend_functions.dart';
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
    Map<String, dynamic> rst = await imageToUrls();
    List<String> urls = rst['urls'];
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

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _controller = YoutubePlayerController(
      initialVideoId: '', // 사용자가 입력한 URL에 해당하는 비디오를 재생하기 위해 초기 값은 비워둡니다.
      flags: const YoutubePlayerFlags(
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Player'),
      ),
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: false,
        ),
        builder: (context, player) {
          return Column(
            children: [
              // YoutubePlayer 위젯
              player,

              const SizedBox(height: 16.0),

              // 버튼들
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _controller.value.isPlaying
                        ? _controller.pause
                        : _controller.play,
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  ),

                  IconButton(
                    onPressed: _playNext,
                    icon: Icon(Icons.skip_next),
                  ),

                  // Progress Bar
                  Expanded(
                    child: ProgressBar(
                      controller: _controller,
                      isExpanded: true,
                    ),
                  ),

                  // "Load Videos" 버튼 추가
                  ElevatedButton(
                    onPressed: _loadIds,
                    child: const Text('Load Videos'),
                  ),
                ],
              ),

              ElevatedButton(
                onPressed: () async {
                  Map<String, dynamic> rst = await imageToUrls();
                  List<String> urls = rst['urls'];
                  List<String> ids = await UrlsToYoutubeIds(urls);

                  // 이제 ids를 사용할 수 있습니다.
                  // 여기에 ids를 사용하는 코드를 작성하십시오.
                },
                child: const Text('test function'),
              ),
            ],
          );
        },
      ),
    );
  }
}
