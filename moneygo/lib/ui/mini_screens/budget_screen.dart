import 'package:flutter/material.dart';
import 'package:moneygo/ui/widgets/Cards/budget_screen/remaining_balance_card.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          const RemainingBalanceCard(),
          const SizedBox(height: 10),
          Text(
            'Budget Screen',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
