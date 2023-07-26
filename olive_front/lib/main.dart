import 'package:flutter/material.dart';
import 'package:untitled/pages/my_home_page.dart';
import 'package:untitled/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF808000)),
        useMaterial3: true,
      ),
      home: LoginPage(), // Changed the home to LoginPage
    );
  }
}
