import 'package:atrons_v1/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyThemes {
  static final darkTheme = ThemeData(
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFF1D2733),
    ),
    hintColor: Colors.grey[300],
    colorScheme: const ColorScheme.dark(
      onPrimary: Color(0xFFDEDFDF),
      primary: Color(0xFF1D2733),
      secondary: Color(0xFF5EA3DE),
      onSecondary: Color(0xFFFEFFFF),
      background: Color(0xFF1D2733),
      surface: Color(0xFF233040),
      onSurface: Color(0xFFDEDFDF),
    ),
    // textTheme:
    textTheme: GoogleFonts.robotoTextTheme(
      const TextTheme(
        bodyLarge: TextStyle(),
        bodyMedium: TextStyle(),
      ).apply(
        displayColor: Colors.white70,
      ),
    ),
  );

  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      onPrimary: Colors.teal,
      primary: MyColors.whiteGreenmod,
      secondary: Colors.teal,
      onSecondary: const Color(0xFFFEFFFF),
      background: const Color(0xFFF5FCFB),
      // Color(0xFFF5FCFB), // color that was used on profile page
    ),
    textTheme: GoogleFonts.robotoTextTheme(),
  );
}
