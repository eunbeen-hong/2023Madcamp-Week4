import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<List<String>> entries = <List<String>>[['스릴러', '데미안', '라미안'], ['로맨스', '로로로','이'], ['철학', '기','보보보']];
  final List<int> colorCodes = <int>[600, 500, 100];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe3e3e3),
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: Image.asset('assets/olive_icon.png'),
                ),
              ),
              SizedBox(width: 8),
              Text(
                '나만의 책장',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
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
                      color: Color(0xffe3e3e3),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: entries[index].length - 1, // 제목을 제외한 나머지 항목 수
                        itemBuilder: (BuildContext context, int hIndex) {
                          String name = entries[index][hIndex + 1]; // 제목을 제외하고 가져옴

                          Widget inputSet = Column(
                            children: [
                              TextFormField(
                                initialValue: name,
                                decoration: InputDecoration(labelText: '이름'),
                              ),
                              TextFormField(
                                decoration: InputDecoration(labelText: '나이'),
                              ),
                            ],
                          );

                          return Container(
                            width: 160,
                            color: Colors.transparent,
                            child: Center(
                              child: inputSet,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Color(0xffc5c353),
      ),
    );
  }
}
