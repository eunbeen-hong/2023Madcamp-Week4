import 'package:flutter/material.dart';
import 'package:untitled/functions/recommend_functions.dart';
import 'package:untitled/functions/api_functions.dart';
import 'package:untitled/functions/user_info.dart';
import 'package:untitled/pages/youtube.dart';

class AddSongDialog extends StatefulWidget {
  final BookDB book;

  AddSongDialog({Key? key, required this.book}) : super(key: key);

  @override
  _AddSongDialogState createState() => _AddSongDialogState();
}

class _AddSongDialogState extends State<AddSongDialog> {
  TextEditingController _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('노래 추가하기'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: '노래 검색',
              hintText: '노래 제목을 입력하세요',
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              String songTitle = _searchController.text;
              
              List<String> urls = [];
              for (var i = 0; i < 3; i++){
                String url = await getYouTubeUrl(songTitle, "", number: i);
                urls.add(url);
              }
              List<YoutubeVideoInfo> videos = await getUrlVideoInfo(urls);

              for (var video in videos) {
                buildSongItem(video);
              }

            },
            child: Text('추가하기'),
          ),
        ],
      ),
    );
  }

  Widget buildSongItem(YoutubeVideoInfo video) {
    return ListTile(
      title: Text(video.videoTitle),
      trailing: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          SongDB song = SongDB(
            title: video.videoTitle,
            songUrl: video.url,
            songId: video.videoId,
          );
          
          addSongs(widget.book.bookId, [song]);
          
          Navigator.of(context).pop();
        },
      ),
    );
  }
}