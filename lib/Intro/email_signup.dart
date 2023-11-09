import 'package:atrons_v1/Intro/email_signin.dart';
import 'package:atrons_v1/Intro/signup_profile.dart';
import 'package:atrons_v1/home/components/loading_skeleton.dart';
// import 'package:atrons_v1/home/homepage/homepage.dart';
import 'package:atrons_v1/services/auth.dart';
import 'package:atrons_v1/utils/user_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../colors.dart';
// import 'package:get/get.dart';
import 'package:atrons_v1/models/user.dart' as u;

// import './otp.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:country_code_picker/country_code_picker.dart';

class SignUpEmail extends StatefulWidget {
  const SignUpEmail({Key? key}) : super(key: key);

  @override
  State<SignUpEmail> createState() => _SignUpEmailState();
}

class _SignUpEmailState extends State<SignUpEmail> {
  bool isPhoneValid = false;
  late u.User localUser;
  AuthService auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String error = '';

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirm = TextEditingController();

  TextEditingController otpController = TextEditingController();

  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
  String collectionName = 'Users';
  String collectionUserImage = 'UserImage';
  FirebaseStorage storageRef = FirebaseStorage.instance;

  String uidd = '';
  String uemail = '';
  bool otpVisibility = false;
  bool phoneVisible = true;
  String verificationID = "";

  // final GetXHelper getXHelper = Get.put(GetXHelper());
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingSkeleton()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              color: MyColors.green,
              child: Column(children: [
                Container(
                  // padding: const EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    'assets/images/Atrons.png',
                    width: 110,
                    height: 100,
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.fill,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 30, left: 30, right: 30, bottom: 10),
                    decoration: BoxDecoration(
                      color: MyColors.whiteGreenmod,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Center(
                      child: LayoutBuilder(builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: IntrinsicHeight(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text('Welcome to Atrons',
                                      style: TextStyle(fontSize: 17)),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: email,
                                          cursorColor: Colors.black45,
                                          decoration: const InputDecoration(
                                            focusColor: Colors.teal,
                                            hintText: 'Email',
                                            prefixIcon: Icon(Icons.email,
                                                color: Colors.teal),
                                            fillColor: Colors.white,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.teal, width: 1),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.teal, width: 2),
                                            ),
                                          ),
                                          validator: (value) => value!.isEmpty
                                              ? 'Enter email'
                                              : null,
                                        ),
                                        const SizedBox(height: 10),
                                        TextFormField(
                                          controller: password,
                                          cursorColor: Colors.black45,
                                          decoration: const InputDecoration(
                                            focusColor: Colors.teal,
                                            hintText: 'Password',
                                            prefixIcon: Icon(Icons.lock,
                                                color: Colors.teal),
                                            fillColor: Colors.white,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.teal, width: 1),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.teal, width: 2),
                                            ),
                                          ),
                                          obscureText: true,
                                          validator: (value) => value!.length <
                                                  6
                                              ? 'Password must be 6+ chars long'
                                              : null,
                                        ),
                                        const SizedBox(height: 10),
                                        TextFormField(
                                          controller: confirm,
                                          cursorColor: Colors.black45,
                                          decoration: const InputDecoration(
                                            focusColor: Colors.teal,
                                            hintText: 'Confirm Password',
                                            prefixIcon: Icon(Icons.lock,
                                                color: Colors.teal),
                                            fillColor: Colors.white,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.teal, width: 1),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.teal, width: 2),
                                            ),
                                          ),
                                          obscureText: true,
                                          validator: (value) {
                                            return value != password.text
                                                ? 'Password doesn\'t match'
                                                : null;
                                          },
                                        ),
                                        const SizedBox(height: 30),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.teal,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 5),
                                          ),
                                          child: const Text(
                                            'Sign Up',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              // setState(() {
                                              //   loading = true;
                                              // });
                                              final result = await auth
                                                  .registerWithEmailAndPassword(
                                                      email.text,
                                                      password.text);
                                              if (result == null) {
                                                setState(() {
                                                  error =
                                                      'Some problem occured. Couldn\'t sign up';
                                                  loading = false;
                                                });
                                              } else {
                                                setState(() {
                                                  error = '';
                                                  loading = false;
                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(
                                                  //     builder: (_) =>
                                                  //         const SignupProfile(),
                                                  //   ),
                                                  // );
                                                });
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        SignupProfile(),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          error,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  const Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Divider(color: Colors.black54),
                                        ),
                                        SizedBox(width: 6),
                                        Text('OR',
                                            style: TextStyle(fontSize: 16)),
                                        SizedBox(width: 6),
                                        Expanded(
                                          child: Divider(color: Colors.black54),
                                        ),
                                      ]),
                                  const SizedBox(height: 25),
                                  OutlinedButton.icon(
                                    onPressed: () async {
                                      // TODO: Sign up with Google
                                      final gUser =
                                          FirebaseAuth.instance.currentUser!;
                                      u.User localUser =
                                          UserPreferences.getUser();
                                      u.User newUser = localUser.copy(
                                        name: gUser.displayName,
                                        email: gUser.email,
                                        imagePath: gUser.photoURL,
                                      );
                                      await UserPreferences.setUser(newUser);

                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (_) => const SignupProfile(),
                                        ),
                                      );
                                    },
                                    icon: Image.asset(
                                      'assets/images/google.png',
                                      height: 30,
                                      width: 30,
                                      fit: BoxFit.contain,
                                    ),
                                    label: const Text('Sign Up with Google'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.black87,
                                      shape: StadiumBorder(),
                                      side: BorderSide(
                                        width: 2,
                                        color: Colors.black12,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 60),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: Image.asset(
                                      'assets/images/apple.png',
                                      height: 30,
                                      width: 30,
                                      fit: BoxFit.contain,
                                    ),
                                    label: const Text('Sign Up with Apple'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.black87,
                                      shape: StadiumBorder(),
                                      side: BorderSide(
                                        width: 2,
                                        color: Colors.black12,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 60),
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  Material(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (_) => const SignInEmail(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 40,
                                        alignment: Alignment.center,
                                        child: RichText(
                                          text: const TextSpan(
                                            style:
                                                TextStyle(color: Colors.teal),
                                            children: [
                                              TextSpan(
                                                text: 'Have an account? ',
                                              ),
                                              TextSpan(
                                                text: 'Log In',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ]),
            ),
          );
  }
}
