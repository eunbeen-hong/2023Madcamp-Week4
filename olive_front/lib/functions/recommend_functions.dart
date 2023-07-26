import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/youtube.dart';
import 'package:untitled/functions/api_functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

Future<OCRResult> scanImage() async {
  // // check if the camera is available
  // if (_cameraController == null) return;

  // final navigator = Navigator.of(context);

  try {
    // final pictureFile = await _cameraController!.takePicture();
    //
    // final file = File(pictureFile.path);

    final imagePicker = ImagePicker();
    XFile? xFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (xFile == null) {
      print('No image selected.');
      return OCRResult(songList: [], imageUrl: '');
    }

    File file = File(xFile.path);

    final inputImage = InputImage.fromFile(file);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.korean);
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
      if (youtubeUrl != null) {
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

Future<Map<String, String>> getYoutubeVideoTitles(List<String> videoIds) async {
  String apiKey;
  try {
    String apiKeyJson =
        await rootBundle.loadString('secret/youtube_api_key.json');
    Map<String, dynamic> apiKeyData = json.decode(apiKeyJson);
    apiKey = apiKeyData['youtube_api_key'];
  } catch (e) {
    throw Exception('Failed to read YouTube API key: $e');
  }
  String baseUrl = 'https://www.googleapis.com/youtube/v3/videos';
  String videoIdQuery = videoIds.join(',');

  Uri uri = Uri.parse('$baseUrl?part=snippet&id=$videoIdQuery&key=$apiKey');

  var response = await http.get(uri);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    Map<String, String> videoTitles = {};

    if (data['items'] != null) {
      for (var item in data['items']) {
        String videoId = item['id'];
        String title = item['snippet']['title'];
        videoTitles[videoId] = title;
      }
    }

    return videoTitles;
  } else {
    throw Exception('Failed to load video titles');
  }
}

Future<List<YoutubeVideoInfo>> getUrlVideoInfo(List<String> urls) async {
  List<String> videoIds = await UrlsToYoutubeIds(urls);
  Map<String, String> videoTitles = await getYoutubeVideoTitles(videoIds);

  List<YoutubeVideoInfo> videoInfoList = [];
  for (int i = 0; i < urls.length; i++) {
    String url = urls[i];
    String videoId = videoIds[i];
    String? videoTitle = videoTitles[videoId];

    if (url == null || videoId == null || videoTitle == null) {
      continue;
    }

    videoInfoList.add(YoutubeVideoInfo(url: url, videoId: videoId, videoTitle: videoTitle));
  }

  return videoInfoList;
}


class YoutubeVideoInfo {
  final String url;
  final String videoId;
  final String videoTitle;

  YoutubeVideoInfo(this.url, this.videoId, this.videoTitle);
}