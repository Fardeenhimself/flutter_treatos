import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final kLightThemeColor = ColorScheme.fromSeed(seedColor: Colors.purpleAccent);
final kDarkThemeColor = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Color.fromARGB(255, 52, 21, 57),
);

// Light Mode
final ThemeData lightTheme = ThemeData(
  colorScheme: kLightThemeColor,
  textTheme: GoogleFonts.poppinsTextTheme(),

  // App Bar
  appBarTheme: AppBarTheme().copyWith(
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 25,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
      color: kLightThemeColor.primary,
    ),
  ),

  scaffoldBackgroundColor: Colors.white,
);

// Dark Mode
final ThemeData darkTheme = ThemeData(
  colorScheme: kDarkThemeColor,
  textTheme: GoogleFonts.poppinsTextTheme(),

  // App Bar
  appBarTheme: AppBarTheme().copyWith(
    titleTextStyle: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 25,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
      color: kLightThemeColor.onPrimary,
    ),
  ),

  scaffoldBackgroundColor: kDarkThemeColor.surface,
);
