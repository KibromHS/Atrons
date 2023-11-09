import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  const Notifications({Key? key}) : super(key: key);

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
            Icon(Icons.notifications),
            SizedBox(width: 6),
            Text('Notifications'),
          ],
        ),
      ),
      body: Container(),
    );
  }
}
