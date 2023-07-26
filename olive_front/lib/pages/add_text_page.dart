import 'package:flutter/material.dart';
import 'package:untitled/camera_dialog.dart';
import 'package:untitled/functions/recommend_functions.dart';
import 'package:untitled/functions/api_functions.dart';
import 'package:untitled/functions/user_info.dart';
import 'dart:io';

class AddTextPage extends StatefulWidget {
  final String bookId;
  final List<YoutubeVideoInfo> youtubeInfos;
  final String localPath;
  AddTextPage({Key? key, required this.bookId, required this.youtubeInfos, required this.localPath}) : super(key: key);
  
  
  @override
  _AddTextPageState createState() => _AddTextPageState();
}

class _AddTextPageState extends State<AddTextPage> {
  int counter = 0;
  List<String>? songNames;
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    songNames = widget.youtubeInfos.map((info) =>
    info.videoTitle.length > 20
        ? info.videoTitle.substring(0, 20) + '...'
        : info.videoTitle
    ).toList();
    isSelected = List<bool>.filled(songNames!.length, false);
  }

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  Widget buildSongItem(int index) {
    String songName = songNames![index];
    return ListTile(
      title: Text(songName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.add),
            color: isSelected[index] ? Colors.grey : Colors.black,
            onPressed: () {
              setState(() {
                isSelected[index] = !isSelected[index];
              });
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fileExists = File(widget.localPath).existsSync();
    print("songNames:$songNames");
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/olive_icon.png', width: 30, height: 30),
            SizedBox(width: 4),
            Text(
              "글귀와 추천음악 추가하기",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => CameraDialog(bookId: widget.bookId),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Color(0xff31795B),
                    ),
                    child: Center(
                      child: Text(
                        '글귀 사진 추가하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => CameraDialog(bookId: widget.bookId),
                    );
                  },
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: fileExists
                          ? Image.file(
                        File(widget.localPath),
                        fit: BoxFit.cover,  // or BoxFit.fill
                        height: 300,
                        width: double.infinity,
                      ) : Icon(Icons.add, size: 100),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Color(0xff31795B),
                ),
                child: Center(
                  child: Text(
                    'AI가 추천해주는 노래 찾기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  if (counter != 0) SizedBox(height: 16),
                ],
              ),
              Column(
                children: [
                  if(counter != 0)
                    Column(
                      children: [
                        if (songNames != null)
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            elevation: 4,
                            child: Container(
                              width: double.infinity,
                              height: 320,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: Color(0xffffffff),
                              ),
                              child: ListView.builder(
                                itemCount: songNames!.length,
                                itemBuilder: (context, index) {
                                  return buildSongItem(index);
                                },
                              ),
                            ),
                          ),
                        SizedBox(height: 16),
                      ],
                    ),
                ],
              ),
               ElevatedButton(
                onPressed: () {
                  List<SongDB> songs = [];

                  // FIXME: remove this after making selecting songs
                  isSelected = List<bool>.filled(songNames!.length, true);

                  // TODO: 노래 하나도 선택 안되었으면 완료버튼 눌리면 안됨 (서버측 에러)
                  
                  for (var v in widget.youtubeInfos) {
                    if (isSelected[widget.youtubeInfos.indexOf(v)]) {
                      songs.add(SongDB(title: v.videoTitle, songUrl: v.url, songId: v.videoId));
                    }
                  }
                  addImageAndSongs(widget.bookId, File(widget.localPath), songs);
                  
                  Navigator.pop(context);
                },
                child: Text('완료'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

