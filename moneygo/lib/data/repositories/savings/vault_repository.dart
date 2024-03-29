import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/daos/savings/vault_dao.dart';

class VaultRepository {
  final VaultDao _vaultDao;

  VaultRepository(this._vaultDao);

  Stream<List<Vault>> watchAllVaults() => _vaultDao.watchAllVaults();

  Future<List<Vault>> getAllVaults() async {
    return await _vaultDao.getAllVaults();
  }

  Future<Vault?> getVaultById(int id) async => await _vaultDao.getVaultById(id);

  Future<int> insertVault(VaultsCompanion vault) async {
    if (vault.name.value.isEmpty) {
      throw Exception('Name cannot be empty');
    }

    return await _vaultDao.insertVault(vault);
  }

  Future<bool> updateVault(Vault vault) async {
    if (vault.name.isEmpty) {
      throw Exception('Name cannot be empty');
    }

    vault = vault.copyWith(dateUpdated: Value(DateTime.now()));

    return await _vaultDao.updateVault(vault);
  }

  Future<int> deleteVault(Vault vault) async {
    return await _vaultDao.deleteVault(vault);
  }

  Future<int> deleteVaultById(int id) async {
    return await _vaultDao.deleteVaultById(id);
  }
}
