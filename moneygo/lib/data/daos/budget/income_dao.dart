import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/tables/budget/incomes.dart';

part 'income_dao.g.dart';

@DriftAccessor(tables: [Incomes])
class IncomeDao extends DatabaseAccessor<AppDatabase> with _$IncomeDaoMixin {
  IncomeDao(super.db);

  Stream<List<Income>> watchAllIncomes() => select(incomes).watch();

  Future<List<Income>> getAllIncomes() async => await select(incomes).get();

  Future<Income?> getIncomeById(int id) async =>
      await (select(incomes)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<Income?> getIncomeByTransactionId(int id) async =>
      await (select(incomes)..where((tbl) => tbl.transactionId.equals(id)))
          .getSingleOrNull();

  Future<int> insertIncome(IncomesCompanion expense) async =>
      await into(incomes).insert(expense);

  Future<bool> updateIncome(Income expense) async =>
      await update(incomes).replace(expense);

  Future<int> deleteIncome(Income expense) async =>
      await delete(incomes).delete(expense);

  Future<int> deleteIncomeById(int id) async =>
      await (delete(incomes)..where((tbl) => tbl.id.equals(id))).go();
}
