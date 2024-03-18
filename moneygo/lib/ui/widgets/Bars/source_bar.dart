import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_event.dart';
import 'package:moneygo/data/blocs/settings/settings_state.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';
import 'package:moneygo/utils/utils.dart';

class SourceBar extends StatefulWidget {
  final String name;
  final double value;

  const SourceBar({
    super.key,
    required this.name,
    required this.value,
  });

  @override
  State<SourceBar> createState() => _SourceBarState();
}

class _SourceBarState extends State<SourceBar> {
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
                        widget.name,
                        style: CustomTextStyleScheme.barLabel,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                '$_currency ',
                                style: CustomTextStyleScheme.barBalancePeso,
                              ),
                              Text(
                                Utils.formatNumber(widget.value),
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
    });
  }
}
