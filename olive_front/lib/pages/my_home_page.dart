import 'package:untitled/pages/home_page.dart';
import 'package:untitled/ocr.dart';
import 'package:untitled/pages/testing_page.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'package:untitled/pages/add_book_page.dart';

import 'package:untitled/pages/youtube_test_page.dart';
import 'package:untitled/youtubeplayer.dart';
import 'package:untitled/functions/user_info.dart';

class MyHomePage extends StatefulWidget {
  final UserInfoDB? userInfo;
  
  MyHomePage({required this.userInfo, Key? key}) : super(key: key); // Keep this constructor


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    OcrPage(),
    TestPage(),
    YoutubePage(),
    YoutubePlayerPage()
  ];

  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    if (index == 1) { // "Add" 아이템이 선택되었을 때
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddBookPage()), // AddBookPage로 이동
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });

      // Navigate to the selected page
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    print('Page Changed: $index'); // Debug print to see page change
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 0.0), // 바텀 네비게이션 바의 높이인 56.0만큼의 패딩 적용
        //color: Color(0xffe3e3e3),
        child: PageView(
          controller: _pageController,
          children: _widgetOptions,
          onPageChanged: _onPageChanged,
        ),
      ),
      bottomNavigationBar: Container(
        height: 48.0,
        color: Color(0xffe3e3e3), // 바텀 네비게이션 바의 색상 설정
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.developer_mode),
              label: 'Dev Tools',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.developer_mode),
              label: 'Dev Tools',
            )
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xff31795B),
          onTap: _onItemTapped,
          selectedFontSize: 10.0, // 선택된 아이템의 텍스트 크기 설정
          unselectedFontSize: 10.0, // 선택되지 않은 아이템의 텍스트 크기 설정
        ),
      ),
    );
  }
}

