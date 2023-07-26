import 'package:flutter/material.dart';
import 'package:untitled/functions/recommend_functions.dart';
import 'package:untitled/pages/add_text_page.dart';
import 'package:untitled/pages/camera_page.dart';
import 'dart:io';
import 'package:untitled/functions/recommend_functions.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/functions/user_info.dart';

class CameraDialog extends StatefulWidget {
  final String bookId;

  CameraDialog({Key? key, required this.bookId}) : super(key: key);
  @override
  _CameraDialogState createState() => _CameraDialogState();
}

class _CameraDialogState extends State<CameraDialog> {
  File? _imageFile;
  Future<Map<String, dynamic>> getIdsFromGallery() async {
    Map<String, dynamic> rst = await imageToUrls();
    List<String> urls = rst['urls'];
    String localPath = rst['localPath'];
    List<YoutubeVideoInfo> youtubeInfos = await getUrlVideoInfo(urls);
    Map<String, dynamic> rtn = {"youtubeInfos": youtubeInfos, "localPath": localPath};
    return rtn;
  }
  Future<Map<String, dynamic>> _getImageAndScanFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final inputImage = InputImage.fromFilePath(pickedFile.path);
      final textRecognizer = TextRecognizer();
      final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);
      print("OCR Text: ${recognizedText.text}");

      textRecognizer.close();

      File imageFile = File(pickedFile.path);
      Map<String, dynamic> rst = await imageToUrlsFromCamera();
      List<String> urls = rst['urls'];
      List<YoutubeVideoInfo> youtubeInfos = await getUrlVideoInfo(urls);

      Map<String, dynamic> rtn = {"youtubeInfos": youtubeInfos, "localPath": pickedFile.path};
      return rtn;
    } else {
      print('No image selected.');
      throw Exception('No image selected.');  // Or handle this situation as you prefer
    }
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('사진 도구'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('카메라'),
            onTap: () async {
              Map<String, dynamic> result = await _getImageAndScanFromCamera();
              List<YoutubeVideoInfo> youtubeInfos = result["youtubeInfos"];
              String localPath = result["localPath"];
              Navigator.of(context).pop();
              Navigator.push(
                context,
                //MaterialPageRoute(builder: (context) => CameraPage()),
                MaterialPageRoute(builder: (context) => AddTextPage(youtubeInfos: youtubeInfos, localPath:localPath, book: widget.book,)),
              );
            },
          ),

          ListTile(
            title: const Text('사진첩'),
            onTap: () async {

              Map<String, dynamic> result = await getIdsFromGallery();
              List<YoutubeVideoInfo> youtubeInfos = result["youtubeInfos"];
              String localPath = result["localPath"];
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTextPage(bookId: widget.bookId, youtubeInfos: youtubeInfos, localPath:localPath)),
              );
            },
          ),
        ],
      ),
    );
  }
}
