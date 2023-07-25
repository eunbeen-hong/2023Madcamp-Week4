import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerPage extends StatefulWidget {
  @override
  _YoutubePlayerPageState createState() => _YoutubePlayerPageState();
}

class _YoutubePlayerPageState extends State<YoutubePlayerPage> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;

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

  void _playYoutubeVideoFromUrl() {
    // 사용자가 입력한 URL에서 비디오 ID를 추출합니다.
    var videoId = YoutubePlayer.convertUrlToId(_idController.text) ?? '';
    if (videoId.isNotEmpty) {
      // 추출한 비디오 ID로 플레이어를 업데이트합니다.
      _controller.load(videoId);
    } else {
      // 비디오 ID가 비어있을 경우, 스낵바를 표시합니다.
      _showSnackBar('Invalid YouTube URL');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Player'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            bottomActions: [
              CurrentPosition(),
              ProgressBar(isExpanded: true),
              PlayPauseButton()
            ],
            onEnded: (data) {
              // 비디오 재생이 끝나면 플레이어를 일시정지합니다.
              _controller.pause();
              _showSnackBar('Next Video Started!');
            },
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _idController,
            decoration: InputDecoration(
              labelText: 'Enter YouTube URL',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _playYoutubeVideoFromUrl,
            child: const Text('Play Video'),
          ),
        ],
      ),
    );
  }
}
