import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> getYouTubeUrl(String songTitle, String artist) async {
  String apiKey = 'AIzaSyDWgwIAfQS7V3woZxrqChy8OhmFWQ5ZpCA';
  String baseUrl = 'https://www.googleapis.com/youtube/v3/search';
  String query = '$songTitle $artist';

  Uri uri = Uri.parse('$baseUrl?part=snippet&q=$query&key=$apiKey&type=video');

  var response = await http.get(uri);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    if (data['items'] != null && data['items'].length > 0) {
      // 가장 관련성이 높은 동영상의 URL을 반환합니다.
      String videoId = data['items'][0]['id']['videoId'];
      return 'https://www.youtube.com/watch?v=$videoId';
    } else {
      return 'No video found';
    }
  } else {
    throw Exception('Failed to load video');
  }
}
