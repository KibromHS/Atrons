import 'dart:math';

import 'package:atrons_v1/home/components/download_alert.dart';
import 'package:atrons_v1/home/screens/Description/purchased.dart';
import 'package:atrons_v1/models/book.dart';
import 'package:atrons_v1/utils/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

// import '../../colors.dart';
import '../screens/Description/book_desc.dart';

// ignore: must_be_immutable
class LuckyBook extends StatelessWidget {
  LuckyBook({super.key, required this.allBooks});

  final List<Book> allBooks;
  late int randomInt = Random().nextInt(allBooks.length);
  final localUser = UserPreferences.getUser();

  bool isBookPurchased() {
    if (localUser.mybooks.contains(allBooks[randomInt].bookid)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: BookDesc(
                          book: allBooks[randomInt],
                          allBooks: allBooks,
                          tag: 'lucky-book-tag',
                        ),
                        type: PageTransitionType.fade,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      children: [
                        Hero(
                          tag: 'lucky-book-tag',
                          child: Image.network(
                            allBooks[randomInt].imageUrl,
                            width: 100,
                            height: 140,
                            fit: BoxFit.fill,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/noimage.png',
                                fit: BoxFit.fill,
                                height: 140,
                                width: 100,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                allBooks[randomInt].title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'By ${allBooks[randomInt].author}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                allBooks[randomInt].description,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[600]),
                                maxLines: 6,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text(allBooks[randomInt].getRating()),
                          Icon(Icons.star, color: Colors.grey[700], size: 14),
                        ],
                      ),
                      isBookPurchased()
                          ? TextButton.icon(
                              icon: const Icon(Icons.file_open),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.teal,
                              ),
                              label: const Text('Open'),
                              onPressed: () async {
                                await Purchased.openAtronsBook(
                                  allBooks[randomInt].title,
                                  allBooks[randomInt].bookid,
                                );
                              },
                            )
                          : TextButton.icon(
                              icon: const Icon(Icons.payment),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.teal,
                              ),
                              label: const Text('Purchase'),
                              onPressed: () async {
                                DownloadAlert.show(
                                    context: context,
                                    book: allBooks[randomInt]);
                              },
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // const Divider(color: Colors.black45),
      ],
    );
  }
}
