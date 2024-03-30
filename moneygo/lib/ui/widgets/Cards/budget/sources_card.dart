import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/blocs/budget/sources/source_bloc.dart';
import 'package:moneygo/data/blocs/budget/sources/source_event.dart';
import 'package:moneygo/data/blocs/budget/sources/source_state.dart';
import 'package:moneygo/ui/widgets/Bars/budget/source_bar.dart';
import 'package:moneygo/ui/widgets/Cards/base_card.dart';
import 'package:moneygo/ui/widgets/SizedBoxes/dashed_box_with_message.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class SourcesCard extends StatefulWidget {
  const SourcesCard({super.key});

  @override
  State<SourcesCard> createState() => _SourcesCardState();
}

class _SourcesCardState extends State<SourcesCard> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SourceBloc>(context).add(LoadSources());
  }

  @override
  Widget build(BuildContext context) {
    return BaseCard(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Sources',
                  textAlign: TextAlign.left,
                  style: CustomTextStyleScheme.cardTitle,
                ),
                const SizedBox(
                  width: 5,
                ),
                SizedBox(
                  width: 15,
                  height: 15,
                  child: Tooltip(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    triggerMode: TooltipTriggerMode.tap,
                    message: _getTooltipMessage(),
                    showDuration: const Duration(seconds: 5),
                    textAlign: TextAlign.center,
                    child: const Icon(
                      Icons.info_outline,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
            BlocBuilder<SourceBloc, SourceState>(builder: (context, state) {
              if (state is SourcesLoaded) {
                return TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/sources');
                    },
                    child: Text(
                      state.sources.isNotEmpty ? 'View All' : 'Add Here',
                      textAlign: TextAlign.right,
                      style: CustomTextStyleScheme.cardViewAll,
                    ));
              }
              return const SizedBox();
            }),
          ],
        ),
        const SizedBox(height: 20),
        BlocBuilder<SourceBloc, SourceState>(builder: (context, state) {
          if (state is SourcesLoaded) {
            return state.sources.isEmpty
                ? const DashedWidgetWithMessage(message: 'No sources found')
                : Column(
                    children: state.sources.map((source) {
                      return Column(
                        children: [
                          SourceBar(
                            source: source,
                          ),
                        ],
                      );
                    }).toList(),
                  );
          }
          return const CircularProgressIndicator();
        }),
      ],
    ));
  }

  String _getTooltipMessage() {
    return 'Sources are the places where you place and get your money from like your Bank or Cash.';
  }
}
