import 'package:flutter/material.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/models/interfaces/transaction_subtype.dart';
import 'package:moneygo/routes.dart';
import 'package:moneygo/ui/widgets/Bars/transaction_bar.dart';
import 'package:moneygo/ui/widgets/Cards/base_card.dart';
import 'package:moneygo/ui/widgets/SizedBoxes/dashed_box_with_message.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class TransactionsCard extends StatefulWidget {
  final Map<Transaction, TransactionType> transactionsMap;

  const TransactionsCard({super.key, required this.transactionsMap});

  @override
  State<TransactionsCard> createState() => _TransactionsCardState();
}

class _TransactionsCardState extends State<TransactionsCard> {
  int _pageSize = 5;
  List<Map<Transaction, TransactionType>> _displayedTransactionsMap = [];

  @override
  void initState() {
    super.initState();
    _updateDisplayedTransactions();
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
            const Text(
              'Transactions',
              textAlign: TextAlign.left,
              style: CustomTextStyleScheme.cardTitle,
            ),
            widget.transactionsMap.isNotEmpty
                ? TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          AppRoutes.generateRoute(
                              const RouteSettings(name: "/transactions")));
                    },
                    child: const Text(
                      'View All',
                      textAlign: TextAlign.right,
                      style: CustomTextStyleScheme.cardViewAll,
                    ))
                : const SizedBox()
          ],
        ),
        const SizedBox(height: 20),
        widget.transactionsMap.isEmpty
            ? const DashedWidgetWithMessage(message: 'Empty')
            : Column(
                children: _displayedTransactionsMap.map((map) {
                  final transaction = map.keys.first;

                  return Column(
                    children: [
                      TransactionBar(
                        transaction: transaction,
                        transactionType: map.values.first,
                      ),
                      const SizedBox(height: 5),
                    ],
                  );
                }).toList(),
              ),
        if (_displayedTransactionsMap.length < widget.transactionsMap.length)
          InkWell(
            onTap: _loadMoreTransactions,
            child: Center(
              child: IconButton(
                onPressed: _loadMoreTransactions,
                icon: const Icon(Icons.arrow_drop_down),
              ),
            ),
          ),
      ],
    ));
  }

  void _updateDisplayedTransactions() {
    _displayedTransactionsMap = widget.transactionsMap.entries
        .take(_pageSize)
        .map((entry) => {entry.key: entry.value})
        .toList();
  }

  void _loadMoreTransactions() {
    setState(() {
      _pageSize += 5;
      _updateDisplayedTransactions();
    });
  }
}
