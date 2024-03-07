import 'package:flutter/material.dart';
import 'package:moneygo/ui/widgets/Cards/base_card.dart';

class RemainingBalanceCard extends StatefulWidget {
  const RemainingBalanceCard({super.key});

  @override
  State<RemainingBalanceCard> createState() => _RemainingBalanceCardState();
}

class _RemainingBalanceCardState extends State<RemainingBalanceCard> {
  List<String> months = [
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
              Text(
                'Remaining Balance',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              Text(
                // in the format of MM/YYYY month name Example February 2024
                '${months[DateTime.now().month - 1]} ${DateTime.now().year}',
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            'P1,000.00',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
