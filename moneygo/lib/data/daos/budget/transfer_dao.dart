import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/tables/budget/transfers.dart';

part 'transfer_dao.g.dart';

@DriftAccessor(tables: [Transfers])
class TransferDao extends DatabaseAccessor<AppDatabase>
    with _$TransferDaoMixin {
  TransferDao(super.db);

  Stream<List<Transfer>> watchAllTransfers() => select(transfers).watch();

  Future<List<Transfer>> getAllTransfers() async =>
      await select(transfers).get();

  Future<Transfer?> getTransferById(int id) async =>
      await (select(transfers)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<Transfer?> getTransferByTransactionId(int id) async =>
      await (select(transfers)..where((tbl) => tbl.transactionId.equals(id)))
          .getSingleOrNull();

  Future<int> insertTransfer(TransfersCompanion transfer) async =>
      await into(transfers).insert(transfer);

  Future<bool> updateTransfer(Transfer transfer) async =>
      await update(transfers).replace(transfer);

  Future<int> deleteTransfer(Transfer transfer) async =>
      await delete(transfers).delete(transfer);

  Future<int> deleteTransferById(int id) async =>
      await (delete(transfers)..where((tbl) => tbl.id.equals(id))).go();
}
