import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';

class CustomTextStyleScheme {
  static const TextStyle appBarTitleHome = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static const TextStyle appBarTitleCategories = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle navigationButtonsNotPressed = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: CustomColorScheme.appGray,
  );
  static const TextStyle navigationButtonsPressed = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle remainingBalanceText = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static TextStyle pesoSign = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    fontFamily: GoogleFonts.roboto().fontFamily,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: CustomColorScheme.appGray,
  );

  static const TextStyle progressBarLabel =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black);
  static const TextStyle progressBarBalance =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black);
  static TextStyle progressBarBalancePeso = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.black,
      fontFamily: GoogleFonts.roboto().fontFamily);
  static const TextStyle progressBarText = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: CustomColorScheme.appGray);

  static const TextStyle dialogTitle = appBarTitleCategories;
  static const TextStyle dialogBody = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
}
