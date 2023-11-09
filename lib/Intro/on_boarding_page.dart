
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../colors.dart';
import 'email_signup.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: 'One device, many books',
              body:
                  'making it easy to carry around 100s, even 1000s, of books at once on your mobile device, tablet or e-reader',
              image: buildImage('assets/images/readingbook.png'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Read anytime, anywhere',
              body:
                  'Providing access to multitude of Books making it simpler to read from anywhere',
              image: buildImage("assets/images/ebook.png"),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Search in seconds',
              body:
                  'Easily search for information in an e-book, instead of turning page after page to find what you’re looking for.',
              image: buildImage("assets/images/learn.png"),
              decoration: getPageDecoration(),
              // footer: ElevatedButton(
              //   onPressed: () => goToHome(context),
              //   child: const Text(
              //     'Get Started',
              //     style: TextStyle(fontSize: 20, letterSpacing: 2),
              //   ),
              //   style: ElevatedButton.styleFrom(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //     backgroundColor: Colors.orange[500],
              //     padding:
              //         const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              //   ),
              // ),
            ),
          ],
          showDoneButton: true,
          showSkipButton: true,
          skip: Text(
            'SKIP',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: MyColors.lightGreen),
          ),
          onSkip: () => goToHome(context),
          next: Icon(
            Icons.arrow_forward,
            color: MyColors.lightGreen,
          ),
          // nextFlex: 0,
          // skipOrBackFlex: 0,
          dotsDecorator: getDotDecoration(),
          globalBackgroundColor: MyColors.green,
          animationDuration: 250,
          done: Text(
            'GET STARTED',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: MyColors.lightGreen),
          ),
          onDone: () => goToHome(context),
        ),
      ),
    );
  }
  

  void goToHome(context) => Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (_) => const SignUpEmail()));

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: MyColors.whiteGreen,
        activeColor: MyColors.lightGreen,
        size: const Size(10, 10),
        activeSize: const Size(25, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle:
            const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, letterSpacing: 2),
        bodyTextStyle: const TextStyle(fontSize: 19, letterSpacing: 1),
        bodyPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        imagePadding:
            const EdgeInsets.only(top: 70, left: 25, right: 25, bottom: 25),
        pageColor: MyColors.green,
        footerPadding: const EdgeInsets.only(top: 70, left: 25, right: 25, bottom: 25),
      );
}
