import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/daos/savings/savings_dao.dart';

class SavingsRepository {
  final SavingDao _savingsDao;

  SavingsRepository(this._savingsDao);

  Stream<List<Saving>> watchAllSavings() => _savingsDao.watchAllSavings();

  Future<List<Saving>> getAllSavings() async {
    return await _savingsDao.getAllSavings();
  }

  Future<Saving?> getSavingById(int id) async =>
      await _savingsDao.getSavingById(id);

  Future<int> insertSaving(SavingsCompanion saving) async {
    if (saving.name.value.isEmpty) {
      throw Exception('Name cannot be empty');
    } else if (saving.goalAmount.value != null &&
        saving.goalAmount.value! < 0) {
      throw Exception('Amount cannot be negative');
    } else if (saving.amount.value < 0) {
      throw Exception('Amount cannot be negative');
    }

    return await _savingsDao.insertSaving(saving);
  }

  Future<bool> updateSaving(Saving saving) async {
    if (saving.name.isEmpty) {
      throw Exception('Name cannot be empty');
    } else if (saving.goalAmount != null && saving.goalAmount! < 0) {
      throw Exception('Amount cannot be negative');
    } else if (saving.amount < 0) {
      throw Exception('Amount cannot be negative');
    }

    return await _savingsDao.updateSaving(saving);
  }

  Future<int> deleteSaving(Saving saving) async {
    return await _savingsDao.deleteSaving(saving);
  }

  Future<int> deleteSavingById(int id) async {
    return await _savingsDao.deleteSavingById(id);
  }
}
