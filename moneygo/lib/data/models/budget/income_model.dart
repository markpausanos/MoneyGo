import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/models/budget/transaction_subtype.dart';

class IncomeModel implements TransactionType {
  int id;
  double updatedBalance;
  Transaction transaction;
  Source placedOnSource;

  IncomeModel({
    required this.id,
    required this.updatedBalance,
    required this.transaction,
    required this.placedOnSource,
  });

  IncomeModel copyWith({
    int? id,
    double? updatedBalance,
    Transaction? transaction,
    Source? placedOnSource,
  }) {
    return IncomeModel(
      id: id ?? this.id,
      updatedBalance: updatedBalance ?? this.updatedBalance,
      transaction: transaction ?? this.transaction,
      placedOnSource: placedOnSource ?? this.placedOnSource,
    );
  }

  @override
  String toString() {
    return 'IncomeModel{id: $id, updatedBalance: $updatedBalance, transaction: $transaction, placedOnSource: $placedOnSource}';
  }
}
