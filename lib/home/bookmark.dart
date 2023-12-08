import 'package:atrons_v1/home/screens/Description/book_desc.dart';
import 'package:atrons_v1/home/screens/Search/searching.dart';
import 'package:atrons_v1/utils/user_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../models/book.dart';

class Bookmark extends StatefulWidget {
  const Bookmark({Key? key, required this.allBooks}) : super(key: key);
  final List<Book> allBooks;

  @override
  State<Bookmark> createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  

  @override
  Widget build(BuildContext context) {
    final localUser = UserPreferences.getUser();
    
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return [
            SliverAppBar(
              elevation: 0.0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                iconSize: 26,
                // color: Colors.teal,
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  iconSize: 26,
                  onPressed: () {
                    showSearch(context: context, delegate: Searching());
                  },
                ),
              ],
              expandedHeight: 100.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  'Bookmarks',
                  style: TextStyle(
                    color: localUser.isDarkMode ? Colors.white70 : Colors.teal,
                  ),
                ),
              ),
            ),
          ];
        },
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(localUser.userID)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
    
            final DocumentSnapshot doc = snapshot.data!;
            final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
            if (data['bookmark'].length == 0) {
              return const Center(
                child: Text('No bookmarks yet'),
              );
            }
    
            final List bookmarks = (data['bookmark'] as List).map((book) {
              return book;
            }).toList();
    
            List<Book> myBooks = [];
    
            for (int i = 0; i < widget.allBooks.length; i++) {
              for (int j = 0; j < bookmarks.length; j++) {
                if (widget.allBooks[i].bookid == bookmarks[j]) {
                  myBooks.add(widget.allBooks[i]);
                }
              }
            }
    
            return ListView.separated(
              itemCount: myBooks.length,
              itemBuilder: (context, index) {
                Book book = myBooks[index];
    
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: BookDesc(book: book, allBooks: widget.allBooks),
                        type: PageTransitionType.fade,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 120,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 120,
                          width: 90,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(book.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: SizedBox(
                            height: 110,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 10),
                                Text(
                                  book.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  book.author,
                                  style: TextStyle(fontWeight: FontWeight.w100),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.bookmark_added),
                            color: UserPreferences.getUser().isDarkMode
                                ? Colors.white70
                                : Colors.teal,
                            iconSize: 25,
                            onPressed: () {},
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
          },
        ),
      ),
    );
  }
}
