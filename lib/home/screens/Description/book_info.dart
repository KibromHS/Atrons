import 'package:atrons_v1/home/components/download_alert.dart';
import 'package:atrons_v1/utils/user_preferences.dart';
import 'package:atrons_v1/home/screens/Description/purchased.dart';
import 'package:flutter/material.dart';
import './book_desc.dart';

class BookInfoBig extends StatelessWidget {
  const BookInfoBig({super.key, required this.widget});

  final BookDesc widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Hero(
              tag: widget.tag,
              child: Image.network(
                widget.book.imageUrl,
                width: 110,
                height: 140,
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text(
                    'Purchases',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${widget.book.purchases}',
                    style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  const Text(
                    'Pages',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${widget.book.pages}',
                    style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  const Text(
                    'Language',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.book.language ?? 'Unknown',
                    style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BookInfoSmall extends StatefulWidget {
  const BookInfoSmall({
    super.key,
    required this.top,
    required this.price,
    required this.descWidget,
  });

  final double top;
  final BookDesc descWidget;
  final String price;

  @override
  State<BookInfoSmall> createState() => _BookInfoSmallState();
}

class _BookInfoSmallState extends State<BookInfoSmall> {
  bool downloading = false;
  final localUser = UserPreferences.getUser();
  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: widget.top <= 260 ? 1.0 : 0.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.descWidget.book.imageUrl,
                width: 65,
                height: 80,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Purchases',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.descWidget.book.purchases}',
                          style: const TextStyle(
                            // color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        const Text(
                          'Pages',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.descWidget.book.pages}',
                          style: const TextStyle(
                            // color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        const Text(
                          'Language',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.descWidget.book.language ?? 'Unknown',
                          style: const TextStyle(
                            // color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(child: Container()),
                SizedBox(
                  height: 30,
                  child: localUser.mybooks.contains(widget.descWidget.book.bookid)
                      ? FloatingActionButton.extended(
                          // backgroundColor: MyColors.lightGreenmod,
                          shape: const StadiumBorder(),
                          label: const Row(
                            children: [
                              Icon(Icons.file_open),
                              SizedBox(width: 10),
                              Text('Open'),
                            ],
                          ),
                          onPressed: () async {
                            setState(() {
                              downloading = true;
                            });
                            await Purchased.openAtronsBook(widget.descWidget.book.title, widget.descWidget.book.bookid);
                            setState(() {
                              downloading = false;
                            });
                          },
                        )
                      : FloatingActionButton.extended(
                          // backgroundColor: MyColors.lightGreenmod,
                          shape: const StadiumBorder(),
                          label: downloading
                              ? const SizedBox(
                                  width: 25,
                                  height: 25,
                                  child:
                                     CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Row(
                                  children: [
                                    const Icon(Icons.sell_outlined),
                                    const SizedBox(width: 10),
                                    Text(
                                      widget.price,
                                      style: const TextStyle(color: Colors.teal),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text('Purchase'),
                                  ],
                                ),
                          onPressed: downloading
                              ? null
                              : () async {
                                  setState(() {
                                    downloading = true;
                                  });
                                  await DownloadAlert.show(context: context, book: widget.descWidget.book);

                                  setState(() {
                                    downloading = false;
                                  });
                                },
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
