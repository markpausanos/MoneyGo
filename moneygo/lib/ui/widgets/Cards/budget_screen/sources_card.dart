import 'package:flutter/material.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/ui/widgets/Bars/source_bar.dart';
import 'package:moneygo/ui/widgets/Cards/base_card.dart';
import 'package:moneygo/ui/widgets/SizedBoxes/dashed_box_with_message.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class SourcesCard extends StatefulWidget {
  final List<Source> sources;

  const SourcesCard({super.key, required this.sources});

  @override
  State<SourcesCard> createState() => _SourcesCardState();
}

class _SourcesCardState extends State<SourcesCard> {
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
                  widget.sources.isNotEmpty ? 'View All' : 'Add Here',
                  textAlign: TextAlign.right,
                  style: CustomTextStyleScheme.cardViewAll,
                )),
          ],
        ),
        const SizedBox(height: 20),
        widget.sources.isEmpty
            ? const DashedWidgetWithMessage(message: 'Empty')
            : Column(
                children: widget.sources.map((source) {
                  return Column(
                    children: [
                      SourceBar(
                        name: source.name,
                        value: source.balance,
                      ),
                    ],
                  );
                }).toList(),
              ),
      ],
    ));
  }
}
