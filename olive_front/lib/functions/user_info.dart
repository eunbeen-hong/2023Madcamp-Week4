class CategoryDB {
  late String categoryId;
  late String categoryName;
  late List<String> bookIdList;

  CategoryDB({
    required this.categoryId, 
    required this.categoryName, 
    required this.bookIdList
    });
}

class SongDB {
  late String title;
  late String songUrl;
  late String songId;

  SongDB({
    required this.title, 
    required this.songUrl,
    required this.songId
    });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'songUrl': songUrl,
      'songId': songId,
    };
  }
}

class ImageDB {
  late String imageUrl;
  late List<SongDB> songs;

  ImageDB({
    required this.imageUrl, 
    required this.songs
    });
}

class BookDB {
    late String bookId;
    late String title;
    late String author;
    late String last_accessed;
    late String bookDesc;
    late List<ImageDB> images;

    BookDB({
        required this.bookId,
        required this.title, 
        required this.author,
        required this.last_accessed,
        required this.bookDesc, 
        required this.images
        });
}

class UserInfoDB {
  late String userid;
  late String username;
  late String email;
  late String password;

  late List<CategoryDB> categories;
  late List<BookDB> books;

  UserInfoDB({
    required this.userid, 
    required this.username, 
    required this.email, 
    required this.password, 
    required this.categories, 
    required this.books
    });
}

class GlobalData {
  static UserInfoDB? userInfo;
}


UserInfoDB? get userInfo => GlobalData.userInfo;
set userInfo(UserInfoDB? value) => GlobalData.userInfo = value;