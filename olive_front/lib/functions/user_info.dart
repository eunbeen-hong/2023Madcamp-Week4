class CategoryDB {
  final String categoryId;
  final String categoryName;
  final List<String> bookIdList;

  CategoryDB({
    required this.categoryId, 
    required this.categoryName, 
    required this.bookIdList
    });
}

class SongDB {
  final String title;
  final String songUrl;
  final String songId;

  SongDB({
    required this.title, 
    required this.songUrl,
    required this.songId
    });
}

class ImageDB {
  final String imageUrl;
  final List<SongDB> songs;

  ImageDB({
    required this.imageUrl, 
    required this.songs
    });
}

class BookDB {
    final String bookId;
    final String title;
    final String author;
    final String last_accessed;
    final String bookDesc;
    final List<ImageDB> images;

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
  final String userid;
  final String username;
  final String email;
  final String password;

  final List<CategoryDB> categories;
  final List<BookDB> books;

  UserInfoDB({
    required this.userid, 
    required this.username, 
    required this.email, 
    required this.password, 
    required this.categories, 
    required this.books
    });
}