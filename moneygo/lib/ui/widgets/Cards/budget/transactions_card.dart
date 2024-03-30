import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/blocs/budget/transactions/transaction_bloc.dart';
import 'package:moneygo/data/blocs/budget/transactions/transaction_event.dart';
import 'package:moneygo/data/blocs/budget/transactions/transaction_state.dart';
import 'package:moneygo/data/models/budget/transaction_subtype.dart';
import 'package:moneygo/routes.dart';
import 'package:moneygo/ui/widgets/Bars/budget/transaction_bar.dart';
import 'package:moneygo/ui/widgets/Cards/base_card.dart';
import 'package:moneygo/ui/widgets/SizedBoxes/dashed_box_with_message.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class TransactionsCard extends StatefulWidget {
  const TransactionsCard({super.key});

  @override
  State<TransactionsCard> createState() => _TransactionsCardState();
}

class _TransactionsCardState extends State<TransactionsCard> {
  int _pageSize = 5;
  Map<Transaction, TransactionType> _transactionsMap = {};
  List<MapEntry<Transaction, TransactionType>> _displayedTransactionsMap = [];

  @override
  void initState() {
    super.initState();
    _updateDisplayedTransactions();

    BlocProvider.of<TransactionBloc>(context).add(LoadTransactions());
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
                  'Transactions',
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
            BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionsLoaded &&
                    state.transactions.isNotEmpty) {
                  return TextButton(
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
                      ));
                } else {
                  return const SizedBox();
                }
              },
            )
          ],
        ),
        const SizedBox(height: 20),
        BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionsLoaded) {
              _transactionsMap = state.transactions;

              if (_transactionsMap.isNotEmpty) {
                _updateDisplayedTransactions();
              }

              if (_transactionsMap.isEmpty) {
                return const DashedWidgetWithMessage(
                    message: 'No transactions found');
              }

              return Column(
                children: [
                  _buildTransactionsList(),
                  const SizedBox(height: 20),
                  if (_displayedTransactionsMap.length <
                      _transactionsMap.length)
                    InkWell(
                      onTap: _loadMoreTransactions,
                      child: const SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text('Load More',
                              style: CustomTextStyleScheme.cardViewAll),
                        ),
                      ),
                    ),
                ],
              );
            } else if (state is TransactionsError) {
              return DashedWidgetWithMessage(message: state.message);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    ));
  }

  String _getTooltipMessage() {
    return 'This is the list of all transactions made. Add a source first to start adding transactions.';
  }

  Widget _buildTransactionsList() {
    return Column(
      children: _displayedTransactionsMap
          .map((MapEntry<Transaction, TransactionType> entry) {
        return TransactionBar(
          transaction: entry.key,
          transactionType: entry.value,
          previousRoute: "/home",
        );
      }).toList(),
    );
  }

  void _updateDisplayedTransactions() {
    _displayedTransactionsMap =
        _transactionsMap.entries.take(_pageSize).toList();
  }

  void _loadMoreTransactions() {
    setState(() {
      _pageSize += 5;
      _updateDisplayedTransactions();
    });
  }
}
