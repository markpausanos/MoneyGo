import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/blocs/budget/transactions/transaction_event.dart';
import 'package:moneygo/data/blocs/budget/transactions/transaction_state.dart';
import 'package:moneygo/data/repositories/budget/transaction_repository.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository transactionRepository;

  TransactionBloc({required this.transactionRepository})
      : super(TransactionsLoading()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<DeleteTransactionBySource>(_onDeleteTransactionBySource);
  }

  void _onLoadTransactions(
      LoadTransactions event, Emitter<TransactionState> emit) async {
    try {
      final transactions = await transactionRepository.getAllTransactions();
      emit(TransactionsLoaded(transactions));
    } catch (e) {
      emit(TransactionsError(e.toString()));
    }
  }

  void _onAddTransaction(
      AddTransaction event, Emitter<TransactionState> emit) async {
    try {
      if (event.transactionType == null) {
        emit(TransactionsError('Transaction type is required'));
        return;
      }
      if (event.transactionType is! ExpensesCompanion &&
          event.transactionType is! IncomesCompanion &&
          event.transactionType is! TransfersCompanion) {
        emit(TransactionsError('Invalid transaction type'));
        return;
      }
      await transactionRepository.insertTransaction(
          event.transaction, event.transactionType);

      final transactions = await transactionRepository.getAllTransactions();

      emit(TransactionsSaveSuccess());
      emit(TransactionsLoaded(transactions));
    } catch (e) {
      emit(TransactionsError(e.toString()));
    }
  }

  void _onUpdateTransaction(
      UpdateTransaction event, Emitter<TransactionState> emit) async {
    try {
      await transactionRepository.updateTransaction(
          event.transaction, event.transactionType);
      final transactions = await transactionRepository.getAllTransactions();
      emit(TransactionsUpdateSuccess());
      emit(TransactionsLoaded(transactions));
    } catch (e) {
      emit(TransactionsError(e.toString()));
    }
  }

  void _onDeleteTransaction(
      DeleteTransaction event, Emitter<TransactionState> emit) async {
    try {
      await transactionRepository.deleteTransaction(event.transaction);
      final transactions = await transactionRepository.getAllTransactions();
      add(LoadTransactions());
      emit(TransactionsDeleteSuccess(0));
      emit(TransactionsLoaded(transactions));
    } catch (e) {
      emit(TransactionsError(e.toString()));
    }
  }

  void _onDeleteTransactionBySource(
      DeleteTransactionBySource event, Emitter<TransactionState> emit) async {
    try {
      await transactionRepository.deleteTransactionsBySourceId(event.sourceId);
      final transactions = await transactionRepository.getAllTransactions();
      add(LoadTransactions());
      emit(TransactionsDeleteSuccess(event.sourceId));
      emit(TransactionsLoaded(transactions));
    } catch (e) {
      emit(TransactionsError(e.toString()));
    }
  }
}
