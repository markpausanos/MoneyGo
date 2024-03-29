import 'package:flutter/material.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class SourceCheckBox extends StatefulWidget {
  final int id;
  final String name;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onLongPressed;
  final VoidCallback onTap;

  const SourceCheckBox(
      {super.key,
      required this.id,
      required this.name,
      required this.isChecked,
      required this.onChanged,
      required this.onLongPressed,
      required this.onTap});

  @override
  State<SourceCheckBox> createState() => _SourceCheckBoxState();
}

class _SourceCheckBoxState extends State<SourceCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 2,
          child: Checkbox(
              side: const BorderSide(
                  color: CustomColorScheme.appBlue, width: 3.0),
              value: widget.isChecked,
              onChanged: widget.onChanged)),
      const Expanded(flex: 1, child: SizedBox(width: 0)),
      Expanded(
        flex: 14,
        child: SizedBox(
          height: 60,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            splashColor: CustomColorScheme.appGray,
            onLongPress: widget.onLongPressed,
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CustomColorScheme.backgroundColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.name, style: CustomTextStyleScheme.barLabel),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      )
    ]);
  }
}
