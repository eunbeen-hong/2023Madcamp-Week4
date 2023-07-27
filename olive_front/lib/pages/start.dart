import 'package:flutter/material.dart';
import 'package:untitled/pages/login_page.dart';
import 'package:untitled/pages/sign_up_page.dart';


class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff31795B), // 배경색 변경
      appBar: AppBar(
        backgroundColor: Color(0xff31795B),
        //title: Text('Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '나만의 책 playlist',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white,), // 큰 글씨로 변경 및 볼드 설정
            ),
            SizedBox(height: 16),
            Container(
              width: 100,
              height: 100,
              alignment: Alignment.center,
              child: Image.asset('assets/olive_icon.png'),
            ),
            SizedBox(height: 16),
            Text(
              'OLIVE',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white,), // 큰 글씨로 변경 및 볼드 설정
            ),
            SizedBox(height: 48),
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
                    builder: (context) => LoginPage(),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xffE6F0EC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center( // Text 위젯을 가운데 정렬
                    child: Text(
                      'LOGIN',
                      style: TextStyle(color: Color(0xff000000)), // 텍스트 색 변경
                    ),
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
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => SignUpPage(),
                  );
                },
                child: Container(
                  width: double.infinity, // Container의 너비를 최대로 설정
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xffE6F0EC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center( // Text 위젯을 가운데 정렬
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(color: Color(0xff000000)), // 텍스트 색 변경
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
