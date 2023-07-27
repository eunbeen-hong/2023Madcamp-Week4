import 'package:flutter/material.dart';
import 'package:untitled/pages/my_home_page.dart';
import 'package:untitled/functions/api_functions.dart';
import 'package:untitled/functions/user_info.dart';
import 'package:untitled/pages/sign_up_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff31795B), // 배경색 변경
      appBar: AppBar(
        backgroundColor: Color(0xff31795B),
        title: null,
        //Text('Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                  'LOGIN',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white,), // 큰 글씨로 변경 및 볼드 설정
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
                ElevatedButton(
                  onPressed: () async {

                    String email = _emailController.text;
                    String password = _passwordController.text;

                    userInfo = await getUserInfoFromServer(email, password);
                    if (userInfo != null) {
                      print('User found');
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(),
                        ),
                      );
                    } else {
                      print('User not found');
                    }
                  },
                  child: Text('Login'),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => SignUpPage(),
                    );
                  },
                  child: Container(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Color(0xff000000),
                      )
                    ),
                  )
                ),
              ],
            ),
        )
      ),
    );
  }
}
