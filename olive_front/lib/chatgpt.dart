import 'dart:convert';
import 'package:http/http.dart' as http;

//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

// ChatGPT API 서버의 엔드포인트 URL
const String chatGptApiUrl = 'YOUR_CHATGPT_API_URL';

Future<String?> getChatGptResponse(String message) async {
  try {
    final response = await http.post(
      Uri.parse(chatGptApiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      // ChatGPT의 응답에서 추천 플레이리스트를 추출하여 반환
      return responseData['recommendations'];
    } else {
      // 서버로부터 오류 응답을 받은 경우
      print('Error: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    // 요청이 실패한 경우
    print('Error: $e');
    return null;
  }
}
