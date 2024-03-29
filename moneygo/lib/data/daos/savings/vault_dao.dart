import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/tables/savings/vaults.dart';

part 'vault_dao.g.dart';

@DriftAccessor(tables: [Vaults])
class VaultDao extends DatabaseAccessor<AppDatabase> with _$VaultDaoMixin {
  VaultDao(super.db);

  Stream<List<Vault>> watchAllVaults() => select(vaults).watch();

  Future<List<Vault>> getAllVaults() async => await select(vaults).get();

  Future<Vault?> getVaultById(int id) async =>
      await (select(vaults)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<int> insertVault(VaultsCompanion vault) async =>
      await into(vaults).insert(vault);

  Future<bool> updateVault(Vault vault) async =>
      await update(vaults).replace(vault);

  Future<int> deleteVault(Vault vault) async =>
      await delete(vaults).delete(vault);

  Future<int> deleteVaultById(int id) async =>
      await (delete(vaults)..where((tbl) => tbl.id.equals(id))).go();
}
