import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/blocs/transactions/transaction_event.dart';
import 'package:moneygo/data/blocs/transactions/transaction_state.dart';
import 'package:moneygo/data/repositories/transaction_repository.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository transactionRepository;

  TransactionBloc({required this.transactionRepository})
      : super(TransactionsLoading()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddExpenseTransaction>(_onAddTransactionExpense);
    on<AddIncomeTransaction>(_onAddTransactionIncome);
    on<AddTransferTransaction>(_onAddTransactionTransfer);
    on<UpdateTransaction>(_onUpdateTransaction);
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

  void _onAddTransactionExpense(
      AddExpenseTransaction event, Emitter<TransactionState> emit) async {
    try {
      await transactionRepository.insertExpenseTransaction(
          event.transaction, event.expense);
      final transactions = await transactionRepository.getAllTransactions();

      emit(TransactionsSaveSuccess());
      emit(TransactionsLoaded(transactions));
    } catch (e) {
      emit(TransactionsError(e.toString()));
    }
  }

  void _onAddTransactionIncome(
      AddIncomeTransaction event, Emitter<TransactionState> emit) async {
    try {
      await transactionRepository.insertIncomeTransaction(
          event.transaction, event.income);
      final transactions = await transactionRepository.getAllTransactions();

      emit(TransactionsSaveSuccess());
      emit(TransactionsLoaded(transactions));
    } catch (e) {
      emit(TransactionsError(e.toString()));
    }
  }

  void _onAddTransactionTransfer(
      AddTransferTransaction event, Emitter<TransactionState> emit) async {
    try {
      await transactionRepository.insertTransferTransaction(
          event.transaction, event.transfer);
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
      await transactionRepository.updateTransaction(event.transaction);
      final transactions = await transactionRepository.getAllTransactions();
      emit(TransactionsUpdateSuccess());
      emit(TransactionsLoaded(transactions));
    } catch (e) {
      emit(TransactionsError(e.toString()));
    }
  }
}
