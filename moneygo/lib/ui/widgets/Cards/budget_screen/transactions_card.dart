import 'package:flutter/material.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/models/expense_model.dart';
import 'package:moneygo/data/models/income_model.dart';
import 'package:moneygo/data/models/interfaces/transaction_subtype.dart';
import 'package:moneygo/data/models/transfer_model.dart';
import 'package:moneygo/ui/widgets/Bars/transaction_bar.dart';
import 'package:moneygo/ui/widgets/Cards/base_card.dart';
import 'package:moneygo/ui/widgets/SizedBoxes/dashed_box_with_message.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';
import 'package:moneygo/utils/transaction_types.dart';

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
                      Navigator.of(context).pushNamed('/transactions');
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
                        id: transaction.id,
                        title: transaction.title,
                        date: transaction.date,
                        amount: transaction.amount.abs(),
                        description: _getDescription(
                            transaction, widget.transactionsMap[transaction]!),
                        color: _getColor(
                            transaction, widget.transactionsMap[transaction]!),
                        sign: _getSign(transaction),
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

  String? _getSign(Transaction transaction) {
    if (transaction.type == TransactionTypes.transfer) {
      return null;
    } else if (transaction.type == TransactionTypes.expense) {
      return transaction.amount > 0 ? "-" : "+";
    } else if (transaction.type == TransactionTypes.income) {
      return "+";
    }
    return null;
  }

  String _getDescription(
      Transaction transaction, TransactionType transactionType) {
    String description = "Unknown Transaction Type";

    if (transactionType is ExpenseModel) {
      description = transaction.amount > 0
          ? "${transactionType.category?.name} using ${transactionType.source?.name}"
          : "Refund for ${transactionType.category?.name} to ${transactionType.source?.name}";
    } else if (transactionType is IncomeModel) {
      description = "To ${transactionType.placedOnSource?.name}";
    } else if (transactionType is TransferModel) {
      description =
          "${transactionType.fromSource?.name} to ${transactionType.toSource?.name}";
    }

    return description;
  }

  Color _getColor(Transaction transaction, TransactionType transactionType) {
    Color color = Colors.black;

    if (transactionType is ExpenseModel) {
      color = transaction.amount < 0
          ? CustomColorScheme.appGreen
          : CustomColorScheme.appRed;
    } else if (transactionType is IncomeModel) {
      color = CustomColorScheme.appGreen;
    } else if (transactionType is TransferModel) {
      color = CustomColorScheme.appOrange;
    }

    return color;
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
