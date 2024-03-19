import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final BorderSide? border;

  const DialogButton({
    required this.onPressed,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor = Colors.transparent,
    this.border,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        side: border ?? BorderSide(color: borderColor, width: 0.5),
      ),
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: textColor)),
    );
  }
}
