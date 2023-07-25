import 'package:untitled/home_page.dart';
import 'package:untitled/ocr.dart';
import 'package:untitled/testing_page.dart';
import 'package:flutter/material.dart';
import 'package:untitled/youtube_test_page.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    OcrPage(),
    TestPage(),
    YoutubePage()
  ];

  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
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

  void _onPageChanged(int index) {
    print('Page Changed: $index'); // Debug print to see page change
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe3e3e3),
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
              icon: Icon(Icons.home),
              label: 'Home',
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
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
          selectedFontSize: 10.0, // 선택된 아이템의 텍스트 크기 설정
          unselectedFontSize: 10.0, // 선택되지 않은 아이템의 텍스트 크기 설정
        ),
      ),
    );
  }
}
