
import 'package:atrons_v1/models/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Stream<List<Book>> getBooks() {
  return FirebaseFirestore.instance
      .collection('Books')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      return Book(
        imageUrl: data['Image'],
        bookid: data['BookId'],
        epubUrl: data['EPub'],
        audioUrl: data['Audio'],
        title: data['Title'],
        author: data['Author'],
        description: data['Description'],
        pages: int.parse(data['Pages']),
        price: data['Price'],
        language: data['Language'],
        ratingsReviews: data['RatingsReviews'],
        purchases: data['Purchases'],
        tags: data['Tags'],
      );
    }).toList();
  });
}
