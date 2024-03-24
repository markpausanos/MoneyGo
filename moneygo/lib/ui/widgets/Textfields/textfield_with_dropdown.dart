import 'package:flutter/material.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class BaseDropdownFormField extends StatefulWidget {
  final Map<int, String> dropDownItemList;
  final int? initialValue;
  final String labelText;
  final Function(int)? onChanged;
  final String? Function(int?)? validator;

  const BaseDropdownFormField({
    super.key,
    required this.dropDownItemList,
    this.initialValue,
    required this.labelText,
    this.onChanged,
    this.validator,
  });

  @override
  State<BaseDropdownFormField> createState() => _BaseDropdownFormFieldState();
}

class _BaseDropdownFormFieldState extends State<BaseDropdownFormField> {
  int? _currentSelectedValue;

  @override
  void initState() {
    super.initState();
    // If initialValue is provided and valid, use it, otherwise use null
    _currentSelectedValue = widget.initialValue != null &&
            widget.dropDownItemList.containsKey(widget.initialValue)
        ? widget.initialValue
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: _currentSelectedValue,
      isDense: true,
      onChanged: widget.dropDownItemList.isNotEmpty
          ? (int? newValue) {
              setState(() {
                _currentSelectedValue = newValue;
              });
              if (widget.onChanged != null && newValue != null) {
                widget.onChanged!(newValue);
              }
            }
          : null,
      validator: widget.validator,
      items: widget.dropDownItemList.isNotEmpty
          ? widget.dropDownItemList.entries.map((entry) {
              return entry.key == 0
                  ? DropdownMenuItem<int>(
                      value: entry.key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("None",
                              style: CustomTextStyleScheme.textFieldText
                                  .copyWith(color: CustomColorScheme.appGray)),
                        ],
                      ),
                    )
                  : DropdownMenuItem<int>(
                      value: entry.key,
                      child: Text(entry.value,
                          style: CustomTextStyleScheme.textFieldText),
                    );
            }).toList()
          : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: CustomColorScheme.backgroundColor,
        labelStyle: CustomTextStyleScheme.textFieldText,
        errorStyle: const TextStyle(
          backgroundColor:
              Colors.white, // Set the background color for the error text
          color: Colors.red,
        ),
        labelText: widget.labelText,
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
      ),
    );
  }
}
