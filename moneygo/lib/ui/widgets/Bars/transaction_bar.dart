import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_event.dart';
import 'package:moneygo/data/blocs/settings/settings_state.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';
import 'package:moneygo/utils/utils.dart';

class TransactionBar extends StatefulWidget {
  final int id;
  final String title;
  final DateTime date;
  final double amount;
  final String description;
  final String? sign;
  final Color color;

  const TransactionBar(
      {super.key,
      required this.id,
      required this.title,
      required this.date,
      required this.amount,
      required this.description,
      required this.color,
      this.sign});

  @override
  State<TransactionBar> createState() => _TransactionBarState();
}

class _TransactionBarState extends State<TransactionBar> {
  String _currency = '\$';

  @override
  void initState() {
    super.initState();

    BlocProvider.of<SettingsBloc>(context).add(LoadSettings());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoaded) {
          _currency = state.settings["currency"] ?? "\$";
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Stack(
            children: <Widget>[
              Container(
                height: 63,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: CustomTextStyleScheme.barLabel,
                          ),
                          // Date in MMM dd, yyyy format
                          Text(
                            Utils.getFormattedDateFull(widget.date),
                            style: CustomTextStyleScheme.progressBarText,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.sign ?? '',
                                style: CustomTextStyleScheme.barLabel
                                    .copyWith(color: widget.color),
                              ),
                              Text(
                                _currency,
                                style: CustomTextStyleScheme.barLabel.copyWith(
                                    color: widget.color,
                                    fontFamily: CustomTextStyleScheme
                                        .barBalancePeso.fontFamily),
                              ),
                              Text(
                                Utils.formatNumber(widget.amount),
                                style: CustomTextStyleScheme.barLabel
                                    .copyWith(color: widget.color),
                              ),
                            ],
                          ),
                          Text(
                            widget.description.length > 15
                                ? '${widget.description.substring(0, 15)}...'
                                : widget.description,
                            style: CustomTextStyleScheme.progressBarText,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
