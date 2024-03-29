import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/blocs/backups/backup_bloc.dart';
import 'package:moneygo/data/blocs/backups/backup_event.dart';
import 'package:moneygo/data/blocs/backups/backup_state.dart';
import 'package:moneygo/data/blocs/transactions/transaction_bloc.dart';
import 'package:moneygo/data/blocs/transactions/transaction_event.dart';
import 'package:moneygo/data/blocs/transactions/transaction_state.dart';
import 'package:moneygo/data/models/budget/interfaces/transaction_subtype.dart';
import 'package:moneygo/ui/widgets/Bars/budget/transaction_bar.dart';
import 'package:moneygo/ui/widgets/IconButton/large_icon_button.dart';
import 'package:moneygo/ui/widgets/Loaders/loading_state.dart';
import 'package:moneygo/ui/widgets/SizedBoxes/dashed_box_with_message.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';
import 'package:moneygo/utils/utils.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<TransactionBloc>(context).add(LoadTransactions());
    BlocProvider.of<BackupBloc>(context).add(LoadBackups());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomColorScheme.appBarCards,
        leading: IconButtonLarge(
            onPressed: () => Navigator.popAndPushNamed(context, "/home"),
            icon: Icons.arrow_back,
            color: Colors.white),
        title: const Text('Transactions',
            style: CustomTextStyleScheme.appBarTitleCards),
        centerTitle: true,
        actions: [
          BlocBuilder<BackupBloc, BackupState>(builder: (context, state) {
            if (state is BackupLoaded) {
              if (state.backups.isEmpty) {
                return const SizedBox();
              }
              return IconButtonLarge(
                  onPressed: () => _showBackupDropdown(context, state.backups),
                  icon: Icons.backup,
                  color: Colors.white);
            } else if (state is BackupRestoreSuccess) {
              SystemNavigator.pop();
              return const Loader();
            } else if (state is BackupError) {
              return const Loader();
            } else {
              return const Loader();
            }
          }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 0),
        child: BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
          if (state is TransactionsLoading) {
            return const Center(child: Loader());
          } else if (state is TransactionsLoaded) {
            Map<DateTime, Map<Transaction, TransactionType>> transactionsMap =
                {};
            Map<Transaction, TransactionType> transactions = state.transactions;

            for (Transaction transaction in transactions.keys) {
              DateTime date = DateTime(transaction.date.year,
                  transaction.date.month, transaction.date.day, 0, 0, 0, 0, 0);
              if (!transactionsMap.containsKey(date)) {
                transactionsMap[date] = {};
              }
              transactionsMap[date]![transaction] = transactions[transaction]!;
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 10),
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
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: Text(Utils.getFormattedDateFull(date),
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
                            children:
                                transactionsMap[date]!.keys.map((transaction) {
                          final transactionType =
                              transactionsMap[date]![transaction]!;

                          return Column(
                            children: [
                              TransactionBar(
                                transaction: transaction,
                                transactionType: transactionType,
                                previousRoute: "/transactions",
                              ),
                            ],
                          );
                        }).toList()),
                        const SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          } else {
            return const DashedWidgetWithMessage(
                message: "Error loading transactions");
          }
        }),
      ),
    );
  }

  void _showBackupDropdown(BuildContext context, List<String> backups) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Backups'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: backups.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                      // Convert to date, where it is in format YYYYMMDD. Add a - after four chars and another - after the next two chars
                      "${backups[index].substring(0, 4)}-${backups[index].substring(4, 6)}-${backups[index].substring(6, 8)}"),
                  onTap: () {
                    BlocProvider.of<BackupBloc>(context)
                        .add(RestoreBackup(backups[index]));
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
