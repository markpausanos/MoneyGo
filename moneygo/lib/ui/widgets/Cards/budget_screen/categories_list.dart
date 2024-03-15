import 'package:flutter/material.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/ui/widgets/Cards/base_card.dart';
import 'package:moneygo/ui/widgets/ProgressBars/category_remaining_budget.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

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
              const Text(
                'Categories',
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
                    Navigator.of(context).pushNamed('/categories', arguments: categories);
                  },
                  child: Text(
                    'View All',
                    textAlign: TextAlign.right,
                    style: CustomTextStyleScheme.cardTitle.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
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
