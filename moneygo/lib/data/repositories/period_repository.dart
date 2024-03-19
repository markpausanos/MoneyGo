import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/daos/period_dao.dart';

class PeriodRepository {
  final PeriodDao _periodDao;

  PeriodRepository(this._periodDao);

  Stream<List<Period>> watchAllPeriods() => _periodDao.watchAllPeriods();

  Future<List<Period>> getAllPeriods() async {
    final periods = await _periodDao.getAllPeriods();

    if (periods.isEmpty) {
      insertPeriod(PeriodsCompanion.insert(
        startDate: Value(DateTime.now()),
      ));
  
      return getAllPeriods();
    }

    return periods.reversed.toList();
  }

  Future<Period?> getPeriodById(int id) async =>
      await _periodDao.getPeriodById(id);

  Future<Period?> getLatestPeriod() async => await _periodDao.getLatestPeriod();

  Future<int> insertPeriod(PeriodsCompanion period) async =>
      await _periodDao.insertPeriod(period);

  Future<bool> updatePeriod(Period period) async =>
      await _periodDao.updatePeriod(period);

  Future<int> deletePeriod(Period period) async =>
      await _periodDao.deletePeriod(period);
}
