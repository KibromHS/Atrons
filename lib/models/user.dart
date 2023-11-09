import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    required this.userID,
    required this.imagePath,
    required this.name,
    required this.email,
    required this.isDarkMode,
    required this.gender,
    this.language = 'English',
    this.notifications = true,
    required this.bookmarks,
    required this.mybooks,
    this.searches,
    required this.currentBook,
    required this.myaudiobooks,
  });

  final String userID;
  final String imagePath;
  final String name;
  final String email;
  final String gender;
  final bool isDarkMode;
  final String language;
  final bool notifications;
  final List bookmarks;
  final List mybooks;
  List? searches;
  final String currentBook;
  final List myaudiobooks;

  User copy({
    String? imagePath,
    String? name,
    String? email,
    String? gender,
    bool? isDarkMode,
    String? language,
    bool? notifications,
    List<String>? markedBooks,
    List? searches,
    String? currentBook,
  }) {
    return User(
      userID: userID,
      imagePath: imagePath ?? this.imagePath,
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      notifications: notifications ?? this.notifications,
      bookmarks: markedBooks ?? bookmarks,
      mybooks: mybooks,
      myaudiobooks: myaudiobooks,
      currentBook: currentBook ?? this.currentBook,
    );
  }

  void addToMyAudioBooks(String bid) async {
    FirebaseFirestore.instance.collection('Users').doc(userID).update({
      'myaudios': FieldValue.arrayUnion([bid])
    });
  }

  void removeFromMyAudioBooks(String bid) async {
    await FirebaseFirestore.instance.collection('Users').doc(userID).update({
      'myaudios': FieldValue.arrayRemove([bid])
    });
  }

  // -------- searches ----------- //
  void addSearched(String searchedValue) {
    FirebaseFirestore.instance.collection('Users').doc(userID).update({
      'searches': FieldValue.arrayUnion([searchedValue])
    });
  }

  void removeSearched(String query) {
    FirebaseFirestore.instance.collection('Users').doc(userID).update({
      'searches': FieldValue.arrayRemove([query])
    });
  }

  Future<List> getbookmark() async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .get()
        .then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        final bookm = data['bookmark'] as List;
        return bookm;
      },
    );
  }

// Remove from bookmark
  void removeMarkedBook(String bid) {
    FirebaseFirestore.instance.collection('Users').doc(userID).update({
      'bookmark': FieldValue.arrayRemove([bid]),
    });
  }

// Add to bookmark
  void addMarkedBook(String bid) {
    FirebaseFirestore.instance.collection('Users').doc(userID).update({
      'bookmark': FieldValue.arrayUnion([bid]),
    });
  }

  // ------- bought or downloaded books ---------- //
  void addToMyBooks(String bid) async {
    FirebaseFirestore.instance.collection('Users').doc(userID).update({
      'mybooks': FieldValue.arrayUnion([bid])
    });
  }

  void removeFromMyBooks(String bid) async {
    await FirebaseFirestore.instance.collection('Users').doc(userID).update({
      'mybooks': FieldValue.arrayRemove([bid])
    });
  }

  Future<List> getMyBooks() async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .get()
        .then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        final myBooks = data['mybooks'] as List;
        return myBooks;
      },
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userID,
      'imagePath': imagePath,
      'name': name,
      'email': email,
      'gender': gender,
      'isDarkMode': isDarkMode,
      'bookmarks': bookmarks,
      'mybooks': mybooks,
      'searches': searches,
      'myaudiobooks': myaudiobooks,
      'currentBook': currentBook,
    };
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      userID: json['userid'],
      imagePath: json['imagePath'],
      name: json['name'].toString(),
      email: json['email'].toString(),
      gender: json['gender'],
      isDarkMode: json['isDarkMode'],
      bookmarks: json['bookmarks'],
      mybooks: json['mybooks'] ?? [],
      searches: json['searches'],
      myaudiobooks: json['myaudiobooks'] ?? [],
      currentBook: json['currentBook'] ?? '',
    );
  }
}
