import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // not supported in mobile platforms
import 'package:untitled/functions/user_info.dart';

class OCRResult {
  final List<Map<String, String>> songList;
  final String imageUrl;

  OCRResult({required this.songList, required this.imageUrl});
}

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

// use book desc for text when first creating book
Future<OCRResult> sendOCRResult(File file, String bookName, String author, String text) async {
  try {
    String url = 'http://172.10.5.155/api/ocr_result'; // Replace with your server's URL

    // Read the image file as bytes and encode it to base64
    List<int> imageBytes = await file.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    // Create a JSON payload containing the base64 encoded image data
    Map<String, dynamic> requestBody = {'image': base64Image, 'text':text, 'book_name': bookName, 'author': author};
    String requestBodyJson = jsonEncode(requestBody);

    // Set the headers for JSON content
    Map<String, String> headers = {'Content-Type': 'application/json'};

    // Send the POST request with the JSON payload
    http.Response response = await http.post(Uri.parse(url), headers: headers, body: requestBodyJson);

    if (response.statusCode == 200) {
      // Parse the server response JSON (if needed)
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String imageUrl = jsonResponse['image_url'];

      List<dynamic> songListJson = jsonResponse['song_list'];
      List<Map<String, String>> songList = songListJson.map((song) {
        return {
          'title': song[0] as String,
          'artist': song[1] as String,
        };
      }).toList();

      print("Image uploaded successfully to server.");
      print("URL: $imageUrl");
      print("songList: $songList");

      return OCRResult(songList: songList, imageUrl: imageUrl);
    } else {
      print("Failed to upload image to server. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error uploading image to server: $e");
  }


  return OCRResult(songList: [], imageUrl: '');
}

Future<void> uploadImage(File file) async {
  try {
    String url = 'http://172.10.5.155/api/upload_image'; // Replace with your server's URL

    // Read the image file as bytes and encode it to base64
    List<int> imageBytes = await file.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    // Create a JSON payload containing the base64 encoded image data
    Map<String, dynamic> requestBody = {'image': base64Image};
    String requestBodyJson = jsonEncode(requestBody);

    // Set the headers for JSON content
    Map<String, String> headers = {'Content-Type': 'application/json'};

    // Send the POST request with the JSON payload
    http.Response response = await http.post(Uri.parse(url), headers: headers, body: requestBodyJson);

    if (response.statusCode == 200) {
      // Parse the server response JSON (if needed)
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String imageUrl = jsonResponse['url'];
      print("Image uploaded successfully to server. URL: $imageUrl");
    } else {
      print("Failed to upload image to server. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error uploading image to server: $e");
  }
}

Future<void> sendText(String text) async {
  String urlString = 'http://172.10.5.155/api/send_text';
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

Future<UserInfoDB?> getUserInfoFromServer(String email, String password) async {
  try {
    print("Fetching user info from server...");
    String urlString = 'http://172.10.5.155/api/get_user_info/$email/$password';
    Uri url = Uri.parse(urlString);

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      print("Successfully fetched user info from server.");
      Map<String, dynamic> responseData = jsonDecode(response.body);

      print('Response data: $responseData');

      UserInfoDB? user = parseUserInfo(responseData);

      return user;
    } else {
      return null;
    }
  } catch (e) {
    print('Error: $e');
    // If an error occurred, return an empty map
    return null;
  }
}

UserInfoDB parseUserInfo(Map<String, dynamic> responseData) {
  Map<String, dynamic> userData = responseData['user_data'];
  List<CategoryDB> userCategories = [];
  if (userData['categories'] != null) {
    for (var categoryId in userData['categories'].keys) {
      var category = userData['categories'][categoryId];
      userCategories.add(CategoryDB(
        categoryId: categoryId,
        categoryName: category['category_name'] ?? '',
        bookIdList: List<String>.from(category['books'] ?? []),
      ));
    }
  }
  print("user category parsed");

  List<BookDB> userBooks = [];
  if (userData['books'] != null) {
    for (var bookId in userData['books'].keys) {
      var book = userData['books'][bookId];
      List<ImageDB> bookImages = [];
      for (var image in book['images']) {
        List<SongDB> imageSongs = [];
        for (var song in image['songs']) {
          imageSongs.add(SongDB(
            title: song['title'],
            songUrl: song['url'],
          ));
        }
        bookImages.add(ImageDB(
          imageUrl: image['url'],
          songs: imageSongs,
        ));
      }
      userBooks.add(BookDB(
        bookId: bookId,
        title: book['title'] ?? '',
        author: book['author'] ?? '',
        last_accessed: book['last_accessed'] ?? '',
        bookDesc: book['book_desc'] ?? '',
        images: bookImages,
      ));
    }
  }

  print("user book parsed");

  return UserInfoDB(
    userid: userData['uid'],
    username: userData['username'],
    email: userData['email'],
    password: userData['password'],
    categories: userCategories,
    books: userBooks,
  );
}