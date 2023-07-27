import 'package:flutter/material.dart';
import 'package:untitled/pages/add_text_page.dart';
import 'package:untitled/youtubeplayer.dart';
import 'package:untitled/functions/user_info.dart';


class PlaylistPage extends StatefulWidget {
  final BookDB book;
  PlaylistPage({required this.book, Key? key}) : super(key: key);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {

  List<Map<String, dynamic>> song_imageUrl_list = [];
  int counter = 0;
  
  @override
  void initState() {
    super.initState();
    for (var image in widget.book.images) {
      for (var song in image.songs) {
        song_imageUrl_list.add({"song": song, "imageUrl": image.imageUrl});
      }
    }
  }

  Widget buildSongItem(int index) {
    String songName = song_imageUrl_list[index]['song'].title;
    return ListTile(
      leading: Icon(Icons.music_note),
      title: Text(songName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            MainAxisAlignment.end, // Align the icons to the right side
        children: [
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => YoutubePlayerPage(song_imageUrl_list: song_imageUrl_list, index: index),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // FIXME: 어디에서도 안쓰이는..?
  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff31795B),
        title: Row(
          children: [
            Image.asset('assets/olive_icon.png', width: 30, height: 30),
            SizedBox(width: 4),
            Text(
              "${widget.book.title} Playlist",
              style: TextStyle(color: Colors.white),
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
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xff31795B),
        ),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                height: 170,
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
                                child: Image.network(
                                widget.book.images[0].imageUrl, // Display the book image
                                width: 140,
                                height: 200,
                              ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.book.title,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      widget.book.author,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Color(0xffE6F0EC),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '직접 음악 추가하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) => AddTextPage(
                          book: widget.book,
                          youtubeInfos: [],
                          localPath: '',
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Color(0xffE6F0EC),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '글귀와 함께하는 음악 추가하기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Card(
                    elevation: 4,
                    child: Container(
                      width: double.infinity,
                      height: song_imageUrl_list.length*60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Color(0xffffffff),
                      ),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(), // 이 부분을 추가해주시면 됩니다.
                        itemCount: song_imageUrl_list.length,
                        itemBuilder: (context, index) {
                          return buildSongItem(index);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
