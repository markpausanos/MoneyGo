import 'package:equatable/equatable.dart';
import 'package:moneygo/data/app_database.dart';

abstract class SavingState extends Equatable {
  @override
  List<Object> get props => [];
}

class SavingsLoading extends SavingState {}

class SavingsLoaded extends SavingState {
  final List<Saving> categories;

  SavingsLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class SavingsError extends SavingState {
  final String message;

  SavingsError(this.message);

  @override
  List<Object> get props => [message];
}

class SavingsSaveSuccess extends SavingState {
  final String name;

  SavingsSaveSuccess(this.name);

  @override
  List<Object> get props => [name];
}

class SavingsUpdateSuccess extends SavingState {
  final String name;

  SavingsUpdateSuccess(this.name);

  @override
  List<Object> get props => [name];
}

class SavingsDeleteSuccess extends SavingState {}
