import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/models/interfaces/transaction_subtype.dart';

class TransferModel implements TransactionType {
  int id;
  Transaction transaction;
  Source fromSource;
  Source toSource;

  TransferModel({
    required this.id,
    required this.transaction,
    required this.fromSource,
    required this.toSource,
  });

  TransferModel copyWith({
    int? id,
    Transaction? transaction,
    Source? fromSource,
    Source? toSource,
  }) {
    return TransferModel(
      id: id ?? this.id,
      transaction: transaction ?? this.transaction,
      fromSource: fromSource ?? this.fromSource,
      toSource: toSource ?? this.toSource,
    );
  }

  @override
  String toString() {
    return 'TransferModel{id: $id, transaction: $transaction, fromSource: $fromSource, toSource: $toSource}';
  }
}
