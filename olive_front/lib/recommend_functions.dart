import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/youtube.dart';
import 'package:untitled/api_functions.dart';

Future<OCRResult> scanImage() async {
  // // check if the camera is available
  // if (_cameraController == null) return;

  // final navigator = Navigator.of(context);

  try {
    // final pictureFile = await _cameraController!.takePicture();
    //
    // final file = File(pictureFile.path);

    final imagePicker = ImagePicker();
    XFile? xFile  = await imagePicker.pickImage(source: ImageSource.gallery);
    if (xFile  == null) {
      print('No image selected.');
      return OCRResult(songList: [], imageUrl: '');
    }

    File file = File(xFile.path);

    final inputImage = InputImage.fromFile(file);
    final textRecognizer =
    TextRecognizer(script: TextRecognitionScript.korean);
    final recognizedText = await textRecognizer.processImage(inputImage);

    // await navigator.push(
    //   MaterialPageRoute(
    //     builder: (BuildContext context) =>
    //         ResultScreen(text: recognizedText.text),
    //   ),
    // );

    print("ocr_text: $recognizedText.text");

    textRecognizer.close();

    // send image and ocr_text to the server
    String bookName = "분노의 포도";
    String author = "존 스타인벡";
    // String ocrResult = "분노의 포도가 사람들의 영혼을 가득 채우며 점점 익어간다.";
    String ocrResult = recognizedText.text;

    print("sending...");
    OCRResult result = await sendOCRResult(file, bookName, author, ocrResult);

    // Print the OCRResult
    print("Received OCR Result:");
    print("Image URL: ${result.imageUrl}");
    print("Song List:");
    for (var song in result.songList) {
      print("Title: ${song['title']}, Artist: ${song['artist']}");
    }

    return result;

  } catch (e) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('An error occurred when scanning text'),
    //   ),
    // );

    print('An error occurred when scanning text');
  }

  return OCRResult(songList: [], imageUrl: '');
}


Future<List<String>> imageToUrls() async {
  OCRResult result = await scanImage();

  List<String> urls = [];
  for (var song in result.songList) {
    String? title = song['title'];
    String? artist = song['artist'];
    if (title != null && artist != null) {
      String? youtubeUrl = await getYouTubeUrl(title, artist);
      if (youtubeUrl != null){
        urls.add(youtubeUrl);
      }
    }
  }

  return urls;
}

Future<List<String>> UrlsToYoutubeIds(List<String> urls) async {
  List<String> ids = [];

  for (var url in urls) {
    String? id = _extractVideoIdFromUrl(url);

    if (id != null) {
      ids.add(id);
    }
  }

  return ids;
}

String? _extractVideoIdFromUrl(String url) {
  Uri? uri = Uri.tryParse(url);
  if (uri != null && uri.host == 'www.youtube.com') {
    String? videoId = uri.queryParameters['v'];
    return videoId;
  }
  return null;
}

// TODO: youtube_explode package
// id list to youtube video titles
