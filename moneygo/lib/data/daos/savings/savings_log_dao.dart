import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/tables/savings/savings_logs.dart';

part 'savings_log_dao.g.dart';

@DriftAccessor(tables: [SavingsLogs])
class SavingsLogDao extends DatabaseAccessor<AppDatabase>
    with _$SavingsLogDaoMixin {
  SavingsLogDao(super.db);

  Stream<List<SavingsLog>> watchAllSavingsLogs() => select(savingsLogs).watch();

  Future<List<SavingsLog>> getAllSavingsLogs() async =>
      await select(savingsLogs).get();

  Future<SavingsLog?> getSavingLogById(int id) async =>
      await (select(savingsLogs)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<int> insertSavingLog(SavingsLogsCompanion savingLog) async =>
      await into(savingsLogs).insert(savingLog);

  Future<bool> updateSavingLog(SavingsLog savingLog) async =>
      await update(savingsLogs).replace(savingLog);

  Future<int> deleteSavingLog(SavingsLog savingLog) async =>
      await delete(savingsLogs).delete(savingLog);

  Future<int> deleteSavingLogById(int id) async =>
      await (delete(savingsLogs)..where((tbl) => tbl.id.equals(id))).go();
}
