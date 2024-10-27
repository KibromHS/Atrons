import 'package:atrons_v1/home/bookmark.dart';
import 'package:atrons_v1/home/screens/Search/searching.dart';
import 'package:atrons_v1/models/book.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

class MyCustomSliverAppBar extends StatelessWidget {
  const MyCustomSliverAppBar({super.key, required this.allBooks});

  final List<Book> allBooks;

  @override
  Widget build(BuildContext context) {
    double top = 0.0;

    return SliverAppBar(
      elevation: 0,
      leading: Builder(
        builder: (context) {
          return IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(MdiIcons.viewGridOutline),
            color: Colors.teal,
            iconSize: 35,
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.bookmark_border_outlined),
          iconSize: 35,
          color: Colors.teal,
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                child: Bookmark(allBooks: allBooks),
                type: PageTransitionType.rightToLeft,
              ),
            );
          },
        ),
        // Stack(
        //   children: [
        //     IconButton(
        //       icon: const Icon(Icons.notifications),
        //       // color: Colors.teal,
        //       iconSize: 35,
        //       onPressed: () {
        //         Navigator.of(context).push(
        //           MaterialPageRoute(builder: (_) => Notifications()),
        //         );
        //       },
        //     ),
        //     Visibility(
        //       visible: true,  // TODO: unreadNotifications.length > 0 ? true : false
        //       child: Positioned(
        //         top: 13,
        //         left: 28,
        //         child: Container(
        //           width: 10,
        //           height: 10,
        //           decoration: const BoxDecoration(
        //             shape: BoxShape.circle,
        //             color: Colors.red,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ],
      // backgroundColor: MyColors.whiteGreenmod,
      expandedHeight: 140.0,
      pinned: true,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          top = constraints.biggest.height;
          return FlexibleSpaceBar(
            centerTitle: true,
            title: top >= 105
                ? SizedBox(
                    width: 220,
                    height: 35,
                    child: TextField(
                      onTap: () {
                        showSearch(context: context, delegate: Searching());
                      },
                      textAlignVertical: TextAlignVertical.center,
                      cursorWidth: 1,
                      keyboardType: TextInputType.none,
                      style: const TextStyle(fontSize: 11),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: const TextStyle(
                            color: Colors.black45, fontSize: 12),
                        prefixIcon: const Icon(
                          Icons.search_outlined,
                          color: Colors.black45,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFE5E5E5).withOpacity(0.7),
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  )
                : IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    padding: const EdgeInsets.only(top: 25),
                    icon: const Icon(
                      Icons.search,
                      // color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {
                      showSearch(context: context, delegate: Searching());
                    },
                  ),
          );
        },
      ),
    );
  }
}
