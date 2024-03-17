import 'package:flutter/material.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/ui/widgets/Bars/source_bar.dart';
import 'package:moneygo/ui/widgets/Cards/base_card.dart';
import 'package:moneygo/ui/widgets/SizedBoxes/dashed_box_with_message.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class SourcesCard extends StatelessWidget {
  final List<Source> sources;
  final String currency;

  const SourcesCard({super.key, required this.sources, required this.currency});

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
            const Text(
              'Sources',
              textAlign: TextAlign.left,
              style: CustomTextStyleScheme.cardTitle,
            ),
            TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size.zero,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/sources');
                },
                child: Text(
                  sources.isNotEmpty ? 'View All' : 'Add Here',
                  textAlign: TextAlign.right,
                  style: CustomTextStyleScheme.cardViewAll,
                )),
          ],
        ),
        const SizedBox(height: 20),
        sources.isEmpty
            ? const DashedWidgetWithMessage(message: 'Empty')
            : Column(
                children: sources.map((source) {
                  return Column(
                    children: [
                      SourceBar(
                        name: source.name,
                        value: source.balance,
                        currency: currency,
                      ),
                    ],
                  );
                }).toList(),
              ),
      ],
    ));
  }
}
