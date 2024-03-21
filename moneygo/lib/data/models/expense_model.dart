import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/models/interfaces/transaction_subtype.dart';

class ExpenseModel implements TransactionType {
  final int id;
  final Transaction transaction;
  final Source? source;
  final Category? category;

  ExpenseModel({
    required this.id,
    required this.transaction,
    this.source,
    this.category,
  });

  ExpenseModel copyWith({
    int? id,
    Transaction? transaction,
    Source? source,
    Category? category,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      transaction: transaction ?? this.transaction,
      source: source ?? this.source,
      category: category ?? this.category,
    );
  }

  @override
  String toString() {
    return 'ExpenseModel{id: $id, transaction: $transaction, source: $source, category: $category}';
  }
}
