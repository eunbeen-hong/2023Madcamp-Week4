import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String text;

  const ResultScreen({super.key, required this.text});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Text(text),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 'Sending' 버튼을 누르면 서버로 ocr 결과값을 보낸다. 
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}



