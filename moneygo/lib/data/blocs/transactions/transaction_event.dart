import 'package:equatable/equatable.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/models/budget/transaction_subtype.dart';

abstract class TransactionEvent extends Equatable {
  @override
  List<Object> get props => [];

  const TransactionEvent();
}

class LoadTransactions extends TransactionEvent {}

class AddTransaction extends TransactionEvent {
  final TransactionsCompanion transaction;
  final dynamic transactionType;

  const AddTransaction(this.transaction, this.transactionType);

  @override
  List<Object> get props => [transaction];
}

class UpdateTransaction extends TransactionEvent {
  final Transaction transaction;
  final TransactionType transactionType;

  const UpdateTransaction(this.transaction, this.transactionType);

  @override
  List<Object> get props => [transaction];
}

class DeleteTransaction extends TransactionEvent {
  final Transaction transaction;

  const DeleteTransaction(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class DeleteTransactionBySource extends TransactionEvent {
  final int sourceId;

  const DeleteTransactionBySource(this.sourceId);

  @override
  List<Object> get props => [sourceId];
}
