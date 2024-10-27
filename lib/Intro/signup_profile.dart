import 'dart:io';

import 'package:atrons_v1/home/components/loading_skeleton.dart';
import 'package:atrons_v1/models/user.dart' as u;
import 'package:atrons_v1/utils/user_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../home/homepage/homepage.dart';
import '../home/screens/Profile/profile_widget.dart';

class SignupProfile extends StatefulWidget {
  const SignupProfile({super.key});

  @override
  State<SignupProfile> createState() => _SignupProfileState();
}

class _SignupProfileState extends State<SignupProfile> {
  late u.User localUser;

  @override
  void initState() {
    super.initState();
    localUser = UserPreferences.getUser();
  }

  final FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
  final String collectionName = 'Users';
  final String collectionUserImage = 'UserImage';
  final FirebaseStorage storageRef = FirebaseStorage.instance;
  String uidd = '';
  String uemail = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (!isLoading)
            IconButton(
              icon: const Icon(CupertinoIcons.check_mark_circled),
              color: Colors.black,
              iconSize: 32,
              onPressed: () => _uploadUserData(context),
            ),
        ],
      ),
      body: isLoading
          ? const LoadingSkeleton()
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              physics: const BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                  isEdit: true,
                  imagePath: localUser.imagePath,
                  onClicked: () => _pickImage(context),
                ),
                const SizedBox(height: 32),
                TextFieldWidget(
                  label: 'Full Name',
                  text: localUser.name,
                  onChanged: (name) {
                    localUser = localUser.copy(name: name);
                  },
                ),
                const SizedBox(height: 24),
                _buildGenderSelection(),
              ],
            ),
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      children: [
        const Text('Male'),
        const SizedBox(width: 6),
        Radio(
          value: 'M',
          groupValue: localUser.gender,
          activeColor: Colors.teal,
          onChanged: (value) {
            setState(() {
              localUser = localUser.copy(gender: value.toString());
            });
          },
        ),
        const SizedBox(width: 15),
        const Text('Female'),
        const SizedBox(width: 6),
        Radio(
          value: 'F',
          groupValue: localUser.gender,
          activeColor: Colors.teal,
          onChanged: (value) {
            setState(() {
              localUser = localUser.copy(gender: value.toString());
            });
          },
        ),
      ],
    );
  }

  Future<void> _uploadUserData(BuildContext context) async {
    final userid = FirebaseAuth.instance.currentUser;
    if (userid != null) {
      uidd = userid.uid;
      uemail = userid.email!;
    }

    if (localUser.imagePath.isEmpty || localUser.imagePath.contains('assets')) {
      _showMessage("Please select an image before proceeding.", context);
      return;
    }

    setState(() {
      isLoading = true;
    });

    String uploadFileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference reference = storageRef
        .ref()
        .child(collectionUserImage)
        .child(uploadFileName);

    UploadTask uploadTask = reference.putFile(File(localUser.imagePath));
    await uploadTask.whenComplete(() async {
      final uploadPath = await uploadTask.snapshot.ref.getDownloadURL();
      if (uploadPath.isNotEmpty) {
        await firestoreRef.collection(collectionName).doc(uidd).set({
          'UserID': uidd,
          'Full Name': localUser.name,
          'Email': uemail,
          'Gender': localUser.gender,
          'Image': uploadPath,
          'bookmark': FieldValue.arrayUnion([]),
          'mybooks': FieldValue.arrayUnion([]),
          'myaudios': FieldValue.arrayUnion([]),
          'searches': FieldValue.arrayUnion([]),
          'currentBook': '',
        });
        _showMessage("Successfully signed up", context);
        u.User newLocalUser = u.User(
          userID: uidd,
          name: localUser.name,
          email: uemail,
          isDarkMode: false,
          gender: localUser.gender,
          imagePath: uploadPath,
          bookmarks: [],
          mybooks: [],
          searches: [],
          myaudiobooks: [],
          currentBook: '',
        );
        await UserPreferences.setUser(newLocalUser);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        _showMessage("Something went wrong while uploading", context);
      }
    });
  }

  Future<void> _pickImage(BuildContext context) async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(image.path);
    final imageFile = File('${directory.path}/$name');
    await File(image.path).copy(imageFile.path);

    setState(() {
      localUser = localUser.copy(imagePath: imageFile.path);
    });
  }

  void _showMessage(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 3),
    ));
  }
}

class TextFieldWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.teal,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelStyle: const TextStyle(color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal, width: 2),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
