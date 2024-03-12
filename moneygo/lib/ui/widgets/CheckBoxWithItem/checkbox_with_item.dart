import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class CheckBoxWithItem extends StatefulWidget {
  const CheckBoxWithItem({super.key});

  @override
  State<CheckBoxWithItem> createState() => _CheckBoxWithItemState();
}

class _CheckBoxWithItemState extends State<CheckBoxWithItem> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Checkbox(
            side:
                const BorderSide(color: CustomColorScheme.primary, width: 3.0),
            value: _isChecked,
            onChanged: (bool? value) {
              setState(() {
                _isChecked = value!;
              });
            },
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
                      const Text('Food',
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
                              const Text(
                                '1,000.00',
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
