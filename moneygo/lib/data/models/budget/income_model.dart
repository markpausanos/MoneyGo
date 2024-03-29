import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/models/budget/interfaces/transaction_subtype.dart';

class IncomeModel implements TransactionType {
  int id;
  Transaction transaction;
  Source placedOnSource;

  IncomeModel({
    required this.id,
    required this.transaction,
    required this.placedOnSource,
  });

  IncomeModel copyWith({
    int? id,
    Transaction? transaction,
    Source? placedOnSource,
  }) {
    return IncomeModel(
      id: id ?? this.id,
      transaction: transaction ?? this.transaction,
      placedOnSource: placedOnSource ?? this.placedOnSource,
    );
  }

  @override
  String toString() {
    return 'IncomeModel{id: $id, transaction: $transaction, placedOnSource: $placedOnSource}';
  }
}
