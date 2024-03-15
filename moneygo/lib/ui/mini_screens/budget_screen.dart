import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/blocs/categories/category_bloc.dart';
import 'package:moneygo/data/blocs/categories/category_event.dart';
import 'package:moneygo/data/blocs/categories/category_state.dart';
import 'package:moneygo/ui/widgets/Cards/budget_screen/categories_list.dart';
import 'package:moneygo/ui/widgets/Cards/budget_screen/remaining_balance_card.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CategoryBloc>(context).add(LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const RemainingBalanceCard(),
        const SizedBox(height: 10),
        BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
          if (state is CategoriesLoading) {
            return const CircularProgressIndicator();
          } else if (state is CategoriesLoaded) {
            return CategoriesCard(categories: state.categories);
          } else if (state is CategoriesError) {
            return Text('Error: ${state.message}');
          } else {
            return const Text('No categories found');
          }
        })
      ],
    );
  }
}
