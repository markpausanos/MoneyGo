import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/daos/category_dao.dart';
import 'package:moneygo/data/daos/expense_dao.dart';
import 'package:moneygo/data/daos/income_dao.dart';
import 'package:moneygo/data/daos/period_dao.dart';
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
  final PeriodDao _periodDao;

  TransactionRepository(this._transactionDao, this._expenseDao, this._sourceDao,
      this._categoryDao, this._incomeDao, this._transferDao, this._periodDao);

  Stream<List<Transaction>> watchAllTransactions() =>
      _transactionDao.watchAllTransactions();

  Future<Map<Transaction, TransactionType>> getAllTransactions() async {
    var transactions = await _transactionDao.getAllTransactions();

    var transactionsSorted = transactions.toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    var transactionsMap = <Transaction, TransactionType>{};

    for (var transaction in transactionsSorted) {
      print(transaction);
      switch (transaction.type) {
        case TransactionTypes.expense:
          var expenseModel = await _getExpenseModelByTransaction(transaction);
          if (expenseModel != null) {
            transactionsMap[transaction] = expenseModel;
          }
          break;
        case TransactionTypes.income:
          var incomeModel = await _getIncomeModelByTransaction(transaction);
          if (incomeModel != null) {
            transactionsMap[transaction] = incomeModel;
          }
          break;
        case TransactionTypes.transfer:
          var transferModel = await _getTransferModelByTransaction(transaction);
          if (transferModel != null) {
            transactionsMap[transaction] = transferModel;
          }
          break;
      }
    }

    return transactionsMap;
  }

  Future<ExpenseModel?> _getExpenseModelByTransaction(
      Transaction transaction) async {
    var expense = await _expenseDao.getExpenseByTransactionId(transaction.id);

    if (expense == null) {
      await _transactionDao.deleteTransactionById(transaction.id);
      return null;
    }

    Source? expenseSource = await _sourceDao.getSourceById(expense.sourceId);

    if (expenseSource == null) return null;

    Category? expenseCategory;
    if (expense.categoryId != null) {
      expenseCategory = await _categoryDao.getCategoryById(expense.categoryId!);
    }

    return ExpenseModel(
      id: expense.id,
      transaction: transaction,
      source: expenseSource,
      category: expenseCategory,
    );
  }

  Future<IncomeModel?> _getIncomeModelByTransaction(
      Transaction transaction) async {
    var income = await _incomeDao.getIncomeByTransactionId(transaction.id);

    if (income == null) {
      await _transactionDao.deleteTransactionById(transaction.id);

      return null;
    }

    Source? placedOnsource =
        await _sourceDao.getSourceById(income.placedOnsourceId);

    if (placedOnsource == null) return null;

    return IncomeModel(
      id: income.id,
      transaction: transaction,
      placedOnSource: placedOnsource,
    );
  }

  Future<TransferModel?> _getTransferModelByTransaction(
      Transaction transaction) async {
    var transfer =
        await _transferDao.getTransferByTransactionId(transaction.id);

    if (transfer == null) {
      await _transactionDao.deleteTransactionById(transaction.id);
      return null;
    }

    Source? fromSource = await _sourceDao.getSourceById(transfer.fromSourceId);
    Source? toSource = await _sourceDao.getSourceById(transfer.toSourceId);

    if (fromSource == null || toSource == null) return null;

    return TransferModel(
      id: transfer.id,
      transaction: transaction,
      fromSource: fromSource,
      toSource: toSource,
    );
  }

  Future<Transaction?> getTransactionById(int id) async =>
      await _transactionDao.getTransactionById(id);

  Future<int> insertTransaction(
      TransactionsCompanion transaction, dynamic typeCompanion) async {
    switch (transaction.type.value) {
      case TransactionTypes.expense:
        var expense = typeCompanion as ExpensesCompanion;
        return await _insertExpenseTransaction(transaction, expense);
      case TransactionTypes.income:
        var income = typeCompanion as IncomesCompanion;
        return await _insertIncomeTransaction(transaction, income);
      case TransactionTypes.transfer:
        var transfer = typeCompanion as TransfersCompanion;
        return await _insertTransferTransaction(transaction, transfer);
      default:
        break;
    }

    return -1;
  }

  Future<int> _insertExpenseTransaction(
      TransactionsCompanion transaction, ExpensesCompanion expense) async {
    var transactionId = await _transactionDao.insertTransaction(transaction);

    expense = expense.copyWith(transactionId: Value(transactionId));

    Source? source;
    Category? category;

    source = await _sourceDao.getSourceById(expense.sourceId.value);

    if (source != null) {
      source = source.copyWith(
        balance: source.balance - transaction.amount.value,
      );
      await _sourceDao.updateSource(source);
    }

    if (expense.categoryId.value != null) {
      category = await _categoryDao.getCategoryById(expense.categoryId.value!);

      if (category != null) {
        Period? period = await _periodDao.getPeriodById(category.periodId);

        if (period != null) {
          // Check if the transaction date is within the period

          if (transaction.date.value.isAfter(period.startDate) &&
              (period.endDate == null ||
                  transaction.date.value.isBefore(period.endDate!))) {
            category = category.copyWith(
              balance: category.balance - transaction.amount.value,
            );
            await _categoryDao.updateCategory(category);

            expense = expense.copyWith(categoryId: Value(category.id));
          } else {
            expense = expense.copyWith(categoryId: const Value(null));
          }
        }
      }
    }

    return await _expenseDao.insertExpense(expense);
  }

  Future<int> _insertIncomeTransaction(
      TransactionsCompanion transaction, IncomesCompanion income) async {
    var transactionId = await _transactionDao.insertTransaction(transaction);

    income = income.copyWith(transactionId: Value(transactionId));

    int success = await _incomeDao.insertIncome(income);

    if (success > 0) {
      Source? source =
          await _sourceDao.getSourceById(income.placedOnsourceId.value!);

      if (source != null) {
        source = source.copyWith(
          balance: source.balance + transaction.amount.value,
        );
        await _sourceDao.updateSource(source);
      }
    }

    return transactionId;
  }

  Future<int> _insertTransferTransaction(
      TransactionsCompanion transaction, TransfersCompanion transfer) async {
    var transactionId = await _transactionDao.insertTransaction(transaction);

    transfer = transfer.copyWith(transactionId: Value(transactionId));

    int success = await _transferDao.insertTransfer(transfer);

    if (success > 0) {
      Source? fromSource;
      Source? toSource;

      fromSource = await _sourceDao.getSourceById(transfer.fromSourceId.value!);

      if (fromSource != null) {
        fromSource = fromSource.copyWith(
          balance: fromSource.balance - transaction.amount.value,
        );
        await _sourceDao.updateSource(fromSource);
      }

      toSource = await _sourceDao.getSourceById(transfer.toSourceId.value!);

      if (toSource != null) {
        toSource = toSource.copyWith(
          balance: toSource.balance + transaction.amount.value,
        );
        await _sourceDao.updateSource(toSource);
      }
    }

    return transactionId;
  }

  Future<bool> updateTransaction(
      Transaction transaction, dynamic transactionType) async {
    Transaction? oldTransaction =
        await _transactionDao.getTransactionById(transaction.id);

    if (oldTransaction == null) return false;
    if (transaction.type != oldTransaction.type) return false;
    if (transactionType is! ExpenseModel &&
        transactionType is! IncomeModel &&
        transactionType is! TransferModel) return false;

    switch (transaction.type) {
      case TransactionTypes.expense:
        if (!(await _updateExpenseTransaction(
            transaction, oldTransaction, transactionType))) {
          return false;
        }
        break;
      case TransactionTypes.income:
        if (!(await _updateIncomeTransaction(
            transaction, oldTransaction, transactionType))) {
          return false;
        }
        break;
      case TransactionTypes.transfer:
        if (!(await _updateTransferTransaction(
            transaction, oldTransaction, transactionType))) {
          return false;
        }
        break;
      default:
        return false;
    }

    return await _transactionDao.updateTransaction(transaction);
  }

  Future<bool> _updateExpenseTransaction(Transaction transaction,
      Transaction oldTransaction, ExpenseModel newExpense) async {
    var oldExpense =
        await _expenseDao.getExpenseByTransactionId(transaction.id);

    if (oldExpense == null) return false;

    Source? oldSource = await _sourceDao.getSourceById(oldExpense.sourceId);
    Source? newSource = await _sourceDao.getSourceById(newExpense.source.id);
    Category? oldCategory;
    Category? newCategory;

    if (oldSource == null || newSource == null) return false;

    if (oldSource.id != newSource.id) {
      oldSource = oldSource.copyWith(
        balance: oldSource.balance + oldTransaction.amount,
      );
      newSource = newSource.copyWith(
        balance: newSource.balance - transaction.amount,
      );

      await _sourceDao.updateSource(oldSource);
      await _sourceDao.updateSource(newSource);
    }

    if (oldExpense.categoryId != newExpense.category?.id) {
      if (oldExpense.categoryId != null) {
        oldCategory =
            await _categoryDao.getCategoryById(oldExpense.categoryId!);
      }

      if (newExpense.category != null) {
        newCategory =
            await _categoryDao.getCategoryById(newExpense.category!.id);
      }

      if (oldCategory != null) {
        oldCategory = oldCategory.copyWith(
          balance: oldCategory.balance + oldTransaction.amount,
        );
        await _categoryDao.updateCategory(oldCategory);
      }

      if (newCategory != null) {
        newCategory = newCategory.copyWith(
          balance: newCategory.balance - transaction.amount,
        );
        await _categoryDao.updateCategory(newCategory);
      }

      oldExpense = oldExpense.copyWith(
        sourceId: newExpense.source.id,
        categoryId: Value(newExpense.category?.id),
      );
    }

    return await _expenseDao.updateExpense(oldExpense);
  }

  Future<bool> _updateIncomeTransaction(Transaction transaction,
      Transaction oldTransaction, IncomeModel newIncome) async {
    var oldIncome = await _incomeDao.getIncomeByTransactionId(transaction.id);

    if (oldIncome == null) return false;

    Source? oldSource =
        await _sourceDao.getSourceById(oldIncome.placedOnsourceId);
    Source? newSource =
        await _sourceDao.getSourceById(newIncome.placedOnSource.id);

    if (oldSource == null || newSource == null) return false;

    if (oldSource.id != newSource.id) {
      oldSource = oldSource.copyWith(
        balance: oldSource.balance - oldTransaction.amount,
      );
      newSource = newSource.copyWith(
        balance: newSource.balance + transaction.amount,
      );

      await _sourceDao.updateSource(oldSource);
      await _sourceDao.updateSource(newSource);

      oldIncome = oldIncome.copyWith(
        placedOnsourceId: newIncome.placedOnSource.id,
      );
    } else if (transaction.amount != oldTransaction.amount) {
      oldSource = oldSource.copyWith(
        balance: oldSource.balance - oldTransaction.amount + transaction.amount,
      );
      await _sourceDao.updateSource(oldSource);
    }

    return await _incomeDao.updateIncome(oldIncome);
  }

  Future<bool> _updateTransferTransaction(Transaction transaction,
      Transaction oldTransaction, TransferModel newTransfer) async {
    var oldTransfer =
        await _transferDao.getTransferByTransactionId(transaction.id);

    if (oldTransfer == null) return false;

    Source? oldFromSource =
        await _sourceDao.getSourceById(oldTransfer.fromSourceId);
    Source? oldToSource =
        await _sourceDao.getSourceById(oldTransfer.toSourceId);
    Source? newFromSource =
        await _sourceDao.getSourceById(newTransfer.fromSource!.id);
    Source? newToSource =
        await _sourceDao.getSourceById(newTransfer.toSource!.id);

    if (oldFromSource == null || oldToSource == null) return false;
    if (newFromSource == null || newToSource == null) return false;

    if (oldFromSource.id != newFromSource.id) {
      oldFromSource = oldFromSource.copyWith(
        balance: oldFromSource.balance + oldTransaction.amount,
      );
      newFromSource = newFromSource.copyWith(
        balance: newFromSource.balance - transaction.amount,
      );

      await _sourceDao.updateSource(oldFromSource);
      await _sourceDao.updateSource(newFromSource);
    }

    if (oldToSource.id != newToSource.id) {
      oldToSource = oldToSource.copyWith(
        balance: oldToSource.balance - oldTransaction.amount,
      );
      newToSource = newToSource.copyWith(
        balance: newToSource.balance + transaction.amount,
      );

      await _sourceDao.updateSource(oldToSource);
      await _sourceDao.updateSource(newToSource);

      oldTransfer = oldTransfer.copyWith(
        fromSourceId: newTransfer.fromSource!.id,
        toSourceId: newTransfer.toSource!.id,
      );
    }

    return await _transferDao.updateTransfer(oldTransfer);
  }

  Future<bool> deleteTransaction(Transaction transaction) async {
    switch (transaction.type) {
      case TransactionTypes.expense:
        if (!await _deleteExpenseTransaction(transaction)) {
          return false;
        }
      case TransactionTypes.income:
        if (!await _deleteIncomeTransaction(transaction)) {
          return false;
        }
      case TransactionTypes.transfer:
        if (!await _deleteTransferTransaction(transaction)) {
          return false;
        }
      default:
        return false;
    }

    return await _transactionDao.deleteTransactionById(transaction.id) > 0;
  }

  Future<bool> _deleteExpenseTransaction(Transaction transaction) async {
    var expense = await _getExpenseModelByTransaction(transaction);

    if (expense == null) return false;

    Source? source = await _sourceDao.getSourceById(expense.source.id);

    if (source != null) {
      source = source.copyWith(
        balance: source.balance + transaction.amount,
      );
      await _sourceDao.updateSource(source);
    }

    if (expense.category != null) {
      Category? category =
          await _categoryDao.getCategoryById(expense.category!.id);

      if (category != null) {
        category = category.copyWith(
          balance: category.balance + transaction.amount,
        );
        await _categoryDao.updateCategory(category);
      }
    }

    return await _expenseDao.deleteExpenseById(expense.id) > 0;
  }

  Future<bool> _deleteIncomeTransaction(Transaction transaction) async {
    var income = await _getIncomeModelByTransaction(transaction);

    if (income == null) return false;

    Source? source = await _sourceDao.getSourceById(income.placedOnSource.id);

    if (source == null) return false;

    source = source.copyWith(
      balance: source.balance - transaction.amount,
    );
    await _sourceDao.updateSource(source);

    return await _incomeDao.deleteIncomeById(income.id) > 0;
  }

  Future<bool> _deleteTransferTransaction(Transaction transaction) async {
    var transfer = await _getTransferModelByTransaction(transaction);

    if (transfer == null) return false;

    Source? fromSource = await _sourceDao.getSourceById(transfer.fromSource.id);
    Source? toSource = await _sourceDao.getSourceById(transfer.toSource.id);

    if (fromSource == null || toSource == null) return false;

    fromSource = fromSource.copyWith(
      balance: fromSource.balance + transaction.amount,
    );
    await _sourceDao.updateSource(fromSource);

    toSource = toSource.copyWith(
      balance: toSource.balance - transaction.amount,
    );
    await _sourceDao.updateSource(toSource);

    return await _transferDao.deleteTransferById(transfer.id) > 0;
  }

  Future<bool> deleteTransactionsBySourceId(int sourceId) async {
    var transactions = await getAllTransactions();

    transactions.removeWhere((key, value) {
      if (value is ExpenseModel) {
        return value.source.id != sourceId;
      } else if (value is IncomeModel) {
        return value.placedOnSource.id == sourceId;
      } else if (value is TransferModel) {
        return value.fromSource.id != sourceId && value.toSource.id != sourceId;
      }
      return false;
    });

    for (var transaction in transactions.keys) {
      if (!await deleteTransaction(transaction)) {
        return false;
      }
    }

    return true;
  }
}
