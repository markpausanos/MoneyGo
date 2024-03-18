import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_event.dart';
import 'package:moneygo/data/blocs/settings/settings_state.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';
import 'package:moneygo/utils/utils.dart';

class CategoryBar extends StatefulWidget {
  final String name;
  final double maxValue;
  final double remainingValue;

  const CategoryBar({
    super.key,
    required this.name,
    required this.maxValue,
    required this.remainingValue,
  });

  @override
  State<CategoryBar> createState() => _CategoryBarState();
}

class _CategoryBarState extends State<CategoryBar> {
  String _currency = '\$';
  double get percentage => widget.remainingValue / widget.maxValue;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<SettingsBloc>(context).add(LoadSettings());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      if (state is SettingsLoaded) {
        _currency = state.settings["currency"] ?? "\$";
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Stack(children: <Widget>[
          SizedBox(
            child: LinearProgressIndicator(
                value: widget.maxValue == 0 ? 0 : percentage,
                minHeight: 56,
                borderRadius: BorderRadius.circular(10),
                backgroundColor: CustomColorScheme.backgroundColor,
                valueColor: AlwaysStoppedAnimation(
                  widget.maxValue == 0
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
                  widget.name,
                  style: CustomTextStyleScheme.barLabel,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        widget.maxValue == 0
                            ? const Text('Not set',
                                style: CustomTextStyleScheme.barBalance)
                            : Row(
                                children: [
                                  Text(
                                    "$_currency ",
                                    style: CustomTextStyleScheme.barBalancePeso,
                                  ),
                                  Text(
                                    Utils.formatNumber(widget.remainingValue),
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
    });
  }
}
