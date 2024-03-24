import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/blocs/settings/settings_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_event.dart';
import 'package:moneygo/data/blocs/settings/settings_state.dart';
import 'package:moneygo/ui/widgets/Cards/base_card.dart';
import 'package:moneygo/ui/widgets/Bars/category_bar.dart';
import 'package:moneygo/ui/widgets/SizedBoxes/dashed_box_with_message.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class CategoriesCard extends StatefulWidget {
  final List<Category> categories;

  const CategoriesCard({super.key, required this.categories});

  @override
  State<CategoriesCard> createState() => _CategoriesCardState();
}

class _CategoriesCardState extends State<CategoriesCard> {
  String currency = '\$';

  @override
  void initState() {
    super.initState();

    BlocProvider.of<SettingsBloc>(context).add(LoadSettings());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsLoaded) {
          setState(() {
            currency = state.settings["currency"] ?? "\$";
          });
        }
      },
      child: BaseCard(
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
                TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/categories',
                          arguments: widget.categories);
                    },
                    child: Text(
                      widget.categories.isNotEmpty ? 'View All' : 'Add Here',
                      textAlign: TextAlign.right,
                      style: CustomTextStyleScheme.cardViewAll,
                    )),
              ],
            ),
            const SizedBox(height: 20),
            widget.categories.isEmpty
                ? const DashedWidgetWithMessage(message: 'Empty')
                : Column(
                    children: widget.categories.map((category) {
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
        ),
      ),
    );
  }

  String _getTooltipMessage() {
    return 'Categories are used to group transactions together. Transactions can only choose from the available categories within the budget period.';
  }
}
