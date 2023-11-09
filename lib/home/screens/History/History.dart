import 'package:flutter/material.dart';

class History extends StatelessWidget {
  const History({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5FCFB),
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: const [
            Icon(Icons.history),
            SizedBox(width: 6),
            Text('History'),
          ],
        ),
      ),
      body: Container(),
    );
  }
}
