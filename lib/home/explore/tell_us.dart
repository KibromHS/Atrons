import 'package:atrons_v1/home/screens/check_rated_user.dart';
import 'package:atrons_v1/models/book.dart';
import 'package:atrons_v1/utils/user_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../screens/Description/book_desc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../screens/book_review.dart';

class TellUs extends StatefulWidget {
  const TellUs({Key? key, required this.allBooks}) : super(key: key);

  final List<Book> allBooks;

  @override
  State<TellUs> createState() => _TellUsState();
}

class _TellUsState extends State<TellUs> {
  final localUser = UserPreferences.getUser();
  // ignore: unused_field
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: StreamBuilder(
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

          final List mybooks =
              (data['mybooks'] as List).map((book) => book).toList();

          List<Book> myUnratedBooks = [];
          final List<Book> myBooksTmp = [];

          // get mybooks from bookid
          for (int i = 0; i < widget.allBooks.length; i++) {
            for (int j = 0; j < mybooks.length; j++) {
              if (widget.allBooks[i].bookid == mybooks[j]) {
                myBooksTmp.add(widget.allBooks[i]);
              }
            }
          }

          // remove already rated books
          // for (int i = 0; i < myBooksTmp.length; i++) {
          //   if (myBooksTmp[i].ratingsReviews.isEmpty) {
          //     myUnratedBooks.add(myBooksTmp[i]);
          //   } else {
          //     for (int j = 0; j < myBooksTmp[i].ratingsReviews.length; j++) {
          //       final data = jsonDecode(myBooksTmp[i].ratingsReviews[j]);
          //       if (localUser.userID != data['userid']) {
          //         myUnratedBooks.add(myBooksTmp[i]);
          //       }
          //     }
          //   }
          // }

          for (int i = 0; i < myBooksTmp.length; i++) {
            if (CheckRatedUser.check(myBooksTmp[i])) {
            } else {
              myUnratedBooks.add(myBooksTmp[i]);
            }
          }

          myUnratedBooks =
              myUnratedBooks.where((book) => <dynamic>{}.add(book)).toList();

          if (myUnratedBooks.isEmpty) {
            return const Center(
              child: Text('Purchase and Rate books'),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 18),
                height: 50,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Tell us what you think',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  onPageChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  physics: const BouncingScrollPhysics(),
                  controller: PageController(viewportFraction: 0.85),
                  itemCount: myUnratedBooks.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      height: 30,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: BookDesc(
                                    book: myUnratedBooks[index],
                                    allBooks: widget.allBooks,
                                    tag: 'tag $index',
                                  ),
                                  type: PageTransitionType.fade,
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: Hero(
                                    tag: 'tag $index',
                                    child: Image.network(
                                      myUnratedBooks[index].imageUrl,
                                      fit: BoxFit.fill,
                                      height: 90,
                                      width: 90,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/noimage.png',
                                          fit: BoxFit.fill,
                                          height: 90,
                                          width: 90,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      myUnratedBooks[index].title.length < 15
                                          ? myUnratedBooks[index].title
                                          : '${myUnratedBooks[index].title.substring(0, 13)} ...',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const Text('Public review',
                                        style: TextStyle(fontSize: 13)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          RatingBar(
                            minRating: 1,
                            tapOnlyMode: true,
                            glow: false,
                            itemSize: 30,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            ratingWidget: RatingWidget(
                              full: const Icon(Icons.star_rate,
                                  color: Colors.teal),
                              half: const Icon(Icons.star_half_sharp),
                              empty: const Icon(Icons.star_rate_outlined,
                                  color: Colors.grey),
                            ),
                            onRatingUpdate: (value) {
                              if (CheckRatedUser.check(myUnratedBooks[index])) {
                                const snackbar = SnackBar(
                                  content:
                                      Text('You have already rated this book'),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.red,
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackbar);
                              } else {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: BookReview(
                                        book: myUnratedBooks[index],
                                        rating: value),
                                    type: PageTransitionType.rightToLeft,
                                  ),
                                );
                              }
                            },
                          ),
                          TextButton(
                            child: const Text(
                              'Write a review',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              primary: Colors.teal,
                            ),
                            onPressed: () {
                              if (CheckRatedUser.check(myUnratedBooks[index])) {
                                const snackbar = SnackBar(
                                  content:
                                      Text('You have already rated this book'),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.red,
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackbar);
                              } else {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child:
                                        BookReview(book: myUnratedBooks[index]),
                                    type: PageTransitionType.rightToLeft,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // const Divider(color: Colors.black45),
            ],
          );
        },
      ),
    );
  }
}
