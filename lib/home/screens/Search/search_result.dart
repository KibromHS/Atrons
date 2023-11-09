import 'package:atrons_v1/database.dart';
import 'package:atrons_v1/home/components/skeleton.dart';
import 'package:atrons_v1/utils/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../../models/book.dart';
import '../Description/book_desc.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({Key? key, required this.query}) : super(key: key);

  final String query;

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    List<Book> results = [];

    return StreamBuilder<List<Book>>(
        stream: getBooks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final books = snapshot.data!;
            final query = widget.query.trim();
            if (query != '') {
              results = books.where((book) {
                return book.title.toLowerCase().contains(query.toLowerCase()) || book.author.toLowerCase().contains(query.toLowerCase());
              }).toList();

              final localUser = UserPreferences.getUser();

              localUser.addSearched(query);
            }

            if (results.isEmpty && query.isNotEmpty) {
              return Center(
                child: Text('No matches found for "$query"'),
              );
            }

            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                Book book = results[index];

                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: BookDesc(book: book, allBooks: books),
                        type: PageTransitionType.fade,
                      ),
                    );
                  },
                  contentPadding: const EdgeInsets.all(10),
                  leading: Image.network(book.imageUrl),
                  title: Text(book.title),
                  subtitle: Text(book.author),
                );
              },
            );
          } else {
            return const Skeleton(
              height: 50,
              width: 200,
              radius: 5,
            );
          }
        });
  }
}
