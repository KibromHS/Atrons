import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:atrons_v1/home/components/loading_skeleton.dart';
import 'package:atrons_v1/home/homepage/homepage.dart';
import 'package:atrons_v1/services/auth.dart';
import 'package:atrons_v1/themes.dart';
import 'package:atrons_v1/utils/user_preferences.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'Intro/on_boarding_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:just_audio_background/just_audio_background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await UserPreferences.init();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio Playback',
    androidNotificationOngoing: true,
  );
  await dotenv.load();
  runApp(const Atrons());
}

class Atrons extends StatelessWidget {
  const Atrons({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.getUser();
    final myTheme = user.isDarkMode ? MyThemes.darkTheme : MyThemes.lightTheme;

    return ThemeProvider(
      initTheme: myTheme,
      builder: (context, myTheme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: myTheme,
          home: StreamBuilder<User?>(
            stream: AuthService().user,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return HomePage(user: snapshot.data);
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingSkeleton();
              } else {
                return const OnBoardingPage();
              }
            },
          ),
        );
      },
    );
  }
}
