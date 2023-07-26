import 'package:flutter/material.dart';
import 'package:untitled/camera_dialog.dart';
import 'package:untitled/functions/recommend_functions.dart';
import 'package:untitled/functions/user_info.dart';
import 'dart:io';

import 'package:untitled/pages/playlist_page.dart';

class AddTextPage extends StatefulWidget {
  final List<YoutubeVideoInfo> youtubeInfos;
  final String localPath;

  final BookDB book;
  AddTextPage({Key? key,required this.youtubeInfos, required this.localPath, required this.book}) : super(key: key);
  
  
  @override
  _AddTextPageState createState() => _AddTextPageState();
}

class _AddTextPageState extends State<AddTextPage> {
  int counter = 0;
  List<String>? songNames;
  late List<bool> isSelected;
  String bookName = '데미안';

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
    print("counter:$counter");
    print("songNames:$songNames");
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
                      builder: (context) => CameraDialog(book: widget.book,),
                    );
                    incrementCounter();
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
                      builder: (context) => CameraDialog(book: widget.book,),
                    );
                    incrementCounter();
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
                      )
                          : Icon(Icons.add, size: 100),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '$bookName의 다음 구절에 어울리는 음악',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              SizedBox(height: 16),
              if (fileExists != null)
                Column(
                  children: [
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
                        child: SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              for (var i = 0; i < songNames!.length; i++)
                              buildSongItem(i),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 4,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) => PlaylistPage(book: widget.book),
                          );
                          incrementCounter();
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
                              '추가 완료하기',
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
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

