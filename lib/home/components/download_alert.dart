import 'dart:io';

import 'package:atrons_v1/home/components/custom_alert.dart';
import 'package:atrons_v1/models/book.dart';
import 'package:atrons_v1/payments/payment.dart';
import 'package:atrons_v1/utils/user_preferences.dart';
import 'package:atrons_v1/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class DownloadAlert extends StatefulWidget {
  final Book book;

  const DownloadAlert({super.key, required this.book});

  static Future show(
      {required BuildContext context, required Book book}) async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => DownloadAlert(book: book),
    );
  }

  @override
  _DownloadAlertState createState() => _DownloadAlertState();
}

class _DownloadAlertState extends State<DownloadAlert> {
  Dio dio = Dio();
  int received = 0;
  String progress = '0';
  int total = 0;
  final localUser = UserPreferences.getUser();

  String get fileName =>
      widget.book.title.replaceAll(' ', '_').replaceAll(r"\'", "'");

  Future<void> checkPermissionAndDownload() async {
    PermissionStatus permission = await Permission.storage.status;

    if (permission != PermissionStatus.granted) {
      await Permission.storage.request();
      // access media location needed for android 10/Q
      await Permission.accessMediaLocation.request();
      // manage external storage needed for android 11/R
      await Permission.manageExternalStorage.request();
      createFile();
    } else {
      createFile();
    }
  }

  Future<void> createFile() async {
    if (widget.book.price != '' || widget.book.price != 'Free') {
      MyPayment.initializePayment(
        amount: widget.book.price, 
        currency: 'ETB', 
        email: localUser.email, 
        firstName: localUser.name.split(' ')[0], 
        lastName: localUser.name.split(' ').length > 1 ? localUser.name.split(' ')[1] : localUser.name, 
        txRef: '', 
        callbackUrl: 'https://cepheusx.com',
      );
    }

    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    if (Platform.isAndroid) {
      Directory('${appDocDir!.path.split('Android')[0]}Atrons').createSync();
      print('You got an Android');
      print(appDocDir.path);
    }

    String filePath = Platform.isIOS
        ? path.join(appDocDir!.path, '$fileName.epub')
        : path.join(
            appDocDir!.path.split('Android')[0],
            'Atrons',
            '$fileName.epub',
          );

          


    File file = File(filePath);
    if (!await file.exists()) {
      await file.create();
    } else {
      await file.delete();
      await file.create();
    }

    download(filePath: filePath);
  }

  Future<void> download({required String filePath}) async {
    await dio.download(
      widget.book.epubUrl,
      filePath,
      deleteOnError: true,
      onReceiveProgress: (receivedBytes, totalBytes) async {
        setState(() {
          received = receivedBytes;
          total = totalBytes;
          progress = (received / total * 100).toStringAsFixed(0);
        });

        //Check if download is complete and close the alert dialog
        if (receivedBytes == totalBytes) {
          String size = '${Utils.formatBytes(total, 1)}';
          localUser.addToMyBooks(widget.book.bookid);
          if (widget.book.audioUrl != null) {
            localUser.addToMyAudioBooks(widget.book.bookid);
          }
          widget.book.addPurchase();
          UserPreferences.setUser(localUser);
          Navigator.pop(context, size);
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    checkPermissionAndDownload();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: CustomAlert(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Downloading...',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20.0),
              Container(
                height: 5,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: LinearProgressIndicator(
                  value: double.parse(progress) / 100.0,
                  valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).colorScheme.secondary,
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                ),
              ),
              const SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '$progress %',
                    style: const TextStyle(
                      fontSize: 13.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${Utils.formatBytes(received, 1)} '
                    'of ${Utils.formatBytes(total, 1)}',
                    style: const TextStyle(
                      fontSize: 13.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
