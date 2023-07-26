import 'package:flutter/material.dart';
import 'package:untitled/functions/api_functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/functions/recommend_functions.dart';
import 'package:untitled/functions/user_info.dart';
import 'dart:io';
import 'dart:convert';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  TextEditingController _textController = TextEditingController();
  UserInfoDB? _userInfo;


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
              onPressed: () => scanImage(),
              child: Text('recommendation'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
                onPressed: () =>  _captureImage(),
                child: Text('Send Image to Flask'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                print('Get User Info button pressed');
                String email = 'jane@gmail.com';
                String password = 'qwerty1234';
                UserInfoDB? userInfo = await getUserInfoFromServer(email, password);
                print('Received user info from server:');
                printUserInfoDB(userInfo);
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
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String bookName = "분노의 포도";
                String author = "존 스타인벡";
                String ocrResult = "분노의 포도가 사람들의 영혼을 가득 채우며 점점 익어간다.";

                final imagePicker = ImagePicker();
                final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

                if (pickedFile != null) {
                  final File file = File(pickedFile.path);

                  // Send OCR request and get OCRResult
                  OCRResult result = await sendOCRResult(file, bookName, author, ocrResult);

                  // Print the OCRResult
                  print("Received OCR Result:");
                  print("Image URL: ${result.imageUrl}");
                  print("Song List:");
                  for (var song in result.songList) {
                    print("Title: ${song['title']}, Artist: ${song['artist']}");
                  }
                }

              },
              child: Text('testing OCR result api function'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _captureImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File file = File(pickedFile.path);

      // Now you have the image file and can upload it to the server.
      await uploadImage(file);
    }
  }

}
