import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserPreferences {
  static late SharedPreferences preferences;
  static const keyUser = 'user';

  static final myUser = User(
    userID: '',
    imagePath: 'assets/images/noprofile.png',
    name: 'Your Name',
    email: 'example@email.com',
    gender: 'M',
    bookmarks: [],
    mybooks: [],
    searches: [],
    isDarkMode: false,
    currentBook: '',
    myaudiobooks: [],
  );

  static Future init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static Future setUser(User user) async {
    final json = jsonEncode(user.toJson());
    await preferences.setString(keyUser, json);
  }

  static Future signOut() async {
    await setUser(myUser);
  }

  static User getUser() {
    final json = preferences.getString(keyUser);
    return json == null ? myUser : User.fromJson(jsonDecode(json));
  }
}
