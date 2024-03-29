import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/daos/budget/source_dao.dart';
import 'package:moneygo/data/daos/savings/savings_dao.dart';
import 'package:moneygo/data/daos/savings/savings_in_dao.dart';
import 'package:moneygo/data/daos/savings/savings_log_dao.dart';
import 'package:moneygo/data/daos/savings/savings_out_dao.dart';
import 'package:moneygo/data/daos/savings/savings_transfer_dao.dart';
import 'package:moneygo/data/daos/savings/vault_dao.dart';
import 'package:moneygo/data/models/savings/savings_in_model.dart';
import 'package:moneygo/data/models/savings/savings_log_subtype.dart';
import 'package:moneygo/data/models/savings/savings_out_model.dart';
import 'package:moneygo/data/models/savings/savings_transfer_model.dart';
import 'package:moneygo/utils/enums.dart';

class SavingsLogReposiory {
  final SavingsLogDao _savingsLogDao;
  final SavingDao _savingsDao;
  final VaultDao _vaultDao;
  final SourceDao _sourceDao;
  final SavingsInDao _savingsInDao;
  final SavingsOutDao _savingsOutDao;
  final SavingsTransferDao _savingsTransferDao;

  SavingsLogReposiory(
    this._savingsLogDao,
    this._savingsDao,
    this._vaultDao,
    this._sourceDao,
    this._savingsInDao,
    this._savingsOutDao,
    this._savingsTransferDao,
  );

  Stream<List<SavingsLog>> watchAllSavingsLogs() =>
      _savingsLogDao.watchAllSavingsLogs();

  Future<Map<SavingsLog, SavingLogsTypes>> getAllSavingsLogs() async {
    var savingsLogs = await _savingsLogDao.getAllSavingsLogs();

    var savingsLogsSorted = savingsLogs
      ..sort((a, b) => b.date.compareTo(a.date));

    var savingsMap = <SavingsLog, SavingLogsTypes>{};

    for (var savingsLog in savingsLogsSorted) {
      switch (savingsLog.type) {
        case SavingTransactionTypes.savingsIn:
          var savingsInModel = await _getSavingsInModelBySavingsLog(savingsLog);
          if (savingsInModel != null) {
            savingsMap[savingsLog] = savingsInModel;
          }
          break;
        case SavingTransactionTypes.savingsOut:
          var savingsOutModel =
              await _getSavingsOutModelBySavingsLog(savingsLog);
          if (savingsOutModel != null) {
            savingsMap[savingsLog] = savingsOutModel;
          }
          break;
        case SavingTransactionTypes.savingsTransfer:
          var savingsTransferModel =
              await _getSavingsTransferModelBySavingsLog(savingsLog);
          if (savingsTransferModel != null) {
            savingsMap[savingsLog] = savingsTransferModel;
          }
          break;
      }
    }

    return savingsMap;
  }

  Future<SavingsInModel?> _getSavingsInModelBySavingsLog(
      SavingsLog savingsLog) async {
    var savingsIn =
        await _savingsInDao.getSavingsInBySavingsLogId(savingsLog.id);

    if (savingsIn == null) {
      await _savingsLogDao.deleteSavingLog(savingsLog);
      return null;
    }

    Saving? saving = await _savingsDao.getSavingById(savingsIn.savingsId);

    if (saving == null) return null;

    Source? source = await _sourceDao.getSourceById(savingsIn.sourceId);

    if (source == null) return null;

    return SavingsInModel(
      id: savingsIn.id,
      savingsLog: savingsLog,
      saving: saving,
      source: source,
    );
  }

  Future<SavingsOutModel?> _getSavingsOutModelBySavingsLog(
      SavingsLog savingsLog) async {
    var savingsOut =
        await _savingsOutDao.getSavingsOutBySavingsLogId(savingsLog.id);

    if (savingsOut == null) {
      await _savingsLogDao.deleteSavingLog(savingsLog);
      return null;
    }

    Saving? saving = await _savingsDao.getSavingById(savingsOut.savingsId);

    if (saving == null) return null;

    Source? source = await _sourceDao.getSourceById(savingsOut.sourceId);

    if (source == null) return null;

    return SavingsOutModel(
      id: savingsOut.id,
      savingsLog: savingsLog,
      saving: saving,
      source: source,
    );
  }

  Future<SavingsTransferModel?> _getSavingsTransferModelBySavingsLog(
      SavingsLog savingsLog) async {
    var savingsTransfer = await _savingsTransferDao
        .getSavingsTransferBySavingsLogId(savingsLog.id);

    if (savingsTransfer == null) {
      await _savingsLogDao.deleteSavingLog(savingsLog);
      return null;
    }

    Saving? fromSaving =
        await _savingsDao.getSavingById(savingsTransfer.fromSavingsId);

    if (fromSaving == null) return null;

    Saving? toSaving =
        await _savingsDao.getSavingById(savingsTransfer.toSavingsId);

    if (toSaving == null) return null;

    return SavingsTransferModel(
      id: savingsTransfer.id,
      savingsLog: savingsLog,
      fromSaving: fromSaving,
      toSaving: toSaving,
    );
  }
}
