import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/daos/source_dao.dart';

class SourceRepository {
  final SourceDao _sourceDao;

  SourceRepository(this._sourceDao);

  Stream<List<Source>> watchAllSources() => _sourceDao.watchAllSources();

  Future<List<Source>> getAllSources() async {
    var sources = await _sourceDao.getAllSources();

    return sources.where((source) => source.dateDeleted == null).toList();
  }

  Future<Source?> getSourceById(int id) async =>
      await _sourceDao.getSourceById(id);

  Future<int> insertSource(SourcesCompanion source) async {
    if (source.name.value.isEmpty) {
      throw Exception('Name cannot be empty');
    }

    return await _sourceDao.insertSource(source);
  }

  Future<bool> updateSource(Source source) async {
    if (source.name.isEmpty) {
      throw Exception('Name cannot be empty');
    }

    source = source.copyWith(dateUpdated: Value(DateTime.now()));

    return await _sourceDao.updateSource(source);
  }

  Future<bool> deleteSource(Source source) {
    source = source.copyWith(dateDeleted: Value(DateTime.now()));

    return _sourceDao.updateSource(source);
  }

  Future<bool> deleteSourceById(int id) async {
    var source = await getSourceById(id);

    if (source == null) {
      throw Exception('Source not found');
    }

    source = source.copyWith(dateDeleted: Value(DateTime.now()));

    return await _sourceDao.updateSource(source);
  }
}
