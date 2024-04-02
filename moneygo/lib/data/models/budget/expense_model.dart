import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/models/budget/transaction_subtype.dart';

class ExpenseModel implements TransactionType {
  int id;
  double updatedBalance;
  Transaction transaction;
  Source source;
  Category? category;

  ExpenseModel({
    required this.id,
    required this.updatedBalance,
    required this.transaction,
    required this.source,
    this.category,
  });

  ExpenseModel copyWith({
    int? id,
    double? updatedBalance,
    Transaction? transaction,
    Source? source,
    Category? category,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      updatedBalance: updatedBalance ?? this.updatedBalance,
      transaction: transaction ?? this.transaction,
      source: source ?? this.source,
      category: category,
    );
  }

  @override
  String toString() {
    return 'ExpenseModel{id: $id, updatedBalance: $updatedBalance, transaction: $transaction, source: $source, category: $category}';
  }
}
