import 'package:flutter/material.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/dao/categories.dart';
import 'package:moneygo/ui/widgets/Cards/budget_screen/categories_list.dart';
import 'package:moneygo/ui/widgets/Cards/budget_screen/remaining_balance_card.dart';
import 'package:provider/provider.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);
    final CategoriesDao categoriesDao = CategoriesDao(database);

    return Column(
      children: [
        const RemainingBalanceCard(),
        const SizedBox(height: 10),
        StreamBuilder<List<Category>>(
          stream: categoriesDao.watchAllCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return CategoriesCard(categories: snapshot.data!);
            } else {
              return const Text('No categories found');
            }
          },
        ),
      ],
    );
  }
}
