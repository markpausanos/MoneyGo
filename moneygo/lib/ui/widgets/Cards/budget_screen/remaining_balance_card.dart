import 'package:flutter/material.dart';
import 'package:moneygo/ui/widgets/Cards/base_card.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class RemainingBalanceCard extends StatelessWidget {
  const RemainingBalanceCard({super.key});

  static final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

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
                'Remaining Balance',
                textAlign: TextAlign.left,
                style: CustomTextStyleScheme.cardTitle,
              ),
              Text(
                '${months[DateTime.now().month - 1]} ${DateTime.now().year}',
                textAlign: TextAlign.right,
                style: CustomTextStyleScheme.cardTitle,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Text(
                '₱',
                style: CustomTextStyleScheme.pesoSign,
              ),
              const SizedBox(width: 5),
              const Text(
                '1,000.00',
                style: CustomTextStyleScheme.remainingBalanceText,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
