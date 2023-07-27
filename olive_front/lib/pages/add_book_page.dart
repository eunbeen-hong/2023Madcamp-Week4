import 'package:flutter/material.dart';
import 'package:untitled/pages/search_category_page.dart';
import 'package:untitled/pages/search_book_page.dart';
import 'package:untitled/functions/recommend_functions.dart';
import 'package:untitled/functions/api_functions.dart';
import 'package:untitled/functions/user_info.dart';

class AddBookPage extends StatefulWidget {
  final VoidCallback onBookAdded;
  final Map<String, dynamic>? selectedBook;
  List<Category>? selectedCategories;
  final List<YoutubeVideoInfo>? youtubeInfos;

  AddBookPage({Key? key, required this.onBookAdded, required this.youtubeInfos, required this.selectedBook, required this.selectedCategories}) : super(key: key);
  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  int counter = 0;
  List<String>? songNames;
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    if (widget.youtubeInfos != null) {
      songNames = widget.youtubeInfos!.map((info) =>
      info.videoTitle.length > 20
          ? info.videoTitle.substring(0, 20) + '...'
          : info.videoTitle
      ).toList();
      isSelected = List<bool>.filled(songNames!.length, false);
    }
  }

    void incrementCounter() {
    // Function to increment the counter when the InkWell is tapped.
    setState(() {
      counter++;
    });
  }


  Widget buildSongItem(int index) {
    String songName = songNames![index];
    return ListTile(
      //leading: Icon(Icons.music_note),
      title: Text(songName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end, // Align the icons to the right side
        children: [
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () {
              // TODO: Implement play functionality for the song at the given index.
            },
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
    print("What is selectedBook?21: ${widget.selectedBook}");
    //print("What is selectedBook?212: $selectedBook");
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/olive_icon.png', width: 30, height: 30), // 이미지 추가
            SizedBox(width: 4), // 이미지와 텍스트 사이의 간격
            Text('읽고 있는 책 추가하기',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),// 텍스트 추가
          ],
        ),
        automaticallyImplyLeading: false, // 뒤로 가기 버튼 숨김
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            iconSize: 30, // 아이콘 크기 설정
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder( // 모서리 라운드 효과 설정
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4, // 그림자 효과 크기 조정
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => SearchBookPage(onBookAdded: widget.onBookAdded),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration( // 모서리 둥글기 설정
                      borderRadius: BorderRadius.circular(16.0),
                      color: Color(0xff31795B),
                    ),
                    child: Center(
                      child: Text(
                        '책 검색하기',
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
              SizedBox(height: 16),
              if (widget.selectedBook != null)
                Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 4,
                      child: Container(
                        width: double.infinity,
                        height: 240,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Color(0xffffffff),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                widget.selectedBook!['image'], // Display the book image
                                width: 140,
                                height: 200,
                              ),
                          
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Card(
                      shape: RoundedRectangleBorder( // 모서리 라운드 효과 설정
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 4, // 그림자 효과 크기 조정
                      child: GestureDetector(
                        onTap: () {
                          incrementCounter();
                          //initState();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration( // 모서리 둥글기 설정
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
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              if (widget.youtubeInfos != null && counter != 0)
                Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 4,
                      child: Container(
                        width: double.infinity,
                        height: widget.youtubeInfos!.length*60+20,
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
                      shape: RoundedRectangleBorder( // 모서리 라운드 효과 설정
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 4, // 그림자 효과 크기 조정
                      child: GestureDetector(
                        onTap: () async{
                          List<Category>? selectedCategories = await showDialog<List<Category>>(
                            context: context,
                            builder: (context) => SearchCategoryPage(onBookAdded: widget.onBookAdded, selectedBook: widget.selectedBook, selectedCategories: widget.selectedCategories, youtubeInfos: widget.youtubeInfos!),
                          );
                          print("widget.selectedCategories: ${widget.selectedCategories}");

                          // Handle the selected categories if available.
                          if (selectedCategories != null && selectedCategories.isNotEmpty) {
                            setState(() {
                              // Update the selectedCategories state variable with the selected categories.
                              widget.selectedCategories = selectedCategories;
                            });
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration( // 모서리 둥글기 설정
                            borderRadius: BorderRadius.circular(16.0),
                            color: Color(0xff31795B),
                          ),
                          child: Center(
                            child: Text(
                              '카테고리 고르기',
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
                    SizedBox(height: 16),
                  ],
                ),
              if (widget.selectedCategories != null && widget.selectedCategories!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 4,
                      child: Container(
                        width: double.infinity,
                        height: 60.0 * widget.selectedCategories!.length,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Color(0xffffffff),
                        ),
                        child: SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          child: Column(
                            children: widget.selectedCategories!
                                .map((category) => ListTile(
                              title: Text(category.name),
                              // ... 추가적인 카테고리 정보를 표시할 수 있음
                            ))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Card(
                      shape: RoundedRectangleBorder( // 모서리 라운드 효과 설정
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 4, // 그림자 효과 크기 조정
                      child: GestureDetector(
                        onTap: () async {
                          print(widget.selectedBook!['image']);
                          ImageDB image = ImageDB(
                              imageUrl: widget.selectedBook!['image'],
                              songs: widget.youtubeInfos!.map((info) => SongDB(
                                title: info.videoTitle,
                                songUrl: info.url,
                                songId: info.videoId,
                              )).toList(),
                            );

                          BookDB b = BookDB(
                            bookId: '',
                            title: widget.selectedBook!['title'] ?? '',
                            author: widget.selectedBook!['author'] ?? '' ?? '',
                            last_accessed: '',
                            bookDesc: widget.selectedBook!['description'] ?? '',
                            images: [image],
                            );

                          if (widget.selectedCategories == null) {
                            widget.selectedCategories = [];
                          }
                          List<String> categoryNames = widget.selectedCategories!.map((category) => category.name).toList();
                      
                          await createBook(b, categoryNames);

                          widget.onBookAdded();
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration( // 모서리 둥글기 설정
                            borderRadius: BorderRadius.circular(16.0),
                            color: Color(0xff31795B),
                          ),
                          child: Center(
                            child: Text(
                              '추가 완료',
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
