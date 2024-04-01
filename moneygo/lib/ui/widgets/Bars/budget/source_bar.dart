import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/blocs/settings/settings_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_event.dart';
import 'package:moneygo/data/blocs/settings/settings_state.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';
import 'package:moneygo/utils/utils.dart';

class SourceBar extends StatefulWidget {
  final Source source;

  const SourceBar({
    super.key,
    required this.source,
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

      return InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/sources/view',
                arguments: widget.source);
          },
          child: SizedBox(
            height: 63,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.source.name,
                    style: CustomTextStyleScheme.barLabel,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            _currency,
                            style: CustomTextStyleScheme.barBalancePeso,
                          ),
                          Text(
                            Utils.formatNumber(widget.source.balance),
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
          ));
    });
  }
}
