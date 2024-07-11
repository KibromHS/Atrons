import 'dart:async';

import 'package:atrons_v1/home/screens/Description/book_desc.dart';
import 'package:atrons_v1/home/screens/book_category.dart';
import 'package:atrons_v1/models/book.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../components/my_sliverappbar.dart';
import '../../database.dart';
import '../components/skeleton.dart';
import 'horizontal_book_list.dart';
import 'lucky_book.dart';
import 'tell_us.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key, required this.allBooks}) : super(key: key);

  final List<Book> allBooks;

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  late ScrollController scrollController;
  late List<String> bookGenres;
  List<String> uniqueTagList = [];
  int currentBookIndex = 0;
  int _selectedIndex = 0;
  int sublist = 0;
  late Timer _timer;
  final PageController _pageController = PageController(viewportFraction: 0.7);

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_selectedIndex < widget.allBooks.length - 1) {
        _selectedIndex++;
      } else {
        _selectedIndex = 0;
      }
      _pageController.animateToPage(
        _selectedIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });

    List<String> myTags = [];
    for (int i = 0; i < widget.allBooks.length; i++) {
      if (widget.allBooks[i].price == '' ||
          widget.allBooks[i].price == 'Free') {
        myTags.add('Free');
      }
      for (int j = 0; j < widget.allBooks[i].tags.length; j++) {
        myTags.add(widget.allBooks[i].tags[j]);
      }
    }
    var seen = Set<String>();
    uniqueTagList =
        myTags.where((tag) => seen.add(tag)).toList(); // eliminate repeatition
    uniqueTagList.removeWhere((tag) => tag == '');

    if (uniqueTagList.contains('Free')) {
      uniqueTagList.removeWhere((tag) => tag == 'Free');
      uniqueTagList.insert(0, 'Free');
      sublist++;
    }
    if (uniqueTagList.contains('Top selling')) {
      uniqueTagList.removeWhere((tag) => tag == 'Top selling');
      uniqueTagList.insert(0, 'Top selling');
      sublist++;
    }

    bookGenres = ['All', ...uniqueTagList];
    
    if (uniqueTagList.contains('All')) {
      uniqueTagList.remove('All');
    }

    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   CustomDialogBox(context, currentBookIndex);
    //   if (scrollController.position.maxScrollExtent ==
    //       scrollController.offset) {
    //     CustomDialogBox(context, currentBookIndex);
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        MyCustomSliverAppBar(allBooks: widget.allBooks),
        SliverPadding(
          padding: const EdgeInsets.all(12.0),
          sliver: SliverFixedExtentList(
            itemExtent: 265, // Don't touch this number
            delegate: SliverChildListDelegate([
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<List<Book>>(
                        stream: getBooks(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                  'Something went wrong (explore header): ${snapshot.error}'),
                            );
                          } else if (snapshot.hasData) {
                            final books = snapshot.data!;

                            return SizedBox(
                              height: 170,
                              child: PageView.builder(
                                onPageChanged: (index) {
                                  setState(() {
                                    _selectedIndex = index;
                                  });
                                },
                                physics: const BouncingScrollPhysics(),
                                controller: _pageController,
                                itemCount: books.length,
                                itemBuilder: (context, index) {
                                  var _scale =
                                      _selectedIndex == index ? 1 : 0.8;

                                  return TweenAnimationBuilder(
                                    tween: Tween(begin: _scale, end: _scale),
                                    duration: const Duration(milliseconds: 350),
                                    curve: Curves.ease,
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  child: BookDesc(
                                                    book: books[index],
                                                    allBooks: books,
                                                    tag:
                                                        '${books[index].tags[0]}${books[index].title}',
                                                  ),
                                                  type: PageTransitionType.fade,
                                                ),
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                books[index].imageUrl,
                                                fit: BoxFit.fill,
                                                height: 150,
                                                width: 240,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                    'assets/images/noimage.png',
                                                    fit: BoxFit.fill,
                                                    height: 150,
                                                    width: 240,
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    builder: (context, num value, child) {
                                      return Transform.scale(
                                        scale: value.toDouble(),
                                        child: child,
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          } else {
                            return const Center(
                              child: Skeleton(
                                height: 150,
                                width: 240,
                                radius: 10,
                              ),
                            );
                          }
                        }),
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: bookGenres.length,
                        itemBuilder: (context, index) {
                          List<Book> filteredBooks;
                          if (bookGenres[index] == 'Free') {
                            filteredBooks = widget.allBooks.where((book) {
                              return book.price == 'Free' || book.price == '';
                            }).toList();
                          } else if (bookGenres[index] == 'All') {
                            filteredBooks = widget.allBooks;
                          } else {
                            filteredBooks = widget.allBooks.where((book) {
                              return book.tags.contains(bookGenres[index]);
                            }).toList();
                          }

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 7),
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: ElevatedButton(
                              child: Text(bookGenres[index]),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: BookCategory(
                                      category: bookGenres[index],
                                      books: filteredBooks,
                                    ),
                                    type: PageTransitionType.bottomToTop,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                // shadowColor: Colors.grey,
                                elevation: 7,
                                // onPrimary: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3,
                                  horizontal: 25,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (uniqueTagList.contains('Top selling'))
                const HorizontalBookList(
                  title: 'Top selling',
                  tag: 'top-books',
                ),
              if (uniqueTagList.contains('Free'))
                const HorizontalBookList(
                  title: 'Free',
                  tag: 'free-books',
                ),
              LuckyBook(allBooks: widget.allBooks),
              ...uniqueTagList.sublist(sublist).map((tag) {
                return HorizontalBookList(
                  title: tag,
                  tag: tag,
                );
              }).toList(),
              TellUs(allBooks: widget.allBooks),
            ]),
          ),
        ),
      ],
    );
  }
}
