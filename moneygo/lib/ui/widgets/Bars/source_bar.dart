import 'package:flutter/material.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class SourceBar extends StatelessWidget {
  final String name;
  final double value;
  final String currency;

  const SourceBar(
      {super.key,
      required this.name,
      required this.value,
      required this.currency});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Stack(
          children: <Widget>[
            Container(
              height: 63,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(
                      color: CustomColorScheme.backgroundColor, width: 3)),
              child: Padding(
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
                            Text(
                              currency,
                              style: CustomTextStyleScheme.barBalancePeso,
                            ),
                            Text(
                              value.toStringAsFixed(2),
                              style: CustomTextStyleScheme.barBalance,
                            ),
                          ],
                        ),
                        const Text('remaining balance',
                            style: CustomTextStyleScheme.progressBarText)
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
