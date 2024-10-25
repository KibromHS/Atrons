import 'package:atrons_v1/home/screens/Description/book_desc.dart';
import 'package:atrons_v1/home/screens/Search/searching.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../models/book.dart';
import '../../utils/user_preferences.dart';

class BookCategory extends StatelessWidget {
  const BookCategory({super.key, required this.category, required this.books});

  final String category;
  final List<Book> books;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: get latest data from database
          return await Future.delayed(
            const Duration(seconds: 2),
          );
        },
        // color: MyColors.green,
        edgeOffset: 130,
        displacement: 70,
        color: Colors.teal,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              // backgroundColor: MyColors.whiteGreenmod,
              elevation: 0.0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                iconSize: 26,
                onPressed: () {
                  Navigator.of(context).pop();
                },
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
                  category,
                  style: GoogleFonts.roboto(
                    color: UserPreferences.getUser().isDarkMode
                        ? Colors.white70
                        : Colors.black87,
                  ),
                ),
              ),
            ),
            SliverGrid.count(
              crossAxisCount: 3,
              childAspectRatio: 0.60,
              children: [
                ...books.map((book) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: BookDesc(
                                  book: book,
                                  allBooks: books,
                                  tag: 'tag-${book.title}',
                                ),
                                type: PageTransitionType.fade,
                              ),
                            );
                          },
                          child: Hero(
                            tag: 'tag-${book.title}',
                            child: Image.network(
                              book.imageUrl,
                              width: 110,
                              height: 133,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Text(
                            'By ${book.author.length < 21 ? book.author : '${book.author.substring(0, 19)}..'}'),
                      ],
                    ),
                  );
                }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
