import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_event.dart';
import 'package:moneygo/data/blocs/settings/settings_state.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';
import 'package:moneygo/utils/utils.dart';

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
  String _currency = '\$';

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

      return Row(
        children: [
          Expanded(
            flex: 2,
            child: Checkbox(
              side: const BorderSide(
                  color: CustomColorScheme.appBlue, width: 3.0),
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
                                            style: CustomTextStyleScheme
                                                .barBalance)
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('$_currency ',
                                                  style: CustomTextStyleScheme
                                                      .barBalancePeso),
                                              Text(
                                                  Utils.formatNumber(
                                                      widget.budget),
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
    });
  }
}
