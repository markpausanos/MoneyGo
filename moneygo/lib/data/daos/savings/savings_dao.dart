import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/tables/savings/savings.dart';

part 'savings_dao.g.dart';

@DriftAccessor(tables: [Savings])
class SavingDao extends DatabaseAccessor<AppDatabase> with _$SavingDaoMixin {
  SavingDao(super.db);

  Stream<List<Saving>> watchAllSavings() => select(savings).watch();

  Future<List<Saving>> getAllSavings() async => await select(savings).get();

  Future<Saving?> getSavingById(int id) async =>
      await (select(savings)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<int> insertSaving(SavingsCompanion saving) async =>
      await into(savings).insert(saving);

  Future<bool> updateSaving(Saving saving) async =>
      await update(savings).replace(saving);

  Future<int> deleteSaving(Saving saving) async =>
      await delete(savings).delete(saving);

  Future<int> deleteSavingById(int id) async =>
      await (delete(savings)..where((tbl) => tbl.id.equals(id))).go();
}
