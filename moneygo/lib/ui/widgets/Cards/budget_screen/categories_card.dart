import 'package:flutter/material.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/ui/widgets/Cards/base_card.dart';
import 'package:moneygo/ui/widgets/Bars/category_bar.dart';
import 'package:moneygo/ui/widgets/SizedBoxes/dashed_box_with_message.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class CategoriesCard extends StatelessWidget {
  final List<Category> categories;
  final String currency;

  const CategoriesCard(
      {super.key, required this.categories, required this.currency});

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
                    Navigator.of(context)
                        .pushNamed('/categories', arguments: categories);
                  },
                  child: Text(
                    categories.isNotEmpty ? 'View All' : 'Add Here',
                    textAlign: TextAlign.right,
                    style: CustomTextStyleScheme.cardViewAll,
                  )),
            ],
          ),
          const SizedBox(height: 20),
          categories.isEmpty
              ? const DashedWidgetWithMessage(message: 'Empty')
              : Column(
                  children: categories.map((category) {
                    return Column(
                      children: [
                        CategoryBar(
                            name: category.name,
                            maxValue: category.maxBudget,
                            remainingValue: category.balance,
                            currency: currency),
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
