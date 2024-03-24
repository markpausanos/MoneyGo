import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/blocs/settings/settings_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_event.dart';
import 'package:moneygo/data/blocs/settings/settings_state.dart';
import 'package:moneygo/data/models/expense_model.dart';
import 'package:moneygo/data/models/income_model.dart';
import 'package:moneygo/data/models/interfaces/transaction_subtype.dart';
import 'package:moneygo/data/models/transfer_model.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';
import 'package:moneygo/utils/transaction_types.dart';
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
          borderRadius: BorderRadius.circular(10),
          splashColor: CustomColorScheme.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 63,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.transaction.title,
                              style: CustomTextStyleScheme.barLabel,
                            ),
                            // Date in MMM dd, yyyy format
                            Text(
                              Utils.getFormattedDateFull(
                                  widget.transaction.date),
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
                                  style: CustomTextStyleScheme.barLabel
                                      .copyWith(
                                          color: _getColor(widget.transaction,
                                              widget.transactionType)),
                                ),
                                Text(
                                  _currency,
                                  style: CustomTextStyleScheme.barLabel
                                      .copyWith(
                                          color: _getColor(widget.transaction,
                                              widget.transactionType),
                                          fontFamily: CustomTextStyleScheme
                                              .barBalancePeso.fontFamily),
                                ),
                                Text(
                                    Utils.formatNumber(
                                        widget.transaction.amount),
                                    style:
                                        CustomTextStyleScheme.barLabel.copyWith(
                                      color: _getColor(widget.transaction,
                                          widget.transactionType),
                                    )),
                              ],
                            ),
                            Text(
                              _getDescription(widget.transaction,
                                              widget.transactionType)
                                          .length >
                                      20
                                  ? '${_getDescription(widget.transaction, widget.transactionType).substring(0, 20)}...'
                                  : _getDescription(widget.transaction,
                                      widget.transactionType),
                              style: CustomTextStyleScheme.progressBarText,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
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
      String sourceName = transactionType.source?.name ?? "";
      String categoryName = transactionType.category?.name ?? "";

      description = transaction.amount > 0
          ? "$categoryName using $sourceName"
          : "Refund for $categoryName to $sourceName";
    } else if (transactionType is IncomeModel) {
      String placedOnSourceText =
          transactionType.placedOnSource?.name ?? "Inexistent Source";

      description = "To $placedOnSourceText";
    } else if (transactionType is TransferModel) {
      String fromSourceName =
          transactionType.fromSource?.name ?? "Inexistent Source";
      String toSourceName =
          transactionType.toSource?.name ?? "Inexistent Source";

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
}
