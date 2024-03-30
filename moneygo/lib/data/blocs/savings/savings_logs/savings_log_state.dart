import 'package:equatable/equatable.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/models/savings/savings_log_subtype.dart';
import 'package:moneygo/utils/enums.dart';

abstract class SavingsLogState extends Equatable {
  @override
  List<Object> get props => [];
}

class SavingsLogsLoading extends SavingsLogState {}

class SavingsLogsLoaded extends SavingsLogState {
  final Map<SavingsLog, SavingLogsTypes> savingslogs;

  SavingsLogsLoaded(this.savingslogs);

  @override
  List<Object> get props => [savingslogs];
}

class SavingsLogsBySourceLoaded extends SavingsLogState {
  final Map<SavingsLog, SavingLogsTypes> savingslogs;

  SavingsLogsBySourceLoaded(this.savingslogs);

  @override
  List<Object> get props => [savingslogs];
}

class SavingsLogsError extends SavingsLogState {
  final String message;

  SavingsLogsError(this.message);

  @override
  List<Object> get props => [message];
}

class SavingsLogsSaveSuccess extends SavingsLogState {}

class SavingsLogsUpdateSuccess extends SavingsLogState {}

class SavingsLogsDeleteSuccess extends SavingsLogState {
  final int savingId;

  SavingsLogsDeleteSuccess(this.savingId);

  @override
  List<Object> get props => [savingId];
}
