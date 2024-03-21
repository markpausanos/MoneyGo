import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/tables/expenses.dart';

part 'expense_dao.g.dart';

@DriftAccessor(tables: [Expenses])
class ExpenseDao extends DatabaseAccessor<AppDatabase> with _$ExpenseDaoMixin {
  ExpenseDao(super.db);

  Stream<List<Expense>> watchAllExpenses() => select(expenses).watch();

  Future<List<Expense>> getAllExpenses() async => await select(expenses).get();

  Future<Expense?> getExpenseById(int id) async =>
      await (select(expenses)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<Expense?> getExpenseByTransactionId(int id) async =>
      await (select(expenses)..where((tbl) => tbl.transactionId.equals(id)))
          .getSingleOrNull();

  Future<int> insertExpense(ExpensesCompanion expense) async =>
      await into(expenses).insert(expense);

  Future<bool> updateExpense(Expense expense) async =>
      await update(expenses).replace(expense);

  Future<int> deleteExpense(Expense expense) async =>
      await delete(expenses).delete(expense);

  Future<int> deleteExpenseById(int id) async =>
      await (delete(expenses)..where((tbl) => tbl.id.equals(id))).go();
}
