import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_event.dart';
import 'package:moneygo/data/blocs/settings/settings_state.dart';
import 'package:moneygo/ui/widgets/Cards/base_card.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class RemainingBalanceCard extends StatefulWidget {
  bool isVisible;

  RemainingBalanceCard({super.key, required this.isVisible});

  @override
  State<RemainingBalanceCard> createState() => _RemainingBalanceCardState();
}

class _RemainingBalanceCardState extends State<RemainingBalanceCard> {
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

        return BaseCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Remaining Balance',
                    textAlign: TextAlign.left,
                    style: CustomTextStyleScheme.cardTitle,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        _currency,
                        style: CustomTextStyleScheme.pesoSign,
                      ),
                      const SizedBox(width: 5),
                      widget.isVisible
                          ? const Text(
                              '1,000.00',
                              style: CustomTextStyleScheme.remainingBalanceText,
                            )
                          : const Text(
                              '*******',
                              style: CustomTextStyleScheme.remainingBalanceText,
                            ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      bool isVisible = !widget.isVisible;
                      BlocProvider.of<SettingsBloc>(context)
                          .add(SaveSetting("isVisible", isVisible.toString()));
                    },
                    color: CustomColorScheme.appGray,
                    icon: widget.isVisible
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
