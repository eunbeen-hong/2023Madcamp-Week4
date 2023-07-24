import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // not supported in mobile platforms

Future<String> convertImageToBase64(String path) async {
  File imageFile = File(path); // Replace with the actual path to your image file
  List<int> imageBytes = await imageFile.readAsBytes();
  String base64Image = base64Encode(imageBytes);
  return base64Image;
}

Future<void> sendTextAndImage(String text, String imagePath) async {
  String urlString = 'http://localhost:3000/api/send_text_and_image';

  String base64Image = await convertImageToBase64(imagePath);

  Map<String, String> headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> data = {'text': text, 'image': base64Image};
  String body = jsonEncode(data);

  Uri url = Uri.parse(urlString);

  http.Response response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    String responseData = response.body;
    print('Response data: $responseData');
  } else {
    print('Error: ${response.statusCode}');
  }
}

Future<void> uploadImage() async {
  String urlString = 'http://localhost:3000/api/upload_image';

  String base64Image = await convertImageToBase64('assets/olive_icon.png');

  Map<String, String> headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> data = {'image': base64Image};
  String body = jsonEncode(data);

  Uri url = Uri.parse(urlString); // Convert String URL to Uri object

  http.Response response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    // Request successful, parse the response data
    String responseData = response.body;
    print('Response data: $responseData');
  } else {
    // Request failed, handle the error
    print('Error: ${response.statusCode}');
  }
}

Future<void> sendText(String text) async {
  String urlString = 'http://localhost:3000/api/send_text';
  Map<String, String> headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> data = {'text': text};
  String body = jsonEncode(data);

  Uri url = Uri.parse(urlString); // Convert String URL to Uri object

  http.Response response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    // Request successful, parse the response data
    String responseData = response.body;
    print('Response data: $responseData');
  } else {
    // Request failed, handle the error
    print('Error: ${response.statusCode}');
  }
}
