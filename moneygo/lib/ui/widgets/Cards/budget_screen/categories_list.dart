import 'package:flutter/material.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/ui/widgets/Cards/base_card.dart';
import 'package:moneygo/ui/widgets/ProgressBars/category_remaining_budget.dart';

class CategoriesCard extends StatelessWidget {
  final List<Category> categories;

  const CategoriesCard({super.key, required this.categories});

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
              Text(
                'Categories',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: Size.zero,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/categories');
                  },
                  child: Text(
                    'View All',
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.labelSmall,
                  )),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: categories.map((category) {
              return Column(
                children: [
                  CategoryRemainingBudget(
                      name: category.name,
                      maxValue: category.maxBudget ?? 0.0,
                      remainingValue: category.balance ?? 0.0),
                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
