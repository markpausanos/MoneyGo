import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/daos/budget/source_dao.dart';

class SourceRepository {
  final SourceDao _sourceDao;

  SourceRepository(this._sourceDao);

  Stream<List<Source>> watchAllSources() => _sourceDao.watchAllSources();

  Future<List<Source>> getAllSources() async {
    return await _sourceDao.getAllSources();
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

  Future<int> deleteSource(Source source) async {
    return await _sourceDao.deleteSource(source);
  }

  Future<int> deleteSourceById(int id) async {
    return await _sourceDao.deleteSourceById(id);
  }
}
