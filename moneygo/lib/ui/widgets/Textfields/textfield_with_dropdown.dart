import 'package:flutter/material.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class BaseDropdownFormField extends StatefulWidget {
  final Map<int, String> dropDownItemList;
  final int? initialValue;
  final String labelText;
  final Function(int)? onChanged;

  const BaseDropdownFormField({
    super.key,
    required this.dropDownItemList,
    this.initialValue,
    required this.labelText,
    this.onChanged,
  });

  @override
  State<BaseDropdownFormField> createState() => _BaseDropdownFormFieldState();
}

class _BaseDropdownFormFieldState extends State<BaseDropdownFormField> {
  late int _currentSelectedValue;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null &&
        widget.dropDownItemList.keys.contains(widget.initialValue)) {
      _currentSelectedValue = widget.initialValue as int;
    } else if (widget.dropDownItemList.isNotEmpty) {
      _currentSelectedValue = widget.dropDownItemList.keys.first;
    } else {
      _currentSelectedValue = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<int>(
      builder: (FormFieldState<int> state) {
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
          isEmpty: _currentSelectedValue == 0,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _currentSelectedValue,
              isDense: true,
              onChanged: (int? newValue) {
                setState(() {
                  _currentSelectedValue =
                      newValue ?? widget.dropDownItemList.keys.first;
                  state.didChange(newValue);
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(_currentSelectedValue);
                }
              },
              items: widget.dropDownItemList.entries.map((entry) {
                return DropdownMenuItem<int>(
                  value: entry.key,
                  child: Text(entry.value,
                      style: CustomTextStyleScheme.textFieldText),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
