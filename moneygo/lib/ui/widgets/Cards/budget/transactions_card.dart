import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/blocs/transactions/transaction_bloc.dart';
import 'package:moneygo/data/blocs/transactions/transaction_event.dart';
import 'package:moneygo/data/blocs/transactions/transaction_state.dart';
import 'package:moneygo/data/models/budget/interfaces/transaction_subtype.dart';
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
            const Text(
              'Transactions',
              textAlign: TextAlign.left,
              style: CustomTextStyleScheme.cardTitle,
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
                  if (_displayedTransactionsMap.length <
                      _transactionsMap.length)
                    InkWell(
                      onTap: _loadMoreTransactions,
                      child: SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: IconButton(
                            onPressed: _loadMoreTransactions,
                            icon: const Icon(Icons.arrow_drop_down),
                          ),
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
