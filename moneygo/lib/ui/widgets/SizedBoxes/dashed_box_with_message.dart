import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class DashedWidgetWithMessage extends StatelessWidget {
  final String message;

  const DashedWidgetWithMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DottedBorder(
        color: CustomColorScheme.appGray.withOpacity(0.5),
        strokeWidth: 2,
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        dashPattern: const [5, 5],
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: CustomTextStyleScheme.emptyText,
            ),
          ),
        ),
      ),
    );
  }
}
