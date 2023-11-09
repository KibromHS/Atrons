import 'dart:io';

import 'package:atrons_v1/models/book.dart';
import 'package:atrons_v1/utils/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookReview extends StatefulWidget {
  const BookReview(
      {Key? key, required this.book, this.rating = 0, this.review, this.isEdit})
      : super(key: key);

  final Book book;
  final double rating;
  final String? review;
  final bool? isEdit;

  @override
  State<BookReview> createState() => _BookReviewState();
}

class _BookReviewState extends State<BookReview> {
  TextEditingController reviewController = TextEditingController();
  late bool isDisabled;
  double inputHeight = 50;
  num myRating = 0;
  final localUser = UserPreferences.getUser();
  bool userExists = false;
  double? ratingBefore;
  String? reviewBefore;

  void _checkInputHeight() async {
    int count = reviewController.text.split('\n').length;

    if (count == 0 && inputHeight == 50) {
      return;
    }
    if (count <= 5) {
      double newHeight = count == 0 ? 50 : 28 + (count * 18);
      setState(() {
        inputHeight = newHeight;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    reviewController.addListener(_checkInputHeight);
    isDisabled = widget.rating == 0 ? true : false;
    if (widget.review != null) reviewController.text = widget.review!;
    myRating = widget.rating;
    if (widget.isEdit != null) {
      ratingBefore = widget.rating;
      reviewBefore = widget.review;
    }
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider image;

    if (localUser.imagePath.contains('https://')) {
      image = NetworkImage(localUser.imagePath);
    } else if (localUser.imagePath.contains('assets')) {
      image = AssetImage(localUser.imagePath);
    } else {
      image = FileImage(File(localUser.imagePath));
    }

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: MyColors.whiteGreenmod,
        elevation: 2,
        leading: IconButton(
          color: Colors.grey[700],
          iconSize: 25,
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image.network(
                widget.book.imageUrl,
                fit: BoxFit.fill,
                height: 40,
                width: 40,
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.book.title.length < 16
                      ? widget.book.title
                      : '${widget.book.title.substring(0, 14)}...',
                  style: TextStyle(
                      color: localUser.isDarkMode
                          ? Colors.white60
                          : Colors.black87,
                      fontSize: 16),
                ),
                Text('Rate this book',
                    style: TextStyle(color: Colors.grey[700], fontSize: 14)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'POST',
              style: TextStyle(
                fontSize: 16,
                // color: localUser.isDarkMode ? Colors.white70 : Colors.teal,
                color: isDisabled ? Colors.grey : Colors.teal,
              ),
            ),
            onPressed: isDisabled
                ? null
                : () {
                    if (widget.isEdit != null) {
                      widget.book.deleteRating({
                        'userid': localUser.userID,
                        'rating': ratingBefore,
                        'review': reviewBefore
                      });

                      widget.book.setRating({
                        'userid': localUser.userID,
                        'rating': myRating,
                        'review': reviewController.text
                      });

                      Navigator.of(context).pop();
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Your review is editted successfully'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.teal,
                      ));
                    } else {
                      widget.book.setRating({
                        'userid': localUser.userID,
                        'rating': myRating,
                        'review': reviewController.text
                      });
                      Navigator.of(context).pop();
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Thanks for your feedback'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.teal,
                      ));
                    }
                  },
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          // color: MyColors.whiteGreenmod,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: image,
                      radius: 25,
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localUser.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Reviews are public',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              RatingBar(
                initialRating: widget.rating,
                minRating: 1,
                tapOnlyMode: true,
                glow: false,
                itemSize: 30,
                itemPadding: const EdgeInsets.symmetric(horizontal: 15),
                ratingWidget: RatingWidget(
                  full: const Icon(Icons.star_rate, color: Colors.teal),
                  half: const Icon(Icons.star_half_sharp),
                  empty:
                      const Icon(Icons.star_rate_outlined, color: Colors.grey),
                ),
                onRatingUpdate: (num value) {
                  setState(() {
                    myRating = value;
                    isDisabled = false;
                  });
                },
              ),
              const SizedBox(height: 50),
              TextField(
                controller: reviewController,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Your review on this book (optional)',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 1),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
