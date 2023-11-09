import 'package:atrons_v1/home/components/loading_skeleton.dart';
import 'package:atrons_v1/services/auth.dart';
import 'package:flutter/material.dart';
import '../colors.dart';
import '../home/homepage/homepage.dart';
import 'email_signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:atrons_v1/models/user.dart' as u;
import 'package:atrons_v1/utils/user_preferences.dart';

class SignInEmail extends StatefulWidget {
  const SignInEmail({Key? key}) : super(key: key);

  @override
  State<SignInEmail> createState() => _SignInEmailState();
}

class _SignInEmailState extends State<SignInEmail> {
  final navigatorKey = GlobalKey<NavigatorState>();
  AuthService auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String error = '';
  String uidd = '';

  // late final u.User user;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return loading
        ? const LoadingSkeleton()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              color: MyColors.green,
              child: Column(children: [
                Container(
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
                                children: [
                                  const Text(
                                    'Log In',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text('Welcome Back to Atrons',
                                      style: TextStyle(fontSize: 17)),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 20),
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
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Forgot Password?',
                                              style:
                                                  TextStyle(color: Colors.teal),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.teal,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 5),
                                          ),
                                          child: const Text(
                                            'Log In',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              // setState(() => loading = true);

                                              final user = await auth
                                                  .signInWithEmailAndPassword(
                                                      email.text,
                                                      password.text);

                                              if (user == null) {
                                                setState(() {
                                                  error =
                                                      'Could not sign in with those credentials';
                                                  loading = false;
                                                });
                                              } else {
                                                try {
                                                  // final user = await FirebaseAuth
                                                  //     .instance
                                                  //     .signInWithEmailAndPassword(
                                                  //         email: email.text,
                                                  //         password:
                                                  //             password.text);
                                                } on FirebaseAuthException catch (e) {
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                  if (e.code ==
                                                      'user-not-found') {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                      content: Text(
                                                          'No User found with That Email'),
                                                      duration:
                                                          Duration(seconds: 6),
                                                      backgroundColor:
                                                          Color.fromARGB(
                                                              255, 199, 9, 9),
                                                      // action: SnackBarAction(
                                                      //   label: 'Dismiss',
                                                      //   onPressed: () {},
                                                      //   textColor: Colors.white,
                                                      // ),
                                                    ));
                                                  } else if (e.code ==
                                                      'wrong-password') {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                      content: Text(
                                                          'Wrong Password provided for that User.'),
                                                      duration:
                                                          Duration(seconds: 6),
                                                      backgroundColor:
                                                          Color.fromARGB(
                                                              255, 199, 9, 9),
                                                    ));
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                      content: Text(
                                                          'Login Successful'),
                                                      duration:
                                                          Duration(seconds: 6),
                                                      backgroundColor:
                                                          Colors.teal,
                                                    ));
                                                  }
                                                }
                                                u.User? localUser;
                                                uidd = user.uid;
                                                final docRef = FirebaseFirestore
                                                    .instance
                                                    .collection("Users")
                                                    .doc(uidd);

                                                await docRef.get().then(
                                                  (DocumentSnapshot doc) async {
                                                    final data = doc.data()
                                                        as Map<String,
                                                            dynamic>?;
                                                    localUser = u.User(
                                                      userID: uidd,
                                                      name: data!['Full Name'],
                                                      // bookmarkid: data['bookid'],
                                                      email: data['Email'],
                                                      isDarkMode: false,
                                                      gender: data['Gender'],
                                                      imagePath: data['Image']
                                                          .toString(),
                                                      bookmarks:
                                                          data['bookmark'],
                                                      mybooks: data['mybooks'],
                                                      searches:
                                                          data['searches'],
                                                      myaudiobooks:
                                                          data['myaudios'],
                                                      currentBook: '',
                                                    );
                                                    await UserPreferences
                                                        .setUser(localUser!);
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            const HomePage(),
                                                      ),
                                                    );
                                                  },
                                                  onError: (e) => print(
                                                      "Error Getting Document:$e"),
                                                );
                                                await UserPreferences.setUser(
                                                    localUser!);
                                                setState(() {
                                                  loading = false;
                                                });

                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        const HomePage(),
                                                  ),
                                                );
                                              }
                                              setState(() {
                                                loading = false;
                                              });
                                              // Navigator.of(context)
                                              //     .pushReplacement(
                                              //   MaterialPageRoute(
                                              //     builder: (_) =>
                                              //         HomePage(user: user),
                                              //   ),

                                              // );
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
                                  const SizedBox(height: 30),
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
                                      // TODO: Login with Google
                                      final g = await auth.signinWithG();
                                      u.User localUser;
                                      if (g.user == null) {
                                        error = 'No user found!';
                                        return;
                                      }
                                      uidd = g.user!.uid;
                                      final docRef = FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc(uidd);

                                      await docRef
                                          .get()
                                          .then((DocumentSnapshot doc) async {
                                        final data =
                                            doc.data() as Map<String, dynamic>?;
                                        localUser = u.User(
                                          userID: uidd,
                                          name: data!['Full Name'],
                                          email: data['Email'],
                                          isDarkMode: false,
                                          gender: data['Gender'],
                                          imagePath: data['Image'].toString(),
                                          bookmarks: data['bookmark'],
                                          mybooks: data['mybooks'],
                                          myaudiobooks: data['myaudios'],
                                          searches: data['searches'],
                                          currentBook: '',
                                        );
                                        await UserPreferences.setUser(
                                            localUser);
                                      });
                                    },
                                    icon: Image.asset(
                                      'assets/images/google.png',
                                      height: 30,
                                      width: 30,
                                      fit: BoxFit.contain,
                                    ),
                                    label: const Text('Continue with Google'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.black87,
                                      shape: const StadiumBorder(),
                                      side: const BorderSide(
                                        width: 2,
                                        color: Colors.black12,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 60),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      // TODO: Login with apple
                                    },
                                    icon: Image.asset(
                                      'assets/images/apple.png',
                                      height: 30,
                                      width: 30,
                                      fit: BoxFit.contain,
                                    ),
                                    label: const Text('Continue with Apple'),
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
                                            builder: (_) => const SignUpEmail(),
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
                                                text:
                                                    'Don\'t have an account? ',
                                              ),
                                              TextSpan(
                                                text: 'Sign Up',
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
