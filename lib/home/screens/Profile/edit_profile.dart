import 'dart:io';

import 'package:atrons_v1/home/screens/Profile/profile_widget.dart';
import 'package:atrons_v1/models/user.dart' as u;
import 'package:atrons_v1/utils/user_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:atrons_v1/home/screens/Profile/profile.dart';
// import 'package:page_transition/page_transition.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late u.User user;
  String uidd = '';

  @override
  void initState() {
    super.initState();
    user = UserPreferences.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: BackButton(
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.check_mark_circled),
            iconSize: 32,
            onPressed: () {
              UserPreferences.setUser(user);
              setState(() {});
              Navigator.of(context).pop();
              showMessage(String msg) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(msg),
                    duration: const Duration(seconds: 3),
                  ),
                );
              }

              final userid = FirebaseAuth.instance.currentUser;
              if (userid != null) {
                uidd = userid.uid;
              }
              var collection = FirebaseFirestore.instance.collection('Users');
              collection
                  .doc(uidd)
                  .update({
                    'Full Name': user.name,
                    'Image': user.imagePath,
                  })
                  .then((value) => showMessage("Record Updated"))
                  .catchError((error) => showMessage('update failed: $error'));
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            isEdit: true,
            imagePath: user.imagePath,
            onClicked: () async {
              final image =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              // XFile? imagePath = image;
              if (image == null) return;
              final directory = await getApplicationDocumentsDirectory();
              final name = basename(image.path);
              final imageFile = File('${directory.path}/$name');
              final newImage = await File(image.path).copy(imageFile.path);
              setState(() => user = user.copy(imagePath: newImage.path));
            },
          ),
          const SizedBox(height: 15),
          Column(
            children: [
              Text(user.email, style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              TextFieldWidget(
                label: 'Full Name',
                text: user.name,
                onChanged: (name) async {
                  user = user.copy(name: name);
                },
              ),
            ],
          ),
          
        ],
      ),
    );
  }
}

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget({
    super.key,
    required this.text,
    required this.label,
    required this.onChanged,
  });

  final String text;
  final String label;
  final ValueChanged<String> onChanged;

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          cursorColor: Colors.teal,
          decoration: InputDecoration(
            labelText: 'Full Name',
            floatingLabelStyle: TextStyle(color: Colors.teal),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.teal,
                width: 2,
              )
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.teal
              )
            ),
          ),
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
