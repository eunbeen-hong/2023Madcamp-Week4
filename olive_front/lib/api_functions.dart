import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
// import 'dart:io'; // not supported in mobile platforms

// Future<String> convertImageToBase64(String path) async {
//   File imageFile = File(path); // Replace with the actual path to your image file
//   List<int> imageBytes = await imageFile.readAsBytes();
//   String base64Image = base64Encode(imageBytes);
//   return base64Image;
// }

Future<XFile?> pickImage() async {
  final picker = ImagePicker();
  XFile? image = await picker.pickImage(source: ImageSource.gallery);
  return image;
}

Future<void> sendTextAndImage(String text) async {
  XFile? imageFile = await pickImage();
  if (imageFile == null) {
    print('No image selected.');
    return;
  }

  String urlString = 'http://172.10.5.155/api/send_text_and_image';

  var request = http.MultipartRequest('POST', Uri.parse(urlString));
  request.fields['text'] = text;
  request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

  var response = await request.send();

  if (response.statusCode == 200) {
    var responseData = await response.stream.bytesToString();
    print('Response data: $responseData');
  } else {
    print('Error: ${response.statusCode}');
  }
}

Future<void> uploadImage() async {
  XFile? imageFile = await pickImage();
  if (imageFile == null) {
    print('No image selected.');
    return;
  }

  String urlString = 'http://172.10.5.155/api/upload_image';

  var request = http.MultipartRequest('POST', Uri.parse(urlString));
  request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

  var response = await request.send();

  if (response.statusCode == 200) {
    var responseData = await response.stream.bytesToString();
    print('Response data: $responseData');
  } else {
    print('Error: ${response.statusCode}');
  }
}

Future<void> sendText(String text) async {
  String urlString = 'http://http://172.10.5.155/api/send_text';
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
