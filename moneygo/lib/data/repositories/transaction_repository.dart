import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/daos/category_dao.dart';
import 'package:moneygo/data/daos/expense_dao.dart';
import 'package:moneygo/data/daos/income_dao.dart';
import 'package:moneygo/data/daos/source_dao.dart';
import 'package:moneygo/data/daos/transaction_dao.dart';
import 'package:moneygo/data/daos/transfer_dao.dart';
import 'package:moneygo/data/models/expense_model.dart';
import 'package:moneygo/data/models/income_model.dart';
import 'package:moneygo/data/models/interfaces/transaction_subtype.dart';
import 'package:moneygo/data/models/transfer_model.dart';
import 'package:moneygo/utils/transaction_types.dart';

class TransactionRepository {
  final TransactionDao _transactionDao;
  final ExpenseDao _expenseDao;
  final IncomeDao _incomeDao;
  final TransferDao _transferDao;
  final SourceDao _sourceDao;
  final CategoryDao _categoryDao;

  TransactionRepository(this._transactionDao, this._expenseDao, this._sourceDao,
      this._categoryDao, this._incomeDao, this._transferDao);

  Stream<List<Transaction>> watchAllTransactions() =>
      _transactionDao.watchAllTransactions();

  Future<Map<Transaction, TransactionType>> getAllTransactions() async {
    var transactions = await _transactionDao.getAllTransactions();

    var transactionsSorted = transactions.toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    var transactionsMap = <Transaction, TransactionType>{};

    for (var transaction in transactionsSorted) {
      if (transaction.type == TransactionTypes.expense) {
        var expense =
            await _expenseDao.getExpenseByTransactionId(transaction.id);

        if (expense == null) continue;

        Source? expenseSource;
        if (expense.sourceId != null) {
          expenseSource = await _sourceDao.getSourceById(expense.sourceId!);
        }

        Category? expenseCategory;
        if (expense.categoryId != null) {
          expenseCategory =
              await _categoryDao.getCategoryById(expense.categoryId!);
        }

        var expenseModel = ExpenseModel(
          id: expense.id,
          transaction: transaction,
          source: expenseSource,
          category: expenseCategory,
        );

        transactionsMap[transaction] = expenseModel;
      } else if (transaction.type == TransactionTypes.income) {
        var income = await _incomeDao.getIncomeByTransactionId(transaction.id);

        if (income == null) continue;

        Source? placedOnsource;

        if (income.placedOnsourceId != null) {
          placedOnsource =
              await _sourceDao.getSourceById(income.placedOnsourceId!);
        }

        var incomeModel = IncomeModel(
          id: income.id,
          transaction: transaction,
          placedOnSource: placedOnsource,
        );

        transactionsMap[transaction] = incomeModel;
      } else if (transaction.type == TransactionTypes.transfer) {
        var transfer =
            await _transferDao.getTransferByTransactionId(transaction.id);

        if (transfer == null) continue;

        Source? fromSource;
        Source? toSource;

        if (transfer.fromSourceId != null) {
          fromSource = await _sourceDao.getSourceById(transfer.fromSourceId!);
        }

        if (transfer.toSourceId != null) {
          toSource = await _sourceDao.getSourceById(transfer.toSourceId!);
        }

        var transferModel = TransferModel(
          id: transfer.id,
          transaction: transaction,
          fromSource: fromSource,
          toSource: toSource,
        );

        transactionsMap[transaction] = transferModel;
      }
    }

    return transactionsMap;
  }

  Future<Transaction?> getTransactionById(int id) async =>
      await _transactionDao.getTransactionById(id);

  Future<TransactionType?> getTransactionRelatedData(int id) async {
    var transaction = await _transactionDao.getTransactionById(id);

    if (transaction == null) return null;

    if (transaction.type == TransactionTypes.expense) {
      var expense = await _expenseDao.getExpenseByTransactionId(id);

      if (expense == null) return null;

      Source? expenseSource;
      if (expense.sourceId != null) {
        expenseSource = await _sourceDao.getSourceById(expense.sourceId!);
      }

      Category? expenseCategory;
      if (expense.categoryId != null) {
        expenseCategory =
            await _categoryDao.getCategoryById(expense.categoryId!);
      }

      return ExpenseModel(
        id: expense.id,
        transaction: transaction,
        source: expenseSource,
        category: expenseCategory,
      );
    } else if (transaction.type == TransactionTypes.income) {
      var income = await _incomeDao.getIncomeByTransactionId(id);

      if (income == null) return null;

      Source? placedOnsource;

      if (income.placedOnsourceId != null) {
        placedOnsource =
            await _sourceDao.getSourceById(income.placedOnsourceId!);
      }

      return IncomeModel(
        id: income.id,
        transaction: transaction,
        placedOnSource: placedOnsource,
      );
    } else if (transaction.type == TransactionTypes.transfer) {
      var transfer = await _transferDao.getTransferByTransactionId(id);

      if (transfer == null) return null;

      Source? fromSource;
      Source? toSource;

      if (transfer.fromSourceId != null) {
        fromSource = await _sourceDao.getSourceById(transfer.fromSourceId!);
      }

      if (transfer.toSourceId != null) {
        toSource = await _sourceDao.getSourceById(transfer.toSourceId!);
      }

      return TransferModel(
        id: transfer.id,
        transaction: transaction,
        fromSource: fromSource,
        toSource: toSource,
      );
    } else {
      return null;
    }
  }

  Future<dynamic> getExpenseByTransactionId(int id) async {
    var expense = await _expenseDao.getExpenseByTransactionId(id);

    if (expense == null) return null;

    Source? expenseSource;
    if (expense.sourceId != null) {
      expenseSource = await _sourceDao.getSourceById(expense.sourceId!);
    }

    Category? expenseCategory;
    if (expense.categoryId != null) {
      expenseCategory = await _categoryDao.getCategoryById(expense.categoryId!);
    }

    return {
      'expense': expense,
      'source': expenseSource,
      'category': expenseCategory,
    };
  }

  Future<int> insertExpenseTransaction(
      TransactionsCompanion transaction, ExpensesCompanion expense) async {
    var transactionId = await _transactionDao.insertTransaction(transaction);

    expense = expense.copyWith(transactionId: Value(transactionId));

    int success = await _expenseDao.insertExpense(expense);

    if (success > 0) {
      Source? source;
      Category? category;

      if (expense.sourceId.value != null) {
        source = await _sourceDao.getSourceById(expense.sourceId.value!);

        if (source != null) {
          source = source.copyWith(
            balance: source.balance - transaction.amount.value,
          );
          await _sourceDao.updateSource(source);
        }
      }

      if (expense.categoryId.value != null) {
        category =
            await _categoryDao.getCategoryById(expense.categoryId.value!);

        if (category != null) {
          category = category.copyWith(
            balance: category.balance - transaction.amount.value,
          );
          await _categoryDao.updateCategory(category);
        }
      }
    }

    return transactionId;
  }

  Future<int> insertIncomeTransaction(
      TransactionsCompanion transaction, IncomesCompanion income) async {
    var transactionId = await _transactionDao.insertTransaction(transaction);

    income = income.copyWith(transactionId: Value(transactionId));

    int success = await _incomeDao.insertIncome(income);

    print(success);

    if (success > 0) {
      Source? source;

      if (income.placedOnsourceId.value != null) {
        source = await _sourceDao.getSourceById(income.placedOnsourceId.value!);

        if (source != null) {
          source = source.copyWith(
            balance: source.balance + transaction.amount.value,
          );
          await _sourceDao.updateSource(source);
        }
      }
    }

    return transactionId;
  }

  Future<int> insertTransferTransaction(
      TransactionsCompanion transaction, TransfersCompanion transfer) async {
    var transactionId = await _transactionDao.insertTransaction(transaction);

    transfer = transfer.copyWith(transactionId: Value(transactionId));

    int success = await _transferDao.insertTransfer(transfer);

    if (success > 0) {
      Source? fromSource;
      Source? toSource;

      if (transfer.fromSourceId.value != null) {
        fromSource =
            await _sourceDao.getSourceById(transfer.fromSourceId.value!);

        if (fromSource != null) {
          fromSource = fromSource.copyWith(
            balance: fromSource.balance - transaction.amount.value,
          );
          await _sourceDao.updateSource(fromSource);
        }
      }

      if (transfer.toSourceId.value != null) {
        toSource = await _sourceDao.getSourceById(transfer.toSourceId.value!);

        if (toSource != null) {
          toSource = toSource.copyWith(
            balance: toSource.balance + transaction.amount.value,
          );
          await _sourceDao.updateSource(toSource);
        }
      }
    }

    return transactionId;
  }

  Future<bool> updateTransaction(Transaction transaction) async =>
      await _transactionDao.updateTransaction(transaction);
}
