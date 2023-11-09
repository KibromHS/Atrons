// // ignore_for_file: prefer_const_constructors

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// import '../colors.dart';
// import './otp.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({Key? key}) : super(key: key);

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   late PhoneNumber phone;
//   bool isPhoneValid = false;

//   TextEditingController _Controller = TextEditingController();
//   TextEditingController otpController = TextEditingController();

//   bool otpVisibility = false;
//   String verificationID = "";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Container(
//           alignment: Alignment.center,
//           padding: EdgeInsets.only(
//             left: MediaQuery.of(context).size.width * 0.06,
//             right: MediaQuery.of(context).size.width * 0.06,
//             top: MediaQuery.of(context).size.height * 0.2,
//             bottom: 20,
//           ),
//           child: Column(
//             children: [
//               Text(
//                 'Your Phone Number',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 15),
//               Text(
//                 'Please select your country code and',
//                 style: TextStyle(
//                     color: Colors.black.withOpacity(0.5), fontSize: 15),
//               ),
//               SizedBox(height: 2),
//               Text(
//                 'enter your phone number',
//                 style: TextStyle(
//                     color: Colors.black.withOpacity(0.5), fontSize: 15),
//               ),
//               SizedBox(height: 60),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border: Border.all(
//                     color: Colors.green.withOpacity(0.13),
//                     width: 5,
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Stack(
//                   children: [
//                     InternationalPhoneNumberInput(
//                       onInputChanged: (value) {
//                         phone = PhoneNumber(
//                           dialCode: value.dialCode,
//                           phoneNumber: value.parseNumber(),
//                           isoCode: value.isoCode,
//                         );
//                       },
//                       cursorColor: Colors.black,
//                       maxLength: 13,
//                       selectorConfig: SelectorConfig(
//                         selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
//                         useEmoji: true,
//                       ),
//                       formatInput: true,
//                       ignoreBlank: false,
//                       // initialValue: PhoneNumber(isoCode: 'ET'),
//                       autoValidateMode: AutovalidateMode.onUserInteraction,
//                       onInputValidated: (isValid) {
//                         isPhoneValid = isValid;
//                       },
//                       inputDecoration: InputDecoration(
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.only(bottom: 15, left: 0),
//                         hintText: 'Phone Number',
//                         hintStyle: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey.shade500,
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       top: 8,
//                       left: 90,
//                       bottom: 8,
//                       child: Container(
//                         width: 1,
//                         height: 30,
//                         color: Colors.black.withOpacity(0.13),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.arrow_forward, color: MyColors.whiteGreen),
//         backgroundColor: MyColors.green,
//         onPressed: () async {
//           if (isPhoneValid) {
//             Navigator.of(context)
//                 .push(MaterialPageRoute(builder: (context) => Otp(phone)));
//           }
//         },
//       ),
//     );
//   }
// }
