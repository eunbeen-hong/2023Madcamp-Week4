import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:untitled/functions/user_info.dart';

class OCRResult {
  final List<Map<String, String>> songList;
  String localPath;

  OCRResult({required this.songList, required this.localPath});
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

Future<void> addImageAndSongs(String bookId, File image, List<SongDB> songs) async {
  try {
    String url = 'http://172.10.5.155/api/add_image_and_songs';

    List<int> imageBytes = await image.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    Map<String, dynamic> requestBody = {'image': base64Image,
      'user_id': userInfo!.userid,
      'book_id': bookId,
      'songs': songs.map((song) => song.toJson()).toList(),
      };
    String requestBodyJson = jsonEncode(requestBody);

    Map<String, String> headers = {'Content-Type': 'application/json'};

    http.Response response = await http.post(Uri.parse(url), headers: headers, body: requestBodyJson);


    if (response.statusCode == 200) {
      // Handle the response
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print("Successfully added image and songs to server. Response data: $jsonResponse");
      userInfo!.books.firstWhere((book) => book.bookId == bookId).images.add(ImageDB(
        imageUrl: jsonResponse['image_url'],
        songs: songs,
      ));
    } else {
      print("Failed to add image and songs to server. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error adding image and songs to server: $e");
  }
}

// use book desc for text when first creating book
Future<OCRResult> sendOCRResult(String bookName, String author, String text) async {
  try {
    String url = 'http://172.10.5.155/api/ocr_result';
    
    Map<String, dynamic> requestBody = {'text':text, 'book_name': bookName, 'author': author};
    String requestBodyJson = jsonEncode(requestBody);

    // Set the headers for JSON content
    Map<String, String> headers = {'Content-Type': 'application/json'};

    // Send the POST request with the JSON payload
    http.Response response = await http.post(Uri.parse(url), headers: headers, body: requestBodyJson);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print("response.body:${response.body}");
      print("3");
      List<dynamic> songListJson = jsonResponse['song_list'];
      print("4");
      List<Map<String, String>> songList = songListJson.map((song) {
        return {
          'title': song[0] as String,
          'artist': song[1] as String,
        };
      }).toList();
      print("5");

      print("songList: $songList");

      return OCRResult(songList: songList, localPath: '');
    } else {
      print("Failed to upload image to server. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error uploading OCR to server: $e");
  }


  return OCRResult(songList: [], localPath: '');
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
        for (var song in image['songs'] ?? []) {
          imageSongs.add(SongDB(
            title: song['title'] ?? '',
            songUrl: song['url'] ?? '',
            songId: song['song_id'] ?? '',
          ));
        }
        bookImages.add(ImageDB(
          imageUrl: image['url'] ?? '',
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

Future<void> signUpUser(String email, String password, String username) async {
  try {
    String urlString = 'http://172.10.5.155/api/create_user';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> data = {'username': username, 'email': email, 'password': password};
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
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

Future<void> addCategory(String categoryName, String userId) async {
  try {
    String url = 'http://172.10.5.155/api/add_category';

    Map<String, dynamic> requestBody = {'category_name': categoryName, 'user_id': userId};
    String requestBodyJson = jsonEncode(requestBody);

    Map<String, String> headers = {'Content-Type': 'application/json'};
    http.Response response = await http.post(Uri.parse(url), headers: headers, body: requestBodyJson);

    if (response.statusCode == 200) {
      print("Successfully added category to server.");
      Map<String, dynamic> responseData = jsonDecode(response.body);
      print('Response data: $responseData');

      userInfo!.categories.add(CategoryDB(
        categoryId: responseData['category_id'],
        categoryName: categoryName,
        bookIdList: [],
      ));
    } else {
      print("Failed to add category to server. Status code: ${response.statusCode}");
    }

  } catch (e) {
    print("Error adding category to server: $e");
  }
}
Future<void> createBook(BookDB book, List<String> categoryNames) async { 
   try {
    String url = 'http://172.10.5.155/api/create_book';

    Map<String, dynamic> requestBody = {
      'user_id': userInfo!.userid,
      'category_names': categoryNames,
      'title': book.title,
      'author': book.author,
      'image_url': book.images[0].imageUrl,
      'book_desc': book.bookDesc,
      'songs': book.images[0].songs.map((song) => song.toJson()).toList(),
      };
    String requestBodyJson = jsonEncode(requestBody);

    Map<String, String> headers = {'Content-Type': 'application/json'};

    http.Response response = await http.post(Uri.parse(url), headers: headers, body: requestBodyJson);


    if (response.statusCode == 200) {
      // Handle the response
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print("Successfully created book. Response data: $jsonResponse");
      book.bookId = jsonResponse['book_id'];
      book.last_accessed = jsonResponse['last_accessed'];
      userInfo!.books.add(book);
    } else {
      print("Failed to create book. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error create book: $e");
  }
}
