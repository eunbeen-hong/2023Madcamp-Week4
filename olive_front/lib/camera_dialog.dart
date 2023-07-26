import 'package:flutter/material.dart';
import 'package:untitled/functions/recommend_functions.dart';
import 'package:untitled/pages/add_text_page.dart';
import 'package:untitled/pages/camera.dart';

class CameraDialog extends StatefulWidget {
  @override
  _CameraDialogState createState() => _CameraDialogState();
}

class _CameraDialogState extends State<CameraDialog> {
  Future<List<String>> getIdsFromGallery() async {
    List<String> urls = await imageToUrls();
    List<String> ids = await UrlsToYoutubeIds(urls);
    return ids;
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
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraPage()),
              );
            },
          ),
          ListTile(
            title: const Text('사진첩'),
            onTap: () async {
              List<String> ids = await getIdsFromGallery();
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTextPage(ids: ids)),
              );
            },
          ),
        ],
      ),
    );
  }
}
