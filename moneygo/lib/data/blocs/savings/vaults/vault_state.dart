import 'package:equatable/equatable.dart';
import 'package:moneygo/data/app_database.dart';

abstract class VaultState extends Equatable {
  @override
  List<Object> get props => [];
}

class VaultsLoading extends VaultState {}

class VaultsLoaded extends VaultState {
  final List<Vault> vaults;

  VaultsLoaded(this.vaults);

  @override
  List<Object> get props => [vaults];
}

class VaultsError extends VaultState {
  final String message;

  VaultsError(this.message);

  @override
  List<Object> get props => [message];
}

class VaultsSaveSuccess extends VaultState {
  final String name;

  VaultsSaveSuccess(this.name);

  @override
  List<Object> get props => [name];
}

class VaultsUpdateSuccess extends VaultState {
  final String name;

  VaultsUpdateSuccess(this.name);

  @override
  List<Object> get props => [name];
}

class VaultsDeleteSuccess extends VaultState {}
