import 'dart:convert';

import 'package:atrons_v1/models/book.dart';
import 'package:atrons_v1/utils/user_preferences.dart';

class CheckRatedUser {

  static bool check(Book book) {
    final localUser = UserPreferences.getUser();

    for (int i = 0; i < book.ratingsReviews.length; i++) {
      final data = jsonDecode(book.ratingsReviews[i]);
      if (localUser.userID == data['userid']) {
        return true;
      }
    }
    return false;
  }
  
}