import 'package:flutter/material.dart';
import 'package:untitled/functions/api_functions.dart';
import 'package:untitled/functions/user_info.dart';
import 'package:untitled/pages/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff31795B), // 배경색을 변경
      appBar: AppBar(
        title: null,
        //Text('Sign Up'),
        backgroundColor: Color(0xff31795B), // AppBar 색상 변경
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              child: Image.asset('assets/olive_icon.png'),
            ),
            SizedBox(height: 16),
            Text(
              'SIGN UP',
              style: TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.bold), // 큰 글씨로 변경
            ),
            SizedBox(height: 48),
            Container(
              decoration: BoxDecoration(
                color: Color(0xffE6F0EC), // 박스 색 변경
                borderRadius: BorderRadius.circular(10), // 모서리 라운드 처리
              ),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: InputBorder.none, // 기본 경계선 제거
                  contentPadding: EdgeInsets.all(10), // 내부 패딩 추가
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Color(0xffE6F0EC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Color(0xffE6F0EC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text;
                String password = _passwordController.text;
                String username = _usernameController.text;

                await signUpUser(email, password, username);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
