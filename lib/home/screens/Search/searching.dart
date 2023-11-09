import 'package:atrons_v1/home/screens/Search/search_result.dart';
import 'package:atrons_v1/utils/user_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Searching extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Theme.of(context).hintColor,
      ),
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      // color: Colors.grey[800],
      onPressed: () => close(context, null),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        // color: Colors.grey[800],
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) => SearchResult(query: query);

  @override
  Widget buildSuggestions(BuildContext context) {
    final localUser = UserPreferences.getUser();

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(localUser.userID)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final DocumentSnapshot doc = snapshot.data!;
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data['searches'].length == 0) {
          return const Center(
            child: Text('Search and Find the books you want'),
          );
        }

        final mysearches =
            (data['searches'] as List).map((search) => search).toList();
        final suggestions = mysearches.where((search) {
          return search.toLowerCase().contains(query.toLowerCase());
        }).toList();

        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final suggestion = suggestions[index];

            return ListTile(
              leading: const Icon(Icons.history, size: 18),
              title: Text(suggestion, style: const TextStyle(fontSize: 16)),
              onTap: () {
                query = suggestion;
                showResults(context);
              },
              trailing: IconButton(
                icon: const Icon(Icons.close),
                iconSize: 15,
                onPressed: () {
                  localUser.removeSearched(suggestion);
                },
              ),
            );
          },
        );
      },
    );
  }
}
