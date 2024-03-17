import 'package:flutter/material.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class CategoryBar extends StatelessWidget {
  final String name;
  final double maxValue;
  final double remainingValue;
  final String currency;

  const CategoryBar({
    super.key,
    required this.name,
    required this.maxValue,
    required this.remainingValue,
    required this.currency,
  });

  double get percentage => remainingValue / maxValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Stack(children: <Widget>[
        SizedBox(
          child: LinearProgressIndicator(
              value: maxValue == 0 ? 0 : percentage,
              minHeight: 56,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: CustomColorScheme.backgroundColor,
              valueColor: AlwaysStoppedAnimation(
                maxValue == 0
                    ? CustomColorScheme.appGray
                    : percentage > 0.75
                        ? CustomColorScheme.percentageGood
                        : percentage > 0.5
                            ? CustomColorScheme.percentageAverage
                            : CustomColorScheme.percentageBad,
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                name,
                style: CustomTextStyleScheme.barLabel,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      maxValue == 0
                          ? const Text('Not set',
                              style: CustomTextStyleScheme.barBalance)
                          : Row(
                              children: [
                                Text(
                                  currency,
                                  style: CustomTextStyleScheme.barBalancePeso,
                                ),
                                Text(
                                  remainingValue.toStringAsFixed(2),
                                  style: CustomTextStyleScheme.barBalance,
                                ),
                              ],
                            ),
                    ],
                  ),
                  const Text(
                    'remaining budget',
                    style: CustomTextStyleScheme.progressBarText,
                  ),
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }
}
