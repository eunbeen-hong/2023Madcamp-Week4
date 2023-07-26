import 'package:flutter/material.dart';
import 'package:untitled/pages/my_home_page.dart';
import 'package:untitled/functions/api_functions.dart';
import 'package:untitled/functions/user_info.dart';

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
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                
                String email = _emailController.text;
                String password = _passwordController.text;

                UserInfoDB? userInfo = await getUserInfoFromServer(email, password);
                if (userInfo != null) {
                  printUserInfoDB(userInfo);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // FIXME
                      builder: (context) => MyHomePage(userInfo: userInfo),
                    ),
                  );
                } else {
                  print('User not found');
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
