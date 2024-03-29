import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/tables/savings/savings_transfers.dart';

part 'savings_transfer_dao.g.dart';

@DriftAccessor(tables: [SavingsTransfers])
class SavingsTransferDao extends DatabaseAccessor<AppDatabase>
    with _$SavingsTransferDaoMixin {
  SavingsTransferDao(super.db);

  Stream<List<SavingsTransfer>> watchAllSavingsTransfer() =>
      select(savingsTransfers).watch();

  Future<List<SavingsTransfer>> getAllSavingsTransfer() async =>
      await select(savingsTransfers).get();

  Future<SavingsTransfer?> getSavingsTransferById(int id) async =>
      await (select(savingsTransfers)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<SavingsTransfer?> getSavingsTransferBySavingsLogId(int id) async =>
      await (select(savingsTransfers)
            ..where((tbl) => tbl.savingsLogId.equals(id)))
          .getSingleOrNull();

  Future<int> insertSavingsTransfer(
          SavingsTransfersCompanion savingsTransfer) async =>
      await into(savingsTransfers).insert(savingsTransfer);

  Future<bool> updateSavingsTransfer(SavingsTransfer savingsTransfer) async =>
      await update(savingsTransfers).replace(savingsTransfer);

  Future<int> deleteSavingsTransfer(SavingsTransfer savingsTransfer) async =>
      await delete(savingsTransfers).delete(savingsTransfer);

  Future<int> deleteSavingsTransferById(int id) async =>
      await (delete(savingsTransfers)..where((tbl) => tbl.id.equals(id))).go();
}
