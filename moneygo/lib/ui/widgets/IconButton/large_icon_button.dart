import 'package:flutter/material.dart';

class IconButtonLarge extends StatelessWidget {
  final IconData icon;
  final void Function() onPressed;
  final Color color;

  const IconButtonLarge(
      {super.key,
      required this.icon,
      required this.onPressed,
      this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: 35,
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: color,
        ));
  }
}
