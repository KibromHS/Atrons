import 'dart:convert';
import 'dart:io';

import 'package:atrons_v1/utils/user_preferences.dart';
import 'package:flutter/material.dart';
// import 'package:iridium_reader_widget/views/viewers/epub_screen.dart';
// import 'package:page_transition/page_transition.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as path;

class Purchased {
  static Future<void> openAtronsBook(
    String title,
    String bid,
  ) async {
    // Directory? appDocDir;
    String? filePath;
    String? fileName;

    // appDocDir = Platform.isAndroid
    //     ? await getExternalStorageDirectory()
    //     : await getApplicationDocumentsDirectory();
    fileName = '${title.replaceAll(' ', '_').replaceAll(r"\'", "'")}.epub';
    // filePath = Platform.isIOS
    //     ? path.join(appDocDir!.path, '$fileName.epub')
    //     : path.join(
    //         appDocDir!.path.split('Android')[0],
    //         'Atrons',
    //         '$fileName.epub',
    //       );

    filePath = '/storage/emulated/0/Atrons/' + fileName;

    final localUser = UserPreferences.getUser();
    final newUser = localUser.copy(currentBook: bid);
    UserPreferences.setUser(newUser);

    // await openBook(filePath, context);

    VocsyEpub.setConfig(themeColor: Colors.teal);

/**
 * @bookPath
 * @lastLocation (optional and only android)
 */
    VocsyEpub.open(filePath);

    // Get locator which you can save in your database

    VocsyEpub.locatorStream.listen((locator) {
      print(
          '!!!!!!!!!!!!!!!!!!!!LOCATOR: ${EpubLocator.fromJson(jsonDecode(locator)).toString()}');
      // convert locator from string to json and save to your database to be retrieved later
    });
  }

  static Future<void> deleteAtronsBook(String title) async {
    // Directory? appDocDir;
    String? filePath;
    String? fileName;

    // appDocDir = Platform.isAndroid
    //     ? await getExternalStorageDirectory()
    //     : await getApplicationDocumentsDirectory();
    fileName = '${title.replaceAll(' ', '_').replaceAll(r"\'", "'")}.epub';
    // filePath = Platform.isIOS
    //     ? path.join(appDocDir!.path, '$fileName.epub')
    //     : path.join(
    //         appDocDir!.path.split('Android')[0],
    //         'Atrons',
    //         '$fileName.epub',
    //       );

    filePath = '/storage/emulated/0/Atrons/' + fileName;

    File file = File(filePath);
    await file.delete();
  }
}
