import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/daos/category_dao.dart';
import 'package:moneygo/data/daos/period_dao.dart';

class PeriodRepository {
  final PeriodDao _periodDao;
  final CategoryDao _categoryDao;

  PeriodRepository(this._periodDao, this._categoryDao);

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

  Future<int> insertPeriod(PeriodsCompanion period) async {
    final id = await _periodDao.insertPeriod(period);
    final previousId = id - 1;

    var categories = await _categoryDao.getAllCategories();

    categories = categories
        .where((category) => category.periodId == previousId)
        .toList();

    for (var category in categories) {
      await _categoryDao.insertCategory(CategoriesCompanion(
        name: Value(category.name),
        maxBudget: Value(category.maxBudget),
        periodId: Value(id),
        balance: Value(category.maxBudget),
      ));
    }

    return id;
  }

  Future<bool> updatePeriod(Period period) async =>
      await _periodDao.updatePeriod(period);

  Future<int> deletePeriod(Period period) async =>
      await _periodDao.deletePeriod(period);
}
