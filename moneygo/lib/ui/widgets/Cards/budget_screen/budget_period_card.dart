import 'package:flutter/material.dart';
import 'package:moneygo/ui/widgets/Cards/base_card.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';
import 'package:moneygo/utils/utils.dart';

class BudgetPeriodCard extends StatelessWidget {
  final DateTime startDate;
  final DateTime? endDate;

  const BudgetPeriodCard({super.key, required this.startDate, this.endDate});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Budget Period',
              textAlign: TextAlign.left,
              style: CustomTextStyleScheme.cardTitle,
            ),
            Row(
              children: [
                Text(
                  endDate != null
                      ? '${Utils.getFormattedDate(startDate)} - ${Utils.getFormattedDate(endDate!)}'
                      : '${Utils.getFormattedDate(startDate)} - TBA',
                  textAlign: TextAlign.right,
                  style: CustomTextStyleScheme.cardTitle,
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.refresh,
                  size: 20,
                  color: Colors.black,
                ),
              ],
            ),
          ],
        ),
      ],
    ));
  }
}
