import 'package:flutter/material.dart';

class Appearance extends StatelessWidget {
  const Appearance({Key? key}) : super(key: key);

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
        title: const Row(
          children: [
            Icon(Icons.color_lens),
            SizedBox(width: 6),
            Text('Appearance'),
          ],
        ),
      ),
    );
  }
}
