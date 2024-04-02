import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/models/budget/transaction_subtype.dart';

class TransferModel implements TransactionType {
  int id;
  double updatedBalanceFromSource;
  double updatedBalanceToSource;
  Transaction transaction;
  Source fromSource;
  Source toSource;

  TransferModel({
    required this.id,
    required this.updatedBalanceFromSource,
    required this.updatedBalanceToSource,
    required this.transaction,
    required this.fromSource,
    required this.toSource,
  });

  TransferModel copyWith({
    int? id,
    double? updatedBalanceFromSource,
    double? updatedBalanceToSource,
    Transaction? transaction,
    Source? fromSource,
    Source? toSource,
  }) {
    return TransferModel(
      id: id ?? this.id,
      updatedBalanceFromSource:
          updatedBalanceFromSource ?? this.updatedBalanceFromSource,
      updatedBalanceToSource:
          updatedBalanceToSource ?? this.updatedBalanceToSource,
      transaction: transaction ?? this.transaction,
      fromSource: fromSource ?? this.fromSource,
      toSource: toSource ?? this.toSource,
    );
  }

  @override
  String toString() {
    return 'TransferModel{id: $id, updatedBalanceFromSource: $updatedBalanceFromSource, updatedBalanceToSource: $updatedBalanceToSource, transaction: $transaction, fromSource: $fromSource, toSource: $toSource}';
  }
}
