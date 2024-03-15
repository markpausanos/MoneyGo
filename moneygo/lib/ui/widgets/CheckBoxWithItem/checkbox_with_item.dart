import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class CheckBoxWithItem extends StatefulWidget {
  final int id;
  final String name;
  final double budget;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const CheckBoxWithItem(
      {super.key,
      required this.id,
      required this.isChecked,
      required this.onChanged,
      required this.name,
      required this.budget});

  @override
  State<CheckBoxWithItem> createState() => _CheckBoxWithItemState();
}

class _CheckBoxWithItemState extends State<CheckBoxWithItem> {
  late bool isChecked;

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
                          style: CustomTextStyleScheme.progressBarLabel),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                '₱',
                                style: CustomTextStyleScheme
                                    .progressBarBalancePeso,
                              ),
                              Text(
                                widget.budget.toStringAsFixed(2),
                                style: CustomTextStyleScheme.progressBarBalance,
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
                ))),
      ],
    );
  }
}
