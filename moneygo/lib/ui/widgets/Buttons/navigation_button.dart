import 'package:flutter/material.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class NavigationButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onPressed;

  const NavigationButton({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          isSelected
              ? CustomColorScheme.buttonSelected
              : Theme.of(context).scaffoldBackgroundColor,
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        elevation: MaterialStateProperty.all(0),
      ),
      child: Text(
        title,
        style: isSelected
            ? CustomTextStyleScheme.navigationButtonsPressed
            : CustomTextStyleScheme.navigationButtonsNotPressed,
      ),
    );
  }
}
