import 'package:flutter/material.dart';
import 'package:untitled/add_category_page.dart';

import 'add_book_page.dart';

class HomePage extends StatelessWidget {
  final List<List<String>> entries = <List<String>>[['스릴러', '데미안', '라미안'], ['로맨스', '로로로','이'], ['철학', '기','보보보']];
  final List<int> colorCodes = <int>[600, 500, 100];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 25.0),
              decoration: BoxDecoration(
                color: Color(0xff31795B),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32.0),
                  bottomRight: Radius.circular(32.0),
                ),
                boxShadow: [ // 그림자 추가
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 좌측 정렬 설정
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 0.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start, // 좌측 정렬 설정
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center,
                          child: Image.asset('assets/olive_icon.png'),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '모락모락 팬케이크',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '님',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '나만의 책 playlist',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: entries.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == entries.length) {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AddCategoryPage(),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder( // 모서리 라운드 효과 설정
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          elevation: 4, // 그림자 효과 크기 조정
                          child: Container(
                            width: 160,
                            height: 100,
                            color: Color(0xffffffff),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: Image.asset('assets/olive_icon.png'),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '책칸 추가하기',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                  }

                  String title = entries[index][0]; // 각 리스트의 첫 번째 항목을 제목으로 가져옴

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: 200,
                        color: Color(0xffffffff),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: entries[index].length - 1, // 제목을 제외한 나머지 항목 수
                          itemBuilder: (BuildContext context, int hIndex) {
                            String name = entries[index][hIndex + 1]; // 제목을 제외하고 가져옴
                            return Container(
                              width: 160,
                              color: Colors.transparent,
                              child: Center(
                                child: Text(name), // 텍스트로 보여주기
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
