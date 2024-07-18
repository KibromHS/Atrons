import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:atrons_v1/home/components/download_alert.dart';
import 'package:atrons_v1/home/explore/horizontal_book_list.dart';
import 'package:atrons_v1/home/screens/Description/purchased.dart';
import 'package:atrons_v1/home/screens/Description/rate_stars.dart';
import 'package:atrons_v1/home/screens/Description/review.dart';
import 'package:atrons_v1/home/screens/book_review.dart';
import 'package:atrons_v1/home/screens/check_rated_user.dart';
import 'package:atrons_v1/models/user.dart';
import 'package:atrons_v1/utils/user_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:page_transition/page_transition.dart';
import '../../../models/book.dart';
import './book_info.dart';

class BookDesc extends StatefulWidget {
  const BookDesc(
      {Key? key, required this.book, required this.allBooks, this.tag = ''})
      : super(key: key);

  final Book book;
  final List<Book> allBooks;
  final String tag;

  @override
  State<BookDesc> createState() => _BookDescState();
}

class _BookDescState extends State<BookDesc> {
  var top = 0.0;
  late ScrollController scrollController;
  User localUser = UserPreferences.getUser();
  bool downloading = false;
  List<Map<String, dynamic>> myReviews = [];
  // double myRate = 0;
  // String? myReview;

  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    widget.allBooks.removeWhere((otherBook) {
      return otherBook.bookid == widget.book.bookid;
    });
    scrollController.addListener(() {
      setState(() {});
    });

    for (final ratingreview in widget.book.ratingsReviews) {
      final ratedata = jsonDecode(ratingreview);

      getUserImageAndName(ratedata['userid']).then((value) {
        myReviews.add({
          'name': value['name'],
          'image': value['image'],
          'rating': ratedata['rating'],
          'review': ratedata['review']
        });
      });
    }
  }

  Future<Map<String, String>> getUserImageAndName(String userid) async {
    String image = 'assets/images/noprofile.png';
    String username = 'Someone';
    final docRef = FirebaseFirestore.instance.collection('Users').doc(userid);

    await docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        image = data['Image'];
        username = data['Full Name'];
      },
    );
    return {'image': image, 'name': username};
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;
    String price = widget.book.price == '' ? 'Free' : '\$${widget.book.price}';
    final localUser = UserPreferences.getUser();
    ImageProvider image;
    if (localUser.imagePath.contains('assets')) {
      image = AssetImage(localUser.imagePath);
    } else if (localUser.imagePath.contains('https://')) {
      image = NetworkImage(localUser.imagePath);
    } else {
      image = FileImage(File(localUser.imagePath));
    }
    widget.book.addNumOfView();

    bool otherBooksByAuthor() {
      for (int i = 0; i < widget.allBooks.length; i++) {
        if (widget.allBooks[i].author == widget.book.author) {
          if (widget.allBooks[i].bookid == widget.book.bookid) {
            widget.allBooks.remove(widget.allBooks[i]);
          } else {
            return true;
          }
        }
      }
      return false;
    }

    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Books')
              .doc(widget.book.bookid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final DocumentSnapshot doc = snapshot.data!;
            final Map<String, dynamic> data =
                doc.data() as Map<String, dynamic>;

            bool isUnrated = true, isMyBook;

            final List<Map<String, dynamic>> bookRatingsReviews =
                (data['RatingsReviews'] as List).map((bookRatingReview) {
              return jsonDecode(bookRatingReview) as Map<String, dynamic>;
            }).toList();

            final myRatingReview = bookRatingsReviews
                .where((rateReview) => rateReview['userid'] == localUser.userID)
                .toList();

            if (localUser.mybooks.contains(widget.book.bookid)) {
              isMyBook = true;
              for (final rating in bookRatingsReviews) {
                if (localUser.userID == rating['userid']) {
                  isUnrated = false;
                }
              }
            } else {
              isMyBook = false;
            }

            return Stack(
              children: [
                CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white70,
                        iconSize: 26,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      actions: [
                        IconButton(
                          icon: localUser.bookmarks.contains(widget.book.bookid)
                              ? const Icon(Icons.bookmark)
                              : const Icon(Icons.bookmark_border),
                          color: Colors.white70,
                          iconSize: 26,
                          onPressed: () {
                            if (localUser.bookmarks
                                .contains(widget.book.bookid)) {
                              localUser.removeMarkedBook(widget.book.bookid);
                              localUser.bookmarks.remove(widget.book.bookid);
                            } else {
                              localUser.addMarkedBook(widget.book.bookid);
                              localUser.bookmarks.add(widget.book.bookid);
                            }
                            UserPreferences.setUser(localUser);
                            setState(() {});
                          },
                        ),
                      ],
                      expandedHeight: phoneHeight / 2,
                      backgroundColor: UserPreferences.getUser().isDarkMode
                          ? const Color(0xFF1D2733)
                          : Colors.teal,
                      collapsedHeight: 150,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      flexibleSpace: LayoutBuilder(
                        builder: (cxt, cons) {
                          top = cons.biggest.height;
                          return FlexibleSpaceBar(
                            background: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    widget.book.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container();
                                    },
                                  ),
                                  BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                    child: Container(
                                      color: Colors.black.withOpacity(0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            collapseMode: CollapseMode.pin,
                            centerTitle: true,
                            title: top <= 260
                                ? BookInfoSmall(
                                    top: top,
                                    price: price,
                                    descWidget: widget,
                                  )
                                : BookInfoBig(widget: widget),
                          );
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        // color: MyColors.whiteGreen,
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          // shrinkWrap: true,
                          // primary: false,
                          children: [
                            const SizedBox(height: 10),
                            Text(widget.book.title,
                                style: const TextStyle(fontSize: 25)),
                            const SizedBox(height: 6),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    color: localUser.isDarkMode
                                        ? Colors.white70
                                        : Colors.black),
                                children: [
                                  const TextSpan(text: 'Author: '),
                                  TextSpan(
                                    text: widget.book.author,
                                    style: const TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              widget.book.description,
                              style: const TextStyle(fontSize: 15, height: 1.5),
                            ),

                            //////////////// Edit review: If you have rated/reviewed this book ///////////////////////////////
                            if (isMyBook && !isUnrated)
                              // your review
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 30),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 5,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: image,
                                          radius: 20,
                                        ),
                                        const SizedBox(width: 20),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              localUser.name,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 7),
                                            RateStars(
                                                rate: myRatingReview[0]
                                                    ['rating'])
                                          ],
                                        ),
                                        Expanded(child: Container()),
                                        PopupMenuButton(
                                          itemBuilder: (context) {
                                            return [
                                              PopupMenuItem(
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.delete),
                                                      SizedBox(width: 7),
                                                      Text('Delete'),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {
                                                  // Delete your rate and review
                                                  widget.book.deleteRating({
                                                    'userid': localUser.userID,
                                                    'rating': myRatingReview[0]
                                                        ['rating'],
                                                    'review': myRatingReview[0]
                                                        ['review']
                                                  });
                                                  setState(() {});
                                                  Navigator.of(context).pop();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Your review is removed'),
                                                      duration:
                                                          Duration(seconds: 3),
                                                      backgroundColor:
                                                          Colors.teal,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ];
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(myRatingReview[0]['review']),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 13),
                                    child: TextButton(
                                      child: const Text(
                                        'Edit your review',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.teal,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: BookReview(
                                              book: widget.book,
                                              rating: myRatingReview[0]
                                                  ['rating'],
                                              review: myRatingReview[0]
                                                  ['review'],
                                            ),
                                            type:
                                                PageTransitionType.rightToLeft,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ///////////////////////////////////////////////////////////////////////
                            //////////////// If book is not rated and it's purchased /////////////////////////////////////
                            if (isMyBook && isUnrated)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 30),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 15),
                                        child: Text(
                                          'Rate this book',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 15),
                                        child:
                                            Text('Tell others what you think'),
                                      ),
                                      const SizedBox(height: 13),
                                      RatingBar(
                                        minRating: 1,
                                        tapOnlyMode: true,
                                        glow: false,
                                        itemSize: 30,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        ratingWidget: RatingWidget(
                                          full: const Icon(Icons.star_rate,
                                              color: Colors.teal),
                                          half:
                                              const Icon(Icons.star_half_sharp),
                                          empty: const Icon(
                                              Icons.star_rate_outlined,
                                              color: Colors.grey),
                                        ),
                                        onRatingUpdate: (value) {
                                          if (CheckRatedUser.check(
                                              widget.book)) {
                                            const snackbar = SnackBar(
                                              content: Text(
                                                  'You have already rated this book'),
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
                                                  book: widget.book,
                                                  rating: value,
                                                ),
                                                type: PageTransitionType
                                                    .rightToLeft,
                                              ),
                                            );
                                          }
                                          BookDesc(
                                              book: widget.book,
                                              allBooks: widget.allBooks);
                                        },
                                      ),
                                      const SizedBox(height: 8),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 13),
                                        child: TextButton(
                                          child: const Text(
                                            'Write a review',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.teal,
                                          ),
                                          onPressed: () {
                                            if (CheckRatedUser.check(
                                                widget.book)) {
                                              const snackbar = SnackBar(
                                                content: Text(
                                                    'You have already rated this book'),
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
                                                    book: widget.book,
                                                  ),
                                                  type: PageTransitionType
                                                      .rightToLeft,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            /////////////////////////////////////////////////////////////////////
                            const SizedBox(height: 30),
                            const Text('Ratings',
                                style: TextStyle(fontSize: 20)),
                            const SizedBox(height: 20),
                            Text(
                              widget.book.getRating(),
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            RateStars(
                              rate: double.parse(widget.book.getRating()),
                            ),
                            const SizedBox(height: 5),
                            Text('${widget.book.peopleRated} votes'),
                            const SizedBox(height: 40),
                            if (widget.book.areReviews())
                              const Text('Reviews',
                                  style: TextStyle(fontSize: 20)),
                            const SizedBox(height: 20),

                            ...myReviews.map((ratingReview) {
                              if (ratingReview['review'] == '') {
                                return Container();
                              }

                              final imagePath = ratingReview['image'];
                              final usernamePath = ratingReview['name'];

                              ImageProvider image;

                              if (imagePath.contains('https://')) {
                                image = NetworkImage(imagePath);
                              } else if (imagePath.contains('assets')) {
                                image = AssetImage(imagePath);
                              } else {
                                image = FileImage(File(imagePath));
                              }

                              return Review(
                                image: image,
                                username: usernamePath,
                                rate: ratingReview['rating'].toDouble(),
                                review: ratingReview['review'],
                              );
                            }).toList(),

                            if (otherBooksByAuthor())
                              HorizontalBookList(
                                title: 'More by ${widget.book.author}',
                                tag: widget.book.title,
                                removedBookId: widget.book.bookid,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                buildFab(phoneWidth, phoneHeight, price, isMyBook),
              ],
            );
          }),
    );
  }

  Widget buildFab(
      double phoneWidth, double phoneHeight, String price, bool itIsMyBook) {
    final double defaultMargin = phoneHeight / 2;
    final double defaultStart = defaultMargin - 40;
    final double defaultEnd = defaultStart / 1.7;

    double center = (phoneWidth - (phoneWidth / 2)) / 2;

    double top = defaultMargin;
    double scale = 1.0;

    if (scrollController.hasClients) {
      double offset = scrollController.offset;
      top -= offset;

      if (offset < defaultMargin - defaultStart) {
        scale = 1.0;
      } else if (offset < defaultStart - defaultEnd) {
        scale = (defaultMargin - defaultEnd - offset) / defaultEnd;
      } else {
        scale = 0.0;
      }
    }

    return Positioned(
      top: top,
      right: center,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(scale),
        child: SizedBox(
          width: (phoneWidth / 2),
          child: itIsMyBook
              ? FloatingActionButton.extended(
                  // backgroundColor: MyColors.lightGreenmod,
                  shape: const StadiumBorder(),
                  label: const Row(
                    children: [
                      Icon(Icons.file_open),
                      SizedBox(width: 10),
                      Text('Open'),
                    ],
                  ),
                  onPressed: () async {
                    setState(() {
                      downloading = true;
                    });
                    if (!await File(
                            '/storage/emulated/0/Atrons/${widget.book.title.replaceAll(' ', '_').replaceAll(r"\'", "'")}.epub')
                        .exists()) {
                      print(
                          '!!!!!!!!!!!!!!!!!!!!!local path is null!!!!!!!!!!!!!!!!!!!!!!!!!!');
                    } else {
                      print(
                          '!!!!!!!!!!!!!!!!!!!!!the file is there !!!!!!!!!!!!!!!!!!!!!!');
                    }

                    await Purchased.openAtronsBook(widget.book.title, widget.book.bookid);
                    setState(() {
                      downloading = false;
                    });
                  },
                )
              : FloatingActionButton.extended(
                  // backgroundColor: MyColors.lightGreenmod,
                  shape: const StadiumBorder(),
                  label: downloading
                      ? const SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Row(
                          children: [
                            const Icon(Icons.sell_outlined),
                            const SizedBox(width: 10),
                            Text(
                              price,
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(width: 10),
                            const Text('Purchase'),
                          ],
                        ),
                  onPressed: downloading
                      ? null
                      : () async {
                          setState(() {
                            downloading = true;
                          });
                          await DownloadAlert.show(
                              context: context, book: widget.book);

                          setState(() {
                            downloading = false;
                            localUser.mybooks.add(widget.book.bookid);
                            UserPreferences.setUser(localUser);
                          });
                        },
                ),
        ),
      ),
    );
  }
}
