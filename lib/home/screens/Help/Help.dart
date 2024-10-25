import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FCFB),
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Row(
          children: [
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
