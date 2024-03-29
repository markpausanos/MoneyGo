import 'package:flutter/material.dart';
import 'package:moneygo/ui/widgets/Cards/budget/budget_period_card.dart';
import 'package:moneygo/ui/widgets/Cards/budget/categories_card.dart';
import 'package:moneygo/ui/widgets/Cards/budget/remaining_balance_card.dart';
import 'package:moneygo/ui/widgets/Cards/budget/sources_card.dart';
import 'package:moneygo/ui/widgets/Cards/budget/transactions_card.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        BudgetPeriodCard(),
        RemainingBalanceCard(),
        CategoriesCard(),
        SourcesCard(),
        TransactionsCard(),
      ],
    );
  }
}
