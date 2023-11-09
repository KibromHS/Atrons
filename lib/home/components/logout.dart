import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:atrons_v1/Intro/on_boarding_page.dart';
import 'package:atrons_v1/services/auth.dart';
import 'package:atrons_v1/themes.dart';
import 'package:atrons_v1/utils/user_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
// import 'package:flutter_settings_screens/flutter_settings_screens.dart';

Future<void> _logout(BuildContext context) async {
  await AuthService().signOut();
  await UserPreferences.signOut();
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (_) => OnBoardingPage(),
    ),
  );
}

class LogoutDialog {
  static Future<AlertDialog> show(
    BuildContext context, {
    required String title,
    required String body,
  }) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(title),
            content: Text(body),
            actions: [
              TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: UserPreferences.getUser().isDarkMode
                        ? Colors.white54
                        : Colors.black54,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ThemeSwitcher(
                builder: (context) {
                  return TextButton(
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                          fontSize: 18),
                    ),
                    onPressed: () async {
                      final localUser = UserPreferences.getUser();
                      final switcher = ThemeSwitcher.of(context);
                      switcher.changeTheme(theme: MyThemes.lightTheme);

                      final newUser = localUser.copy(isDarkMode: false);
                      UserPreferences.setUser(newUser);
                      await _logout(context);
                    },
                  );
                },
              ),
            ],
          );
        });
  }
}
