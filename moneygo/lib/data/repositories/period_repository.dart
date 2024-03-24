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
      await insertPeriod(PeriodsCompanion.insert(
        startDate: Value(DateTime.now()),
      ));
      return await _periodDao.getAllPeriods();
    }

    return periods.reversed.toList();
  }

  Future<Period?> getPeriodById(int id) async =>
      await _periodDao.getPeriodById(id);

  Future<Period> getLatestPeriod() async {
    List<Period> periods = await _periodDao.getAllPeriods();

    if (periods.isEmpty) {
      DateTime startDate = DateTime.now();
      startDate = DateTime(startDate.year, startDate.month, startDate.day);
      int id = await insertPeriod(PeriodsCompanion.insert(
        startDate: Value(DateTime.now()),
      ));

      var periodNew = await _periodDao.getPeriodById(id);

      return periodNew!;
    }

    Period period = periods.last;
    DateTime now = DateTime.now();

    if (period.endDate != null && now.isAfter(period.endDate!)) {
      DateTime startDate = period.endDate!.add(const Duration(days: 1));
      startDate = DateTime(startDate.year, startDate.month, startDate.day);
      PeriodsCompanion newPeriod = PeriodsCompanion.insert(
          startDate: Value(period.endDate!.add(const Duration(days: 1))),
          endDate: const Value(null));
      int id = await insertPeriod(newPeriod);

      var periodNew = await _periodDao.getPeriodById(id);

      return periodNew!;
    }

    return period;
  }

  Future<int> insertPeriod(PeriodsCompanion period) async {
    Period? previousPeriod = await _periodDao.getLatestPeriod();

    if (previousPeriod != null && previousPeriod.endDate == null) {
      return previousPeriod.id;
    }

    DateTime startDate = period.startDate.value;
    startDate = DateTime(startDate.year, startDate.month, startDate.day);

    period = period.copyWith(
      startDate: Value(startDate),
    );

    int id = await _periodDao.insertPeriod(period);
    var categories = await _categoryDao.getAllCategories();

    categories = categories
        .where((category) =>
            previousPeriod != null && category.periodId == previousPeriod.id)
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
