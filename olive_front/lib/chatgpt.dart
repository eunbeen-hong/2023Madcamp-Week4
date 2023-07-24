import 'package:http/http.dart' as http;
import 'dart:convert';

// ChatGPT API 엔드포인트 URL
const String chatGptUrl = 'https://api.chatgpt.com/chat';

Future<String> sendToChatGpt(String text) async {
  // ChatGPT에 보낼 데이터를 준비합니다.
  final Map<String, dynamic> data = {
    'text': text,
  };

  // ChatGPT API에 POST 요청을 보냅니다.
  final response = await http.post(Uri.parse(chatGptUrl), body: json.encode(data));

  // 응답 데이터를 파싱합니다.
  final responseData = json.decode(response.body);

  // ChatGPT의 응답에서 추천 노래 등을 추출하여 반환합니다.
  // 예시: 노래 추천이 "recommendation" 키에 담겨있다고 가정합니다.
  return responseData['recommendation'];
}
