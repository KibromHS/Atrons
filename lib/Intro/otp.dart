// // ignore_for_file: prefer_const_constructors

// import 'dart:ffi';

// import 'package:atrons_v1/Intro/phoneauth.dart';
// import 'package:atrons_v1/colors.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// import 'package:pinput/pinput.dart';
// import '../home/homepage.dart';

// class Otp extends StatefulWidget {
//   final PhoneNumber phone;
//   const Otp(this.phone, {Key? key}) : super(key: key);

//   @override
//   State<Otp> createState() => _OtpState();
// }

// class _OtpState extends State<Otp> {
//   void login(context) async {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(
//         builder: (_) => HomePage(),
//       ),
//     );
//   }

//   final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
//   late String _verificationCode;
//   String verificationId = "";
//   final TextEditingController _pinPutController = TextEditingController();
//   final FocusNode _pinPutFocusNode = FocusNode();

//   FirebaseAuth _auth = FirebaseAuth.instance;

//   TextEditingController otpController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         alignment: Alignment.center,
//         padding: EdgeInsets.only(
//           left: MediaQuery.of(context).size.width * 0.06,
//           right: MediaQuery.of(context).size.width * 0.06,
//           top: MediaQuery.of(context).size.height * 0.06,
//           bottom: 20,
//         ),
//         child: Column(
//           // ignore: prefer_const_literals_to_create_immutables
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     Navigator.of(context).pushReplacement(
//                         MaterialPageRoute(builder: (_) => SignUp()));
//                   },
//                   icon: Icon(Icons.arrow_back, size: 35),
//                 )
//               ],
//             ),
//             Icon(
//               Icons.phone_android,
//               size: 70,
//               color: Colors.green[800],
//             ),
//             SizedBox(height: 25),
//             Text(
//               'Enter code',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 25),
//             Text(
//               'We\'ve sent an SMS with an activation code',
//               style: TextStyle(
//                 color: Colors.black.withOpacity(0.5),
//                 fontSize: 15,
//               ),
//             ),
//             SizedBox(height: 2),
//             RichText(
//               text: TextSpan(
//                 children: [
//                   TextSpan(
//                     text: 'to your phone ',
//                     style: GoogleFonts.play(
//                       color: Colors.black.withOpacity(0.5),
//                       fontSize: 15,
//                     ),
//                   ),
//                   TextSpan(
//                     text:
//                         '${widget.phone.dialCode} ${widget.phone.phoneNumber}',
//                     style: GoogleFonts.play(
//                       color: Colors.black.withOpacity(0.5),
//                       fontSize: 16.5,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 50),
//             Pinput(
//               length: 6,
//               keyboardType: TextInputType.number,
//               defaultPinTheme: PinTheme(
//                 width: 56,
//                 height: 56,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: MyColors.lightGreen),
//                   borderRadius: BorderRadius.circular(5),
//                   color: Color.fromARGB(255, 224, 223, 223),
//                 ),
//                 textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
//               ),
//               focusedPinTheme: PinTheme(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: MyColors.green),
//                   borderRadius: BorderRadius.circular(5),
//                   color: Color.fromARGB(255, 224, 223, 223),
//                 ),
//                 textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
//               ),
//               submittedPinTheme: PinTheme(
//                 width: 56,
//                 height: 56,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: MyColors.green),
//                   borderRadius: BorderRadius.circular(5),
//                   color: MyColors.whiteGreen,
//                 ),
//                 textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
//               ),
//               errorPinTheme: PinTheme(
//                 width: 56,
//                 height: 56,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.red),
//                   borderRadius: BorderRadius.circular(5),
//                   color: MyColors.whiteGreen,
//                 ),
//                 textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
//               ),
//               closeKeyboardWhenCompleted: true,
//               pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
//               androidSmsAutofillMethod:
//                   AndroidSmsAutofillMethod.smsRetrieverApi,
//               // onCompleted: (pin) => print(pin),
//               // validator: (pin) {
//               //   //   if (pin == '1234') {
//               //   //     login(context);
//               //   //     return null;
//               //   //   }
//               //   //   return 'Entered Pin is Incorrect.';
//               //   verifyOtp();
//               // },
//               onSubmitted: (pin) async {
//                 try {
//                   await FirebaseAuth.instance
//                       .signInWithCredential(PhoneAuthProvider.credential(
//                           verificationId: _verificationCode, smsCode: pin))
//                       .then((value) async {
//                     if (value.user != null) {
//                       Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(builder: (context) => HomePage()),
//                           (route) => false);
//                     }
//                   });
//                 } catch (e) {
//                   FocusScope.of(context).unfocus();
//                   ScaffoldMessenger.of(context)
//                       .showSnackBar(SnackBar(content: Text("invalid OTP")));
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   _verifyPhone() async {
//     await FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: widget.phone.dialCode.toString() +
//             widget.phone.parseNumber().toString(),
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           await FirebaseAuth.instance
//               .signInWithCredential(credential)
//               .then((value) async {
//             if (value.user != null) {
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(builder: (context) => HomePage()),
//                 (route) => false,
//               );
//             }
//           });
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           print(e.message);
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           setState(() {
//             _verificationCode = verificationId;
//           });
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           setState(() {
//             _verificationCode = verificationId;
//           });
//         },
//         timeout: Duration(seconds: 120));
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _verifyPhone();
//   }
// }
