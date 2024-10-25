import 'dart:io';

import 'package:atrons_v1/home/components/loading_skeleton.dart';
import 'package:atrons_v1/models/user.dart' as u;
import 'package:atrons_v1/utils/user_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:get/state_manager.dart';
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

  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
  String collectionName = 'Users';
  String collectionUserImage = 'UserImage';
  FirebaseStorage storageRef = FirebaseStorage.instance;
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
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.check_mark_circled),
            color: Colors.black,
            iconSize: 32,
            onPressed: () async {
              final userid = FirebaseAuth.instance.currentUser;
              if (userid != null) {
                uidd = userid.uid;
                uemail = userid.email!;
              }
              setState(() {
                isLoading = true;
              });
              // var uniqueKey =
              //     firestoreRef.collection(collectionUserImage).doc();
              String uploadFileName =
                  '${DateTime.now().millisecondsSinceEpoch}.jpg';
              Reference reference = storageRef
                  .ref()
                  .child(collectionUserImage)
                  .child(uploadFileName);
              UploadTask uploadTask =
                  reference.putFile(File(localUser.imagePath));
              uploadTask.snapshotEvents.listen((event) {
              });
              await uploadTask.whenComplete(() async {
                var uploadPath = await uploadTask.snapshot.ref.getDownloadURL();

                showMessage(String msg) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(msg),
                    duration: const Duration(seconds: 3),
                  ));
                }


                if (uploadPath.isNotEmpty) {
                  firestoreRef.collection(collectionName).doc(uidd).set({
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
                  }).then((value) => showMessage("Record Inserted."));
                } else {
                  showMessage("Something went wrong while uploading");
                }

                localUser = u.User(
                  userID: uidd,
                  name: localUser.name,
                  email: uemail,
                  gender: localUser.gender,
                  imagePath: uploadPath,
                  bookmarks: [],
                  mybooks: [],
                  myaudiobooks: [],
                  currentBook: '',
                  isDarkMode: false,
                );
              });

              await UserPreferences.setUser(localUser);

              //  print(localUser.email);
//email couldn't be set for local user
              // FirebaseFirestore.instance
              //     .collection("Users")
              //     .doc(uidd)
              //     .collection("Email")
              //     .get()
              //     .then((value) => localUser.email);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const HomePage(),
                ),
              );
            },
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
                  onClicked: () async {
                    final XFile? image = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (image == null) return;
                    final directory = await getApplicationDocumentsDirectory();
                    final name = basename(image.path);
                    final imageFile = File('${directory.path}/$name');
                    final newImage =
                        await File(image.path).copy(imageFile.path);
                    setState(() =>
                        localUser = localUser.copy(imagePath: newImage.path));
                  },
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
                Row(children: [
                  const Text('Male'),
                  const SizedBox(width: 6),
                  Radio(
                    value: 'M',
                    groupValue: localUser.gender,
                    onChanged: (gender) {
                      setState(() {
                        gender = gender.toString();
                      });
                      localUser = localUser.copy(gender: gender.toString());
                    },
                  ),
                  const SizedBox(width: 15),
                  const Text('Female'),
                  const SizedBox(width: 6),
                  Radio(
                    value: 'F',
                    groupValue: localUser.gender,
                    onChanged: (gender) {
                      setState(() {
                        gender = gender.toString();
                      });
                      localUser = localUser.copy(gender: gender.toString());
                    },
                  ),
                ]),
              ],
            ),
    );
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            // hintText: " ",
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
