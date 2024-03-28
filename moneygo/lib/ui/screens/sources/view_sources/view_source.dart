import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/blocs/settings/settings_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_event.dart';
import 'package:moneygo/data/blocs/settings/settings_state.dart';
import 'package:moneygo/data/blocs/transactions/transaction_bloc.dart';
import 'package:moneygo/data/blocs/transactions/transaction_event.dart';
import 'package:moneygo/data/blocs/transactions/transaction_state.dart';
import 'package:moneygo/data/models/expense_model.dart';
import 'package:moneygo/data/models/income_model.dart';
import 'package:moneygo/data/models/interfaces/transaction_subtype.dart';
import 'package:moneygo/data/models/transfer_model.dart';
import 'package:moneygo/ui/widgets/Bars/transaction_bar.dart';
import 'package:moneygo/ui/widgets/IconButton/large_icon_button.dart';
import 'package:moneygo/ui/widgets/Loaders/loading_state.dart';
import 'package:moneygo/ui/widgets/SizedBoxes/dashed_box_with_message.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';
import 'package:moneygo/utils/utils.dart';

class ViewSourceScreen extends StatefulWidget {
  final Source source;
  const ViewSourceScreen({super.key, required this.source});

  @override
  State<ViewSourceScreen> createState() => _ViewSourceScreenState();
}

class _ViewSourceScreenState extends State<ViewSourceScreen> {
  String _currency = '\$';

  @override
  void initState() {
    super.initState();

    BlocProvider.of<SettingsBloc>(context).add(LoadSettings());
    BlocProvider.of<TransactionBloc>(context).add(LoadTransactions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColorScheme.appBarCards,
          leading: IconButtonLarge(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icons.arrow_back,
              color: Colors.white),
          title: Text(widget.source.name,
              style: CustomTextStyleScheme.appBarTitleCards),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: CustomColorScheme.appBlue,
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.fromLTRB(40, 5, 40, 5),
                        decoration: BoxDecoration(
                          color: CustomColorScheme.appBlueLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Balance',
                          style: CustomTextStyleScheme.viewBalanceNameText,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BlocBuilder<SettingsBloc, SettingsState>(
                            builder: (context, state) {
                              if (state is SettingsLoaded) {
                                _currency = state.settings['currency'] ?? '\$';
                                return Text(
                                  _currency,
                                  style: CustomTextStyleScheme
                                      .viewBalanceAmountCurrency,
                                );
                              }
                              return Text(
                                _currency,
                                style: CustomTextStyleScheme
                                    .viewBalanceAmountCurrency,
                              );
                            },
                          ),
                          Text(
                            Utils.formatNumber(widget.source.balance),
                            style: CustomTextStyleScheme.viewBalanceAmountText,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              BlocBuilder<TransactionBloc, TransactionState>(
                  builder: (context, state) {
                if (state is TransactionsLoading) {
                  return const Center(child: Loader());
                } else if (state is TransactionsLoaded) {
                  var transactions = Map.from(state.transactions);

                  transactions.removeWhere((key, value) {
                    if (value is ExpenseModel) {
                      return value.source.id != widget.source.id;
                    } else if (value is IncomeModel) {
                      return value.placedOnSource.id != widget.source.id;
                    } else if (value is TransferModel) {
                      return value.fromSource.id != widget.source.id &&
                          value.toSource.id != widget.source.id;
                    }
                    return false;
                  });

                  if (transactions.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.fromLTRB(20, 8, 20, 10),
                      child:
                          DashedWidgetWithMessage(message: 'No transactions'),
                    );
                  }

                  Map<DateTime, Map<Transaction, TransactionType>>
                      transactionsMap = {};

                  for (Transaction transaction in transactions.keys) {
                    DateTime date = DateTime(
                        transaction.date.year,
                        transaction.date.month,
                        transaction.date.day,
                        0,
                        0,
                        0,
                        0,
                        0);
                    if (!transactionsMap.containsKey(date)) {
                      transactionsMap[date] = {};
                    }
                    transactionsMap[date]![transaction] =
                        transactions[transaction]!;
                  }

                  return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
                      child: SingleChildScrollView(
                          child: Column(
                              children: transactionsMap.keys.map((date) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // const Expanded(
                                //   child: Divider(
                                //     color: CustomColorScheme.backgroundColor,
                                //   ),
                                // ),
                                Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    decoration: BoxDecoration(
                                        color: CustomColorScheme.appBlueLight,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Center(
                                      child: Text(
                                          Utils.getFormattedDateFull(date),
                                          style: CustomTextStyleScheme
                                              .transactionBarDate),
                                    )),
                                const Expanded(
                                  child: Divider(
                                    color: CustomColorScheme.backgroundColor,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            Column(
                                children: transactionsMap[date]!
                                    .keys
                                    .map((transaction) {
                              final transactionType =
                                  transactionsMap[date]![transaction]!;

                              return Column(
                                children: [
                                  TransactionBar(
                                    transaction: transaction,
                                    transactionType: transactionType,
                                  ),
                                ],
                              );
                            }).toList()),
                            const SizedBox(height: 10),
                          ],
                        );
                      }).toList())));
                } else {
                  return const Center(child: Loader());
                }
              }),
            ],
          ),
        ));
  }
}
