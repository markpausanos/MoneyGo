import 'package:flutter/material.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';

class CategoryRemainingBudget extends StatelessWidget {
  final String name;
  final double maxValue;
  final double remainingValue;

  const CategoryRemainingBudget({
    super.key,
    required this.name,
    required this.maxValue,
    required this.remainingValue,
  });

  double get percentage => remainingValue / maxValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Stack(children: <Widget>[
        SizedBox(
          child: LinearProgressIndicator(
              value: percentage,
              minHeight: 56,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              valueColor: AlwaysStoppedAnimation(
                percentage > 0.75
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
                style: Theme.of(context).textTheme.labelSmall,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'P${remainingValue.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(
                    'remaining budget',
                    style: Theme.of(context).textTheme.bodySmall,
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
