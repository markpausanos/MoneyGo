import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/blocs/savings/vaults/vault_event.dart';
import 'package:moneygo/data/blocs/savings/vaults/vault_state.dart';
import 'package:moneygo/data/repositories/savings/vault_repository.dart';

class VaultBloc extends Bloc<VaultEvent, VaultState> {
  final VaultRepository vaultRepository;

  VaultBloc({required this.vaultRepository}) : super(VaultsLoading()) {
    on<LoadVaults>(_onLoadVaults);
    on<AddVault>(_onAddVault);
    on<UpdateVault>(_onUpdateVault);
    on<DeleteVault>(_onDeleteVault);
  }

  void _onLoadVaults(LoadVaults event, Emitter<VaultState> emit) async {
    try {
      final vaults = await vaultRepository.getAllVaults();
      emit(VaultsLoaded(vaults));
    } catch (e) {
      emit(VaultsError(e.toString()));
    }
  }

  void _onAddVault(AddVault event, Emitter<VaultState> emit) async {
    try {
      await vaultRepository.insertVault(event.vault);
      final vaults = await vaultRepository.getAllVaults();
      emit(VaultsSaveSuccess(event.vault.name.value));
      emit(VaultsLoaded(vaults));
    } catch (e) {
      emit(VaultsError(e.toString()));
    }
  }

  void _onUpdateVault(UpdateVault event, Emitter<VaultState> emit) async {
    try {
      await vaultRepository.updateVault(event.vault);
      final vaults = await vaultRepository.getAllVaults();
      emit(VaultsUpdateSuccess(event.vault.name));
      emit(VaultsLoaded(vaults));
    } catch (e) {
      emit(VaultsError(e.toString()));
    }
  }

  void _onDeleteVault(DeleteVault event, Emitter<VaultState> emit) async {
    try {
      await vaultRepository.deleteVaultById(event.vaultId);
      add(LoadVaults());
      emit(VaultsDeleteSuccess());
    } catch (e) {
      emit(VaultsError(e.toString()));
    }
  }
}
