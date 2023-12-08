import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:atrons_v1/home/audiobook/audiobook.dart';
import 'package:atrons_v1/home/components/continue_reading.dart';
import 'package:atrons_v1/home/components/loading_skeleton.dart';
import 'package:atrons_v1/home/explore/explore.dart';
// import 'package:atrons_v1/home/homepage/network.dart';
import 'package:atrons_v1/home/shelf/shelf.dart';
import 'package:atrons_v1/utils/user_preferences.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../database.dart';
import '../../models/book.dart';
import '../components/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.user}) : super(key: key);
  final User? user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Map _source = {ConnectivityResult.none: false};
  // final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  String string = '';
  Color internetColor = Colors.grey;

  int _currentIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var isDeviceConnected = false;
  bool isAlertSet = false;

  // Future<void> secureScreen() async {
  //   await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  // }

  @override
  void initState() {
    // getConnectivity();
    super.initState();
    // secureScreen();
    // _networkConnectivity.initialize();
    // _networkConnectivity.myStream.listen((source) {
    //   _source = source;
    //   switch (_source.keys.toList()[0]) {
    //     case ConnectivityResult.mobile:
    //       string =
    //           _source.values.toList()[0] ? 'Mobile: Online' : 'Mobile: Offline';
    //       internetColor = _source.values.toList()[0] ? Colors.teal : Colors.red;
    //       break;
    //     case ConnectivityResult.wifi:
    //       string =
    //           _source.values.toList()[0] ? 'Wifi: Online' : 'Wifi: Offline';
    //       internetColor = _source.values.toList()[0] ? Colors.teal : Colors.red;
    //       break;
    //     case ConnectivityResult.none:
    //     default:
    //       string = 'Offline';
    //   }
    //   setState(() {});
    //   if (internetColor == Colors.grey) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(string),
    //         backgroundColor: internetColor,
    //         duration: Duration(seconds: 3),
    //       ),
    //     );
    //   }
    // });
  }

  @override
  void dispose() {
    // _networkConnectivity.disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Book>>(
        stream: getBooks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child:
                    Text('Something went wrong (homepage): ${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            final localUser = UserPreferences.getUser();

            final books = snapshot.data!;

            Book? currentBook;
            if (localUser.currentBook != '') {
              currentBook = books
                  .where((book) => book.bookid == localUser.currentBook)
                  .toList()[0];
            } else {
              currentBook = null;
            }

            final isDarkMode = localUser.isDarkMode;
            return ThemeSwitchingArea(
              child: Builder(builder: (context) {
                return Scaffold(
                  key: _scaffoldKey,
                  drawer: MyDrawer(user: widget.user),
                  body: IndexedStack(
                    children: [
                      Explore(allBooks: books),
                      Shelf(allBooks: books),
                      AudioBook(allBooks: books),
                      // Bookmark(allBooks: books),
                    ],
                    index: _currentIndex,
                  ),
                  floatingActionButton: FloatingActionButton(
                    child: const Icon(Icons.menu_book_rounded),
                    onPressed: () {
                      CustomDialogBox(context, currentBook);
                    },
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: _currentIndex,
                    onTap: (index) => setState(() => _currentIndex = index),
                    elevation: 25,
                    // backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    unselectedIconTheme: IconThemeData(
                      color: Colors.grey[300],
                      size: 30,
                    ),
                    selectedIconTheme: IconThemeData(
                      color: isDarkMode ? const Color(0xFF5EA3DE) : Colors.teal,
                      size: 30,
                    ),
                    selectedItemColor:
                        isDarkMode ? const Color(0xFF5EA3DE) : Colors.teal,
                    unselectedLabelStyle: TextStyle(color: Colors.grey[300]),
                    unselectedFontSize: 13,
                    selectedFontSize: 13,
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(MdiIcons.compassOutline),
                        label: 'Explore',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(MdiIcons.bookshelf),
                        label: 'Shelf',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(MdiIcons.microphone),
                        label: 'Audio',
                      ),
                      // BottomNavigationBarItem(
                      //   icon: Icon(MdiIcons.bookmarkOutline),
                      //   label: 'Bookmarks',
                      // ),
                    ],
                  ),
                );
              }),
            );
          } else {
            return const Scaffold(
              body: LoadingSkeleton(),
            );
          }
        });
  }
}
