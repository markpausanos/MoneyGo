import 'package:equatable/equatable.dart';
import 'package:moneygo/data/app_database.dart';

abstract class TransactionEvent extends Equatable {
  @override
  List<Object> get props => [];

  const TransactionEvent();
}

class LoadTransactions extends TransactionEvent {}

class AddExpenseTransaction extends TransactionEvent {
  final TransactionsCompanion transaction;
  final ExpensesCompanion expense;

  const AddExpenseTransaction(this.transaction, this.expense);

  @override
  List<Object> get props => [transaction, expense];
}

class AddIncomeTransaction extends TransactionEvent {
  final TransactionsCompanion transaction;
  final IncomesCompanion income;

  const AddIncomeTransaction(this.transaction, this.income);

  @override
  List<Object> get props => [transaction, income];
}

class AddTransferTransaction extends TransactionEvent {
  final TransactionsCompanion transaction;
  final TransfersCompanion transfer;

  const AddTransferTransaction(this.transaction, this.transfer);

  @override
  List<Object> get props => [transaction, transfer];
}

class UpdateTransaction extends TransactionEvent {
  final Transaction transaction;

  const UpdateTransaction(this.transaction);

  @override
  List<Object> get props => [transaction];
}
