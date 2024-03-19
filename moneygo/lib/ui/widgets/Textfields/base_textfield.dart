import 'package:flutter/material.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';

class BaseTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final int? maxLines;
  final String? Function(String?)? validator;

  const BaseTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.maxLines = 1,
  });

  @override
  State<BaseTextField> createState() => _BaseTextFieldState();
}

class _BaseTextFieldState extends State<BaseTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        validator: widget.validator,
        controller: widget.controller,
        maxLines: widget.maxLines,
        keyboardType: TextInputType.multiline,
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          filled: true,
          fillColor: CustomColorScheme.backgroundColor,
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
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1.0),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1.0),
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: widget.labelText,
          errorStyle: const TextStyle(
            backgroundColor: Colors.white,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
