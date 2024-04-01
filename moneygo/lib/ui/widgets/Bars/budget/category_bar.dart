import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/blocs/settings/settings_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_event.dart';
import 'package:moneygo/data/blocs/settings/settings_state.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';
import 'package:moneygo/utils/utils.dart';

class CategoryBar extends StatefulWidget {
  final bool isFirst;
  final bool isLast;
  final Category category;

  const CategoryBar({
    super.key,
    required this.category,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  State<CategoryBar> createState() => _CategoryBarState();
}

class _CategoryBarState extends State<CategoryBar> {
  String _currency = '\$';

  double get percentage {
    var percent = widget.category.balance / widget.category.maxBudget;

    return percent > 1
        ? 1
        : percent < 0
            ? 0
            : percent;
  }

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

      return InkWell(
        splashColor: Colors.white,
        borderRadius: widget.isFirst
            ? const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))
            : widget.isLast
                ? const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))
                : null,
        onTap: () {
          Navigator.of(context)
              .pushNamed('/categories/view', arguments: widget.category);
        },
        child: Stack(children: <Widget>[
          SizedBox(
            child: LinearProgressIndicator(
                borderRadius: widget.isFirst
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      )
                    : widget.isLast
                        ? const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )
                        : BorderRadius.zero,
                value: widget.category.maxBudget == 0 ? 0 : percentage,
                minHeight: 56,
                backgroundColor: CustomColorScheme.backgroundColor,
                valueColor: AlwaysStoppedAnimation(
                  widget.category.maxBudget == 0
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
                  widget.category.name,
                  style: CustomTextStyleScheme.barLabel,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        widget.category.maxBudget == 0
                            ? const Text('Not set',
                                style: CustomTextStyleScheme.barBalance)
                            : Row(
                                children: [
                                  Text(
                                    _currency,
                                    style: CustomTextStyleScheme.barBalancePeso,
                                  ),
                                  Text(
                                    Utils.formatNumber(widget.category.balance),
                                    style: CustomTextStyleScheme.barBalance,
                                  ),
                                ],
                              ),
                      ],
                    ),
                    Text(
                      widget.category.balance >= 0
                          ? 'remaining budget'
                          : 'over budget',
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
