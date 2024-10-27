import 'dart:io';

import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    super.key,
    required this.imagePath,
    required this.onClicked,
    this.isEdit = false,
  });

  final String imagePath;
  final VoidCallback onClicked;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    // final color = Theme.of(context).colorScheme.primary;
    Object image;

    if (imagePath.contains('https://')) {
      image = NetworkImage(imagePath);
    } else if (imagePath.contains('assets')) {
      image = AssetImage(imagePath);
    } else {
      image = FileImage(File(imagePath));
    }

    return Center(
      child: Stack(
        children: [
          ClipOval(
            child: Material(
              color: Colors.transparent,
              child: Ink.image(
                image: image as ImageProvider,
                fit: BoxFit.cover,
                width: 128,
                height: 128,
                child: InkWell(
                  onTap: onClicked,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildCircle(
              color: Colors.white,
              all: 3,
              child: buildCircle(
                color: Colors.teal,
                all: 8,
                child: isEdit
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: IconButton(
                          icon: Icon(Icons.add_a_photo, size: 16),
                          padding: const EdgeInsets.all(0),
                          constraints: BoxConstraints(),
                          color: Colors.white,
                          onPressed: onClicked,
                        ),
                    )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Visibility buildCircle({
    required Widget? child,
    required double all,
    required Color color,
  }) {
    return Visibility(
      visible: child != null,
      child: ClipOval(
        child: Container(
          color: color,
          padding: EdgeInsets.all(all),
          child: child,
        ),
      ),
    );
  }
}
