import 'package:flutter/material.dart';
import 'package:untitled/api_functions.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Testing Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Enter your text',
              ),
            ),
            ElevatedButton(
              onPressed: () => sendText(_textController.text), // Pass the text from the text field to sendText function
              child: Text('Send Text to Flask'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
                onPressed: () => uploadImage(),
                child: Text('Send Image to Flask'),
            )
          ],
        ),
      ),
    );
  }
}
