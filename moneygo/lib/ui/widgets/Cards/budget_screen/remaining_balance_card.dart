import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_event.dart';
import 'package:moneygo/data/blocs/settings/settings_state.dart';
import 'package:moneygo/data/blocs/sources/source_bloc.dart';
import 'package:moneygo/data/blocs/sources/source_event.dart';
import 'package:moneygo/data/blocs/sources/source_state.dart';
import 'package:moneygo/ui/widgets/Cards/base_card.dart';
import 'package:moneygo/ui/widgets/Loaders/loading_state.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';
import 'package:moneygo/utils/utils.dart';

class RemainingBalanceCard extends StatefulWidget {
  const RemainingBalanceCard({super.key});

  @override
  State<RemainingBalanceCard> createState() => _RemainingBalanceCardState();
}

class _RemainingBalanceCardState extends State<RemainingBalanceCard> {
  String _currency = '\$';
  double _balance = 0.0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SettingsBloc>(context).add(LoadSettings());
    BlocProvider.of<SourceBloc>(context).add(LoadSources());
  }

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Remaining Balance',
                    textAlign: TextAlign.left,
                    style: CustomTextStyleScheme.cardTitle,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, state) {
                      if (state is SettingsLoaded) {
                        _currency = state.settings['currency'] ?? '\$';
                        return Text(
                          _currency,
                          style: CustomTextStyleScheme.currencySign,
                        );
                      }
                      return Text(
                        _currency,
                        style: CustomTextStyleScheme.currencySign,
                      );
                    },
                  ),
                  const SizedBox(width: 5),
                  BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, state) {
                      if (state is SettingsLoaded) {
                        bool isVisible = state.settings['isVisible'] == 'true';
                        return isVisible
                            ? BlocBuilder<SourceBloc, SourceState>(
                                builder: (context, state) {
                                  if (state is SourcesLoaded) {
                                    final sources = state.sources;
                                    if (sources.isEmpty) {
                                      return const Text(
                                        '0.00',
                                        style: CustomTextStyleScheme
                                            .remainingBalanceText,
                                      );
                                    }
                                    _balance = sources
                                        .map((source) => source.balance)
                                        .reduce((a, b) => a + b);
                                    return Text(
                                      Utils.formatNumber(_balance),
                                      style: CustomTextStyleScheme
                                          .remainingBalanceText,
                                    );
                                  }
                                  return Text(
                                    Utils.formatNumber(_balance),
                                    style: CustomTextStyleScheme
                                        .remainingBalanceText,
                                  );
                                },
                              )
                            : const Text(
                                '*******',
                                style:
                                    CustomTextStyleScheme.remainingBalanceText,
                              );
                      }
                      return const Loader();
                    },
                  ),
                ],
              ),
              BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, state) {
                if (state is SettingsLoaded) {
                  bool isVisible = state.settings['isVisible'] == 'true';

                  return IconButton(
                    onPressed: () {
                      isVisible = !isVisible;
                      BlocProvider.of<SettingsBloc>(context)
                          .add(SaveSetting("isVisible", isVisible.toString()));
                    },
                    color: CustomColorScheme.appGray,
                    icon: isVisible
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ],
      ),
    );
  }
}
