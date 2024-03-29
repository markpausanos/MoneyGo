import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/tables/savings/savings_outs.dart';

part 'savings_out_dao.g.dart';

@DriftAccessor(tables: [SavingsOuts])
class SavingsOutDao extends DatabaseAccessor<AppDatabase>
    with _$SavingsOutDaoMixin {
  SavingsOutDao(super.db);

  Stream<List<SavingsOut>> watchAllSavingsOut() => select(savingsOuts).watch();

  Future<List<SavingsOut>> getAllSavingsOut() async =>
      await select(savingsOuts).get();

  Future<SavingsOut?> getSavingsOutById(int id) async =>
      await (select(savingsOuts)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<SavingsOut?> getSavingsOutBySavingsLogId(int id) async =>
      await (select(savingsOuts)..where((tbl) => tbl.savingsLogId.equals(id)))
          .getSingleOrNull();

  Future<int> insertSavingsOut(SavingsOutsCompanion savingsOut) async =>
      await into(savingsOuts).insert(savingsOut);

  Future<bool> updateSavingsOut(SavingsOut savingsOut) async =>
      await update(savingsOuts).replace(savingsOut);

  Future<int> deleteSavingsOut(SavingsOut savingsOut) async =>
      await delete(savingsOuts).delete(savingsOut);

  Future<int> deleteSavingsOutById(int id) async =>
      await (delete(savingsOuts)..where((tbl) => tbl.id.equals(id))).go();
}
