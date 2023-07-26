import 'package:flutter/material.dart';
import 'package:untitled/pages/search_category_page.dart';
import 'package:untitled/pages/search_book_page.dart';

class AddBookPage extends StatefulWidget {
  final Map<String, dynamic>? selectedBook;
  List<Category>? selectedCategories;
  AddBookPage({this.selectedBook, required this.selectedCategories});
  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  int counter = 0;
  void incrementCounter() {
    // Function to increment the counter when the InkWell is tapped.
    setState(() {
      counter++;
    });
  }
  List<String> songNames = [
    'Song 1',
    'Song 2',
    'Song 3',
    'Song 4',
    'Song 5',
  ];

  Widget buildSongItem(int index) {
    String songName = songNames[index];
    return ListTile(
      leading: Icon(Icons.music_note),
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
            onPressed: () {
              // TODO: Implement add functionality for the song at the given index.
            },
          ),
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
                    showDialog(
                      context: context,
                      builder: (context) => SearchBookPage(),
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
                        height: 280,
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
                              Text(
                                widget.selectedBook!['title'], // 전달받은 책 정보를 출력
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000),
                                ),
                              ),
                              Text(
                                widget.selectedBook!['author'], // 전달받은 책 정보를 출력
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              Card(
                shape: RoundedRectangleBorder( // 모서리 라운드 효과 설정
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4, // 그림자 효과 크기 조정
                child: GestureDetector(
                  onTap: incrementCounter,
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
              if (counter != 0)
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
                        child: ListView.builder(
                          itemCount: songNames.length,
                          itemBuilder: (context, index) {
                            return buildSongItem(index);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              Card(
                shape: RoundedRectangleBorder( // 모서리 라운드 효과 설정
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4, // 그림자 효과 크기 조정
                child: GestureDetector(
                  onTap: () async{
                    List<Category>? selectedCategories = await showDialog<List<Category>>(
                      context: context,
                      builder: (context) => SearchCategoryPage(selectedCategories: widget.selectedCategories),
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
              if (widget.selectedCategories != null && widget.selectedCategories!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '선택된 카테고리',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.selectedCategories!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(widget.selectedCategories![index].name),
                // ... 추가적인 카테고리 정보를 표시할 수 있음
                        );
                      },
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ElevatedButton(
                onPressed: () async {
                  // 책칸 추가 완료 처리
                  Navigator.pop(context);
                },
                child: Text('추가 완료'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
