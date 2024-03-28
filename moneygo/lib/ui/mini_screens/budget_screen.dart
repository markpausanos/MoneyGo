import 'package:flutter/material.dart';
import 'package:moneygo/ui/widgets/Cards/budget_screen/budget_period_card.dart';
import 'package:moneygo/ui/widgets/Cards/budget_screen/categories_card.dart';
import 'package:moneygo/ui/widgets/Cards/budget_screen/remaining_balance_card.dart';
import 'package:moneygo/ui/widgets/Cards/budget_screen/sources_card.dart';
import 'package:moneygo/ui/widgets/Cards/budget_screen/transactions_card.dart';

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
