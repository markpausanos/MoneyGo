import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/daos/budget/source_dao.dart';

class SourceRepository {
  final SourceDao _sourceDao;

  SourceRepository(this._sourceDao);

  Stream<List<Source>> watchAllSources() => _sourceDao.watchAllSources();

  Future<List<Source>> getAllSources() async {
    var sources = await _sourceDao.getAllSources();

    sources.sort((a, b) => a.order.compareTo(b.order));

    // check if all source orders are 0
    if (sources.every((source) => source.order == 0)) {
      for (var i = 0; i < sources.length; i++) {
        sources[i] = sources[i].copyWith(order: i);
        await _sourceDao.updateSource(sources[i]);
      }
    }

    return sources;
  }

  Future<Source?> getSourceById(int id) async =>
      await _sourceDao.getSourceById(id);

  Future<int> insertSource(SourcesCompanion source) async {
    var sourceCount = (await _sourceDao.getAllSources()).length;
    if (source.name.value.isEmpty) {
      throw Exception('Name cannot be empty');
    }

    source = source.copyWith(
      order: Value(sourceCount),
    );

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
