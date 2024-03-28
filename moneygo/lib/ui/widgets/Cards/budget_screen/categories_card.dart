import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/blocs/categories/category_bloc.dart';
import 'package:moneygo/data/blocs/categories/category_event.dart';
import 'package:moneygo/data/blocs/categories/category_state.dart';
import 'package:moneygo/ui/widgets/Cards/base_card.dart';
import 'package:moneygo/ui/widgets/Bars/category_bar.dart';
import 'package:moneygo/ui/widgets/SizedBoxes/dashed_box_with_message.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class CategoriesCard extends StatefulWidget {
  const CategoriesCard({super.key});

  @override
  State<CategoriesCard> createState() => _CategoriesCardState();
}

class _CategoriesCardState extends State<CategoriesCard> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<CategoryBloc>(context).add(LoadCategories());
  }

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
              Row(
                children: [
                  const Text(
                    'Categories',
                    textAlign: TextAlign.left,
                    style: CustomTextStyleScheme.cardTitle,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: 15,
                    height: 15,
                    child: Tooltip(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      triggerMode: TooltipTriggerMode.tap,
                      message: _getTooltipMessage(),
                      showDuration: const Duration(seconds: 5),
                      textAlign: TextAlign.center,
                      child: const Icon(
                        Icons.info_outline,
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoriesLoaded) {
                    return TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: Size.zero,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/categories',
                              arguments: state.categories);
                        },
                        child: Text(
                          state.categories.isNotEmpty ? 'View All' : 'Add Here',
                          textAlign: TextAlign.right,
                          style: CustomTextStyleScheme.cardViewAll,
                        ));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoriesLoaded) {
                if (state.categories.isEmpty) {
                  return const DashedWidgetWithMessage(
                      message: 'No categories found');
                }
                return Column(
                  children: [
                    Column(
                      children: state.categories.map((category) {
                        return Column(
                          children: [
                            CategoryBar(
                              category: category,
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                );
              } else if (state is CategoriesError) {
                return DashedWidgetWithMessage(message: state.message);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ],
      ),
    );
  }

  String _getTooltipMessage() {
    return 'Categories are used to group transactions together. Transactions can only choose from the available categories within the budget period.';
  }
}
