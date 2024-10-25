import 'package:atrons_v1/home/components/skeleton.dart';
import 'package:atrons_v1/home/screens/Description/book_desc.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

// import '../../colors.dart';
import '../../database.dart';
import '../../models/book.dart';
import '../screens/book_category.dart';

class HorizontalBookList extends StatelessWidget {
  const HorizontalBookList(
      {super.key, required this.title, required this.tag, this.removedBookId});

  final String title;
  final String? removedBookId;
  final String tag;

  @override
  Widget build(BuildContext context) {
    List<Book> filteredBooks = [];
    return SizedBox(
      height: 261,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  child: BookCategory(category: title, books: filteredBooks),
                  type: PageTransitionType.rightToLeft,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.only(left: 18),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    iconSize: 23,
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: BookCategory(
                              category: title, books: filteredBooks),
                          type: PageTransitionType.rightToLeft,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Book>>(
                stream: getBooks(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final books = snapshot.data!;
                    filteredBooks = books.where((book) {
                      return book.tags.contains(title);
                    }).toList();
                    if (title == 'Free') {
                      filteredBooks = books.where((book) {
                        return book.price == 'Free' || book.price == '';
                      }).toList();
                    }
                    if (title.startsWith('More by')) {
                      filteredBooks = books.where((book) {
                        final author = title.substring(8);
                        return book.author == author &&
                            removedBookId != book.bookid;
                      }).toList();
                    }
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredBooks.length,
                      itemBuilder: (context, index) {
                        final book = filteredBooks.elementAt(index);
                        return InkWell(
                          onTap: () {
                            if (title.startsWith('More by')) {
                              Navigator.pushReplacement(
                                context,
                                PageTransition(
                                  child: BookDesc(
                                    book: book,
                                    allBooks: books,
                                    tag: '$tag${book.title}',
                                  ),
                                  type: PageTransitionType.fade,
                                ),
                              );
                            }
                            Navigator.push(
                              context,
                              PageTransition(
                                child: BookDesc(
                                  book: book,
                                  allBooks: books,
                                  tag: '$tag${book.title}',
                                ),
                                type: PageTransitionType.fade,
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Hero(
                                    tag: '$tag${book.title}',
                                    child: Image.network(
                                      book.imageUrl,
                                      fit: BoxFit.fill,
                                      height: 160,
                                      width: 120,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/noimage.png',
                                          fit: BoxFit.fill,
                                          height: 160,
                                          width: 120,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'By ${book.author.length < 20 ? book.author : '${book.author.substring(0, 18)}..'}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  book.price == '' ? '' : '${book.price} ETB',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        book.price == '' ? null : Colors.teal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Skeleton(
                                height: 160,
                                width: 120,
                                radius: 10,
                              ),
                              SizedBox(height: 5),
                              Skeleton(height: 10, width: 120, radius: 8)
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Skeleton(
                                height: 160,
                                width: 120,
                                radius: 10,
                              ),
                              SizedBox(height: 5),
                              Skeleton(height: 10, width: 120, radius: 8)
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }),
          ),
          // const Divider(color: Colors.black45),
        ],
      ),
    );
  }
}
