import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/tables/periods.dart';

part 'period_dao.g.dart';

@DriftAccessor(tables: [Periods])
class PeriodDao extends DatabaseAccessor<AppDatabase> with _$PeriodDaoMixin {
  PeriodDao(super.db);

  Stream<List<Period>> watchAllPeriods() => select(periods).watch();

  Future<List<Period>> getAllPeriods() async => await select(periods).get();

  Future<Period?> getPeriodById(int id) async =>
      await (select(periods)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<Period?> getLatestPeriod() async =>
      await (select(periods)..orderBy([(tbl) => OrderingTerm.desc(tbl.id)]))
          .getSingleOrNull();

  Future<int> insertPeriod(PeriodsCompanion period) async =>
      await into(periods).insert(period);

  Future<bool> updatePeriod(Period period) async =>
      await update(periods).replace(period);

  Future<int> deletePeriod(Period period) async =>
      await delete(periods).delete(period);

  Future<int> deletePeriodById(int id) async =>
      await (delete(periods)..where((tbl) => tbl.id.equals(id))).go();
}
