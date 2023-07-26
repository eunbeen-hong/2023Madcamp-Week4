import 'package:flutter/material.dart';
import 'package:untitled/functions/recommend_functions.dart';
import 'package:untitled/pages/add_text_page.dart';
import 'package:untitled/pages/camera.dart';

class CameraDialog extends StatefulWidget {
  @override
  _CameraDialogState createState() => _CameraDialogState();
}

class _CameraDialogState extends State<CameraDialog> {
  Future<Map<String, dynamic>> getIdsFromGallery() async {
    Map<String, dynamic> rst = await imageToUrls();
    List<String> urls = rst['urls'];
    String localPath = rst['localPath'];
    List<YoutubeVideoInfo> youtubeInfos = await getUrlVideoInfo(urls);
    Map<String, dynamic> rtn = {"youtubeInfos": youtubeInfos, "localPath": localPath};
    return rtn;
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

              Map<String, dynamic> result = await getIdsFromGallery();
              List<YoutubeVideoInfo> youtubeInfos = result["youtubeInfos"];
              String localPath = result["localPath"];
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTextPage(youtubeInfos: youtubeInfos, localPath:localPath)),
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
