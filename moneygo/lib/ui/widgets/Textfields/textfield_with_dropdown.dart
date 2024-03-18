import 'package:flutter/material.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class BaseDropdownFormField extends StatefulWidget {
  final List<String> dropDownItemList;
  final String initialValue;
  final String labelText;

  const BaseDropdownFormField({
    super.key,
    required this.dropDownItemList,
    this.initialValue = '',
    required this.labelText,
  });

  @override
  State<BaseDropdownFormField> createState() => _BaseDropdownFormFieldState();
}

class _BaseDropdownFormFieldState extends State<BaseDropdownFormField> {
  late String _currentSelectedValue;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue.isNotEmpty &&
        widget.dropDownItemList.contains(widget.initialValue)) {
      _currentSelectedValue = widget.initialValue;
    } else if (widget.dropDownItemList.isNotEmpty) {
      _currentSelectedValue = widget.dropDownItemList.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: CustomColorScheme.backgroundColor,
            labelStyle: CustomTextStyleScheme.textFieldText,
            errorStyle:
                CustomTextStyleScheme.textFieldText.copyWith(color: Colors.red),
            labelText: widget.labelText,
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10.0)),
          ),
          isEmpty: _currentSelectedValue == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _currentSelectedValue,
              isDense: true,
              onChanged: (String? newValue) {
                setState(() {
                  _currentSelectedValue =
                      newValue ?? widget.dropDownItemList.first;
                  state.didChange(newValue);
                });
              },
              items: widget.dropDownItemList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child:
                      Text(value, style: CustomTextStyleScheme.textFieldText),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
