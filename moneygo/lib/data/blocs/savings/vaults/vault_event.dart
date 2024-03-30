import 'package:equatable/equatable.dart';
import 'package:moneygo/data/app_database.dart';

abstract class VaultEvent extends Equatable {
  @override
  List<Object> get props => [];

  const VaultEvent();
}

class LoadVaults extends VaultEvent {}

class AddVault extends VaultEvent {
  final VaultsCompanion vault;

  const AddVault(this.vault);

  @override
  List<Object> get props => [vault];
}

class UpdateVault extends VaultEvent {
  final Vault vault;

  const UpdateVault(this.vault);

  @override
  List<Object> get props => [vault];
}

class DeleteVault extends VaultEvent {
  final int vaultId;

  const DeleteVault(this.vaultId);

  @override
  List<Object> get props => [vaultId];
}
