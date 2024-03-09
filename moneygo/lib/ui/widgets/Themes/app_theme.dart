import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: Color.fromRGBO(89, 156, 255, 1),
      secondary: Color.fromRGBO(255, 89, 89, 1),
    ),
    scaffoldBackgroundColor: const Color.fromRGBO(241, 241, 241, 1),
    fontFamily: GoogleFonts.lato().fontFamily,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    cardColor: const Color.fromRGBO(254, 254, 254, 1),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      titleSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      labelSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ));
