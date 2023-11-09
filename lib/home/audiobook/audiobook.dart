import 'package:atrons_v1/home/audiobook/player.dart';
import 'package:atrons_v1/home/components/my_sliverappbar.dart';
import 'package:atrons_v1/utils/user_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/book.dart';

class AudioBook extends StatefulWidget {
  const AudioBook({super.key, required this.allBooks});

  final List<Book> allBooks;

  @override
  State<AudioBook> createState() => _AudioBookState();
}

class _AudioBookState extends State<AudioBook> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localUser = UserPreferences.getUser();

    return NestedScrollView(
      physics: const BouncingScrollPhysics(),
      headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
        return [
          MyCustomSliverAppBar(allBooks: widget.allBooks),
        ];
      },
      body: Column(
        children: [
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

                if (data['myaudios'].length == 0) {
                  return const Center(
                    child: Text('You have not purchased any audiobook yet'),
                  );
                }

                final List myaudiobooks =
                    (data['myaudios'] as List).map((book) => book).toList();

                List<Book> books = [];

                for (int i = 0; i < widget.allBooks.length; i++) {
                  for (int j = 0; j < myaudiobooks.length; j++) {
                    if (widget.allBooks[i].bookid == myaudiobooks[j]) {
                      books.add(widget.allBooks[i]);
                    }
                  }
                }

                return ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => Player(book: books[index]),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.teal,
                              width: 0.65,
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(40),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 100,
                                width: 80,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(books[index].imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: SizedBox(
                                  height: 110,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const SizedBox(height: 10),
                                      Text(
                                        books[index].title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                        books[index].author,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) {
                                          return Player(book: books[index]);
                                        },
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.play_circle_outline_rounded,
                                  ),
                                  iconSize: 36,
                                  color: Colors.teal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
