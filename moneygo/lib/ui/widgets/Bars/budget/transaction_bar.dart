import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/blocs/settings/settings_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_event.dart';
import 'package:moneygo/data/blocs/settings/settings_state.dart';
import 'package:moneygo/data/models/budget/expense_model.dart';
import 'package:moneygo/data/models/budget/income_model.dart';
import 'package:moneygo/data/models/budget/transaction_subtype.dart';
import 'package:moneygo/data/models/budget/transfer_model.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';
import 'package:moneygo/utils/enums.dart';
import 'package:moneygo/utils/utils.dart';

class TransactionBar extends StatefulWidget {
  final Transaction transaction;
  final TransactionType transactionType;
  final String? previousRoute;

  const TransactionBar(
      {super.key,
      required this.transaction,
      required this.transactionType,
      this.previousRoute});

  @override
  State<TransactionBar> createState() => _TransactionBarState();
}

class _TransactionBarState extends State<TransactionBar> {
  String _currency = '\$';

  @override
  void initState() {
    super.initState();

    BlocProvider.of<SettingsBloc>(context).add(LoadSettings());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoaded) {
          _currency = state.settings["currency"] ?? "\$";
        }

        return InkWell(
          onTap: () {
            _showDetailsDialog(context);
          },
          onLongPress: () {
            if (widget.transactionType is ExpenseModel) {
              Navigator.pushNamed(context, '/expense/edit', arguments: {
                'transaction': widget.transaction,
                'expense': widget.transactionType,
                'previousRoute': widget.previousRoute
              });
            } else if (widget.transactionType is IncomeModel) {
              Navigator.pushNamed(context, '/income/edit', arguments: {
                'transaction': widget.transaction,
                'income': widget.transactionType,
                'previousRoute': widget.previousRoute
              });
            } else if (widget.transactionType is TransferModel) {
              Navigator.pushNamed(context, '/transfer/edit', arguments: {
                'transaction': widget.transaction,
                'transfer': widget.transactionType,
                'previousRoute': widget.previousRoute
              });
            }
          },
          splashColor: CustomColorScheme.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 11, 10, 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.transaction.title.length > 15
                          ? '${widget.transaction.title.substring(0, 15)}...'
                          : widget.transaction.title,
                      style: CustomTextStyleScheme.barLabelSmall,
                    ),
                    // Date in MMM dd, yyyy format
                    Text(
                      Utils.getFormattedDateFull(widget.transaction.date),
                      style: CustomTextStyleScheme.progressBarText,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          _getSign(widget.transaction) ?? '',
                          style: CustomTextStyleScheme.barLabel.copyWith(
                              color: _getColor(
                                  widget.transaction, widget.transactionType)),
                        ),
                        Text(
                          _currency,
                          style: CustomTextStyleScheme.barLabel.copyWith(
                              color: _getColor(
                                  widget.transaction, widget.transactionType),
                              fontFamily: CustomTextStyleScheme
                                  .barBalancePeso.fontFamily),
                        ),
                        Text(
                            Utils.formatNumber(widget.transaction.amount.abs()),
                            style: CustomTextStyleScheme.barLabel.copyWith(
                              color: _getColor(
                                  widget.transaction, widget.transactionType),
                            )),
                      ],
                    ),
                    Text(
                      _getDescription(widget.transaction,
                                      widget.transactionType)
                                  .length >
                              15
                          ? '${_getDescription(widget.transaction, widget.transactionType).substring(0, 15)}...'
                          : _getDescription(
                              widget.transaction, widget.transactionType),
                      style: CustomTextStyleScheme.progressBarText,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
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
      String sourceName = transactionType.source.name;
      String categoryName = transactionType.category?.name ?? "";

      description = transaction.amount > 0
          ? "$categoryName using $sourceName"
          : categoryName.isEmpty
              ? "Refund to $sourceName"
              : "Refund for $categoryName to $sourceName";
    } else if (transactionType is IncomeModel) {
      String placedOnSourceText = transactionType.placedOnSource.name;

      description = "To $placedOnSourceText";
    } else if (transactionType is TransferModel) {
      String fromSourceName = transactionType.fromSource.name;
      String toSourceName = transactionType.toSource.name;

      description = "$fromSourceName to $toSourceName";
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

  Widget _getUpdatedBalanceWidget(TransactionType transactionType) {
    if (transactionType is ExpenseModel) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Updated Balance:',
            style: CustomTextStyleScheme.dialogBodySmall,
          ),
          Text(
            '$_currency${Utils.formatNumber(transactionType.updatedBalance)}',
            style: CustomTextStyleScheme.dialogBodySmall,
          ),
        ],
      );
    } else if (transactionType is IncomeModel) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Updated Balance:',
            style: CustomTextStyleScheme.dialogBodySmall,
          ),
          Text(
            '$_currency${Utils.formatNumber(transactionType.updatedBalance)}',
            style: CustomTextStyleScheme.dialogBodySmall,
          ),
        ],
      );
    } else if (transactionType is TransferModel) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Updated Balance(From):',
                style: CustomTextStyleScheme.dialogBodySmall,
              ),
              Text(
                '$_currency${Utils.formatNumber(transactionType.updatedBalanceFromSource)}',
                style: CustomTextStyleScheme.dialogBodySmall,
              ),
            ],
          ),
          const SizedBox(width: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Updated Balance(To):',
                style: CustomTextStyleScheme.dialogBodySmall,
              ),
              Text(
                '$_currency${Utils.formatNumber(transactionType.updatedBalanceToSource)}',
                style: CustomTextStyleScheme.dialogBodySmall,
              ),
            ],
          ),
        ],
      );
    }

    return const SizedBox();
  }

  void _showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          titlePadding: const EdgeInsets.all(0.0),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          buttonPadding: const EdgeInsets.all(0.0),
          title: Container(
            decoration: BoxDecoration(
              color: _getColor(widget.transaction, widget.transactionType),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 15.0),
                Center(
                    child: Text(widget.transaction.title,
                        style: CustomTextStyleScheme.dialogTitleSmall)),
                const SizedBox(height: 15.0),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        _getDescription(
                            widget.transaction, widget.transactionType),
                        style: CustomTextStyleScheme.dialogBodySmall
                            .copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Divider(
                color: CustomColorScheme.backgroundColor,
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Date and Time:',
                        style: CustomTextStyleScheme.dialogBodySmall),
                    Text(
                        Utils.getFormattedDateAndTimeWithAMPM(
                            widget.transaction.date),
                        style: CustomTextStyleScheme.dialogBodySmall),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Amount:',
                        style: CustomTextStyleScheme.dialogBodySmall),
                    Text(
                        '${_getSign(widget.transaction) ?? ''} $_currency${Utils.formatNumber(widget.transaction.amount.abs())}',
                        style: CustomTextStyleScheme.dialogBodySmall),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              _getUpdatedBalanceWidget(widget.transactionType),
              const Divider(
                color: CustomColorScheme.backgroundColor,
              ),
              if (widget.transaction.description != null &&
                  widget.transaction.description!.isNotEmpty)
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 100),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.transaction.description!,
                            softWrap: true,
                            style: CustomTextStyleScheme.dialogBodySmall),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
