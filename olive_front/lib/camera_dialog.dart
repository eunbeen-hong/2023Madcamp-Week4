import 'package:flutter/material.dart';
import 'package:untitled/functions/recommend_functions.dart';
import 'package:untitled/pages/add_text_page.dart';

class CameraDialog extends StatefulWidget {
  @override
  _CameraDialogState createState() => _CameraDialogState();
}

class _CameraDialogState extends State<CameraDialog> {
  Future<List<YoutubeVideoInfo>> getIdsFromGallery() async {
    List<String> urls = await imageToUrls();
    List<YoutubeVideoInfo> youtubeInfos = await getUrlVideoInfo(urls);
    return youtubeInfos;
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
              //Navigator.push(
                //context,
                //MaterialPageRoute(builder: (context) => CameraPage()),
              //);
            },
          ),
          ListTile(
            title: const Text('사진첩'),
            onTap: () async {

              List<YoutubeVideoInfo> youtubeInfos = await getIdsFromGallery();
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTextPage(youtubeInfos: youtubeInfos)),
              );
            },
          ),
        ],
      ),
    );
  }
}
