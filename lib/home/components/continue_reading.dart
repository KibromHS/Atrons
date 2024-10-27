import 'package:atrons_v1/database.dart';
import 'package:atrons_v1/home/screens/Description/purchased.dart';
import 'package:atrons_v1/models/book.dart';
import 'package:atrons_v1/utils/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';

import '../../colors.dart';

// ignore: non_constant_identifier_names
YYDialog CustomDialogBox(BuildContext context, Book? currentBook) {
  return YYDialog().build(context)
    ..width = double.infinity
    ..height = 210
    ..backgroundColor = Colors.transparent
    ..gravity = Gravity.bottom
    ..gravityAnimationEnable = true
    ..duration = const Duration(milliseconds: 500)
    ..widget(
      ContinueReadingPopup(cxt: context, book: currentBook),
    )
    ..show();
}

class ContinueReadingPopup extends StatelessWidget {
  const ContinueReadingPopup({super.key, required this.cxt, required this.book});
  final Book? book;
  final BuildContext cxt;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: book == null
          ? null
          : () async {
              await Purchased.openAtronsBook(
                book!.title,
                book!.bookid,
              );
            },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          height: 210,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: UserPreferences.getUser().isDarkMode
                ? const Color(0xFF252D3A)
                : Colors.teal,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Continue Reading',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: MyColors.whiteGreenmod,
                      size: 30,
                    ),
                    onPressed: () => Navigator.of(cxt).pop(),
                  ),
                ],
              ),
              book == null
                  ? Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text(
                          'Purchase and Open a book, then you\'ll get it here.',
                          style: TextStyle(
                              color: MyColors.lightGreenmod, fontSize: 15),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            book!.imageUrl,
                            width: 100,
                            height: 130,
                            fit: BoxFit.fill,
                          ),
                        ),
                        StreamBuilder<List<Book>>(
                            stream: getBooks(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                    'Something went wrong: ${snapshot.error}');
                              } else if (snapshot.hasData) {
                                return SizedBox(
                                  width: 200,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        book!.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 16.5),
                                      ),
                                      Text(
                                        'By ${book!.author}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(book!.getRating()),
                                              Icon(
                                                Icons.star,
                                                color: Colors.grey[700],
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                          // Stack(
                                          //   alignment:
                                          //       AlignmentDirectional.center,
                                          //   children: [
                                          //     SizedBox(
                                          //       width: 70,
                                          //       height: 70,
                                          //       child:
                                          //           CircularProgressIndicator(
                                          //         color: MyColors.whiteGreenmod,
                                          //         backgroundColor:
                                          //             Colors.grey[400],
                                          //         value:
                                          //             (book!.getPercentRead() /
                                          //                 100),
                                          //         strokeWidth: 5,
                                          //       ),
                                          //     ),
                                          //     Text(
                                          //       '${book!.getPercentRead()}%',
                                          //       style: TextStyle(
                                          //         color: MyColors.whiteGreenmod,
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
