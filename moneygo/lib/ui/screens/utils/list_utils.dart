import 'package:flutter/material.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';

void showSnackBarAddOrUpdate(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: CustomColorScheme.appGreen,
    content: Text(message),
    duration: const Duration(seconds: 2),
  ));
}

void showSnackBarDelete(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: CustomColorScheme.appRed,
    content: Text(message),
    duration: const Duration(seconds: 2),
  ));
}
