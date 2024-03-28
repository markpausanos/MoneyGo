import 'package:equatable/equatable.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/models/interfaces/transaction_subtype.dart';

abstract class TransactionState extends Equatable {
  @override
  List<Object> get props => [];
}

class TransactionsLoading extends TransactionState {}

class TransactionsLoaded extends TransactionState {
  final Map<Transaction, TransactionType> transactions;

  TransactionsLoaded(this.transactions);

  @override
  List<Object> get props => [transactions];
}

class TransactionsBySourceLoaded extends TransactionState {
  final Map<Transaction, TransactionType> transactions;

  TransactionsBySourceLoaded(this.transactions);

  @override
  List<Object> get props => [transactions];
}

class TransactionsError extends TransactionState {
  final String message;

  TransactionsError(this.message);

  @override
  List<Object> get props => [message];
}

class TransactionsSaveSuccess extends TransactionState {}

class TransactionsUpdateSuccess extends TransactionState {}

class TransactionsDeleteSuccess extends TransactionState {
  final int sourceId;

  TransactionsDeleteSuccess(this.sourceId);

  @override
  List<Object> get props => [sourceId];
}
