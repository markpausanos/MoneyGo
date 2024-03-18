import 'package:flutter/material.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';

class BaseTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final double? height;

  const BaseTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.height,
  }) : super(key: key);

  @override
  State<BaseTextField> createState() => _BaseTextFieldState();
}

class _BaseTextFieldState extends State<BaseTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: CustomColorScheme.backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: widget.controller,
        // Make the textfield size the same as the parent
        expands: widget.height != null ? true : false,
        maxLines: widget.height != null ? null : 1,
        minLines: widget.height != null ? null : 1,

        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: CustomColorScheme.appBlue,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: widget.labelText,
        ),
        onChanged: (text) {
          // Optional: Do something with the text
          print("Text input: $text");
        },
      ),
    );
  }
}
