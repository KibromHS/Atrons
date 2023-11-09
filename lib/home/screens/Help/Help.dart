import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);

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
            Icon(Icons.help),
            SizedBox(width: 6),
            Text('Help & Support'),
          ],
        ),
      ),
      body: Container(),
    );
  }
}
