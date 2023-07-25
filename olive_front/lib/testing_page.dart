import 'package:flutter/material.dart';
import 'package:untitled/api_functions.dart';
import 'dart:convert';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  TextEditingController _textController = TextEditingController();
  Map<String, dynamic>? _userInfo;


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
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String uid = '-Na10IK5-1gZE07mFjGz'; // Replace with the actual user ID
                Map<String, dynamic> userInfo = await getUserInfoFromServer(uid);
                setState(() {
                  _userInfo = userInfo;
                });
              },
              child: Text('Get User Info'),
            ),
            SizedBox(height: 16),
            _userInfo != null
                ? Column(
              children: [
                Text('User Info:'),
                Text(_userInfo.toString()),
                // Add other fields as needed
              ],
            )
                : Text('User Info not fetched yet'),
          ],
        ),
      ),
    );
  }
}
