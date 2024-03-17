import 'package:flutter/material.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class CategoryCheckBox extends StatefulWidget {
  final int id;
  final String name;
  final double budget;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onLongPressed;

  const CategoryCheckBox(
      {super.key,
      required this.id,
      required this.isChecked,
      required this.onChanged,
      required this.name,
      required this.budget,
      required this.onLongPressed});

  @override
  State<CategoryCheckBox> createState() => _CategoryCheckBoxState();
}

class _CategoryCheckBoxState extends State<CategoryCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Checkbox(
            side:
                const BorderSide(color: CustomColorScheme.appBlue, width: 3.0),
            value: widget.isChecked,
            onChanged: widget.onChanged,
          ),
        ),
        const Expanded(flex: 1, child: SizedBox(width: 0)),
        Expanded(
            flex: 14,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              splashColor: CustomColorScheme.appGray,
              onLongPress: widget.onLongPressed,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: CustomColorScheme.backgroundColor),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(widget.name,
                              style: CustomTextStyleScheme.barLabel),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  widget.budget == 0.0
                                      ? const Text('Not set',
                                          style:
                                              CustomTextStyleScheme.barBalance)
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('₱',
                                                style: CustomTextStyleScheme
                                                    .barBalancePeso),
                                            Text(
                                                widget.budget
                                                    .toStringAsFixed(2),
                                                style: CustomTextStyleScheme
                                                    .barBalance),
                                          ],
                                        ),
                                ],
                              ),
                              const Text(
                                'budget',
                                style: CustomTextStyleScheme.progressBarText,
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
              ),
            )),
      ],
    );
  }
}
