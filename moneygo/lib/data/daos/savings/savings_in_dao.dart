import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/tables/savings/savings_ins.dart';

part 'savings_in_dao.g.dart';

@DriftAccessor(tables: [SavingsIns])
class SavingsInDao extends DatabaseAccessor<AppDatabase>
    with _$SavingsInDaoMixin {
  SavingsInDao(AppDatabase db) : super(db);

  Stream<List<SavingsIn>> watchAllSavingsIn() => select(savingsIns).watch();

  Future<List<SavingsIn>> getAllSavingsIn() async =>
      await select(savingsIns).get();

  Future<SavingsIn?> getSavingsInById(int id) async =>
      await (select(savingsIns)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<SavingsIn?> getSavingsInBySavingsLogId(int id) async =>
      await (select(savingsIns)..where((tbl) => tbl.savingsLogId.equals(id)))
          .getSingleOrNull();

  Future<int> insertSavingsIn(SavingsInsCompanion savingsIn) async =>
      await into(savingsIns).insert(savingsIn);

  Future<bool> updateSavingsIn(SavingsIn savingsIn) async =>
      await update(savingsIns).replace(savingsIn);

  Future<int> deleteSavingsIn(SavingsIn savingsIn) async =>
      await delete(savingsIns).delete(savingsIn);

  Future<int> deleteSavingsInById(int id) async =>
      await (delete(savingsIns)..where((tbl) => tbl.id.equals(id))).go();
}
