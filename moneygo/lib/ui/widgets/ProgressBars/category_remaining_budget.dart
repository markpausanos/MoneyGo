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
    return Stack(children: <Widget>[
      SizedBox(
        child: LinearProgressIndicator(
            value: percentage,
            minHeight: 40,
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
      Positioned(
        left: 10,
        top: 10,
        child: Text(
          '50%',
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ),
    ]);
  }
}
