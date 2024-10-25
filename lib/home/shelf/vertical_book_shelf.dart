import 'package:atrons_v1/colors.dart';
import 'package:atrons_v1/home/screens/Description/purchased.dart';
import 'package:atrons_v1/models/book.dart';
import 'package:atrons_v1/utils/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../screens/book_review.dart';

class VerticalBookShelf extends StatelessWidget {
  const VerticalBookShelf({
    super.key,
    required this.context,
    required this.book,
    required this.tag,
  });

  final BuildContext context;
  final Book book;
  final String tag;

  @override
  Widget build(BuildContext context) {
    final localUser = UserPreferences.getUser();
    final isDarkMode = localUser.isDarkMode;
    final subColor = isDarkMode ? Colors.white38 : Colors.black45;

    return InkWell(
      onTap: () async {
        await Purchased.openAtronsBook(book.title, book.bookid);
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
                      style: TextStyle(color: subColor),
                    ),
                    Expanded(child: Container()),
                    Text(
                      '${book.pagesRead} of ${book.pages} pages',
                      style: TextStyle(color: subColor, fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.63,
                      height: 9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: (book.getPercentRead() / 100),
                          backgroundColor: isDarkMode
                              ? Colors.grey.shade700
                              : Colors.grey.shade300,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(MyColors.green),
                          minHeight: 5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox(width: 7),
                            Text('Delete'),
                          ],
                        ),
                      ),
                      onTap: () async {
                        localUser.mybooks.remove(book);
                        localUser.removeFromMyBooks(book.bookid);
                        await Purchased.deleteAtronsBook(book.title);
                        UserPreferences.setUser(localUser);
                        
                      },
                    ),
                    PopupMenuItem(
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Icon(Icons.star_rate),
                            SizedBox(width: 7),
                            Text('Rate Book'),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          PageTransition(
                            child: BookReview(book: book),
                            type: PageTransitionType.rightToLeft,
                          ),
                        );
                      },
                    ),
                  ];
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
