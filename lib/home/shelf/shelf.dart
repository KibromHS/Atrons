import 'package:atrons_v1/home/components/my_sliverappbar.dart';
// import 'package:atrons_v1/home/screens/book_desc.dart';
import 'package:atrons_v1/home/shelf/vertical_book_shelf.dart';
import 'package:atrons_v1/utils/user_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:page_transition/page_transition.dart';
import '../../colors.dart';
import '../../models/book.dart';

class Shelf extends StatefulWidget {
  const Shelf({super.key, required this.allBooks});

  final List<Book> allBooks;

  @override
  State<Shelf> createState() => _ShelfState();
}

class _ShelfState extends State<Shelf> {
  late ScrollController scrollController;
  

  

  @override
  void initState() {
    scrollController = ScrollController(keepScrollOffset: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localUser = UserPreferences.getUser();
    
    return NestedScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
        return [
          MyCustomSliverAppBar(allBooks: widget.allBooks),
        ];
      },
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  fixedSize: const Size(120, 10),
                  side: BorderSide(
                    color: localUser.isDarkMode
                        ? MyColors.whiteGreenmod
                        : MyColors.green,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Filter myBooks => Reading & Completed
                },
                child: Text(
                  'Reading',
                  style: TextStyle(
                      color:
                          localUser.isDarkMode ? Colors.white54 : Colors.black),
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  fixedSize: const Size(120, 10),
                  side: BorderSide(
                    color: localUser.isDarkMode
                        ? MyColors.whiteGreenmod
                        : MyColors.green,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Completed',
                  style: TextStyle(
                      color:
                          localUser.isDarkMode ? Colors.white54 : Colors.black),
                ),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(localUser.userID)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final DocumentSnapshot doc = snapshot.data!;
                final Map<String, dynamic> data =
                    doc.data() as Map<String, dynamic>;

                if (data['mybooks'].length == 0) {
                  return const Center(
                    child: Text('You have not purchased any book yet'),
                  );
                }

                final List mybooks =
                    (data['mybooks'] as List).map((book) => book).toList();

                List<Book> books = [];

                for (int i = 0; i < widget.allBooks.length; i++) {
                  for (int j = 0; j < mybooks.length; j++) {
                    if (widget.allBooks[i].bookid == mybooks[j]) {
                      books.add(widget.allBooks[i]);
                    }
                  }
                }

                return ListView.separated(
                  itemCount: books.length,
                  separatorBuilder: (context, index) {
                    return const Divider(height: 30);
                  },
                  itemBuilder: (context, index) {
                    return VerticalBookShelf(
                      context: context,
                      book: books[index],
                      tag: 'tag$index',
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
