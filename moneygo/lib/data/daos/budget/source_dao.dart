import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/tables/budget/sources.dart';

part 'source_dao.g.dart';

@DriftAccessor(tables: [Sources])
class SourceDao extends DatabaseAccessor<AppDatabase> with _$SourceDaoMixin {
  SourceDao(super.db);

  Stream<List<Source>> watchAllSources() => select(sources).watch();

  Future<List<Source>> getAllSources() async => await select(sources).get();

  Future<Source?> getSourceById(int id) async =>
      await (select(sources)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<int> insertSource(SourcesCompanion source) async =>
      await into(sources).insert(source);

  Future<bool> updateSource(Source source) async =>
      await update(sources).replace(source);

  Future<int> deleteSource(Source source) async =>
      await delete(sources).delete(source);

  Future<int> deleteSourceById(int id) async =>
      await (delete(sources)..where((tbl) => tbl.id.equals(id))).go();
}
