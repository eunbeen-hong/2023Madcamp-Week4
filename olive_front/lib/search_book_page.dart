import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'add_book_page.dart';

class SearchBookPage extends StatefulWidget {
  @override
  _SearchBookPageState createState() => _SearchBookPageState();
}

class _SearchBookPageState extends State<SearchBookPage> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];

  void searchBooks() async {
    // 네이버 책 API의 요청 URL
    String url = 'https://openapi.naver.com/v1/search/book.json?query=${searchController.text}';

    // 네이버 책 API를 호출하여 책 정보를 가져옴
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'X-Naver-Client-Id': 'QIGtC1w8qbCFHZ9Q6kku', // 네이버 개발자 센터에서 발급받은 클라이언트 ID
        'X-Naver-Client-Secret': 'XkJjfQHPJT', // 네이버 개발자 센터에서 발급받은 클라이언트 시크릿
      },
    );


    // 응답 데이터를 JSON 형식으로 변환
    var data = json.decode(response.body);

    // 검색 결과를 처리하여 리스트에 저장
    setState(() {
      searchResults = List<Map<String, dynamic>>.from(data['items']);
    });
  }
  void onBookSelected(Map<String, dynamic> book) {
    // 이전 화면으로 책 정보 전달
    Map<String, dynamic> selectedBook = {
      'image': book['image'], // 책 이미지 URL
      'title': book['title'], // 책 제목
      'author': book['author'], // 책 저자
    };
    print("Why if doesnt work?1");
    print("What is selectedBook?1: ${selectedBook}");
    //Navigator.pop(context, selectedBook);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddBookPage(selectedBook: selectedBook)),
    );
    //Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('책 검색하기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(labelText: '검색어를 입력하세요'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: searchBooks,
              child: Text('검색'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  var book = searchResults[index];
                  return InkWell(
                    onTap: () => onBookSelected(book), // 책 정보를 선택했을 때 호출
                    child: ListTile(
                    leading: Image.network(book['image']),
                    title: Text(book['title']),
                    subtitle: Text(book['author']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
