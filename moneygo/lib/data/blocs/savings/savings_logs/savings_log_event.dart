import 'package:equatable/equatable.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/utils/enums.dart';

abstract class SavingsLogEvent extends Equatable {
  @override
  List<Object> get props => [];

  const SavingsLogEvent();
}

class LoadSavingsLogs extends SavingsLogEvent {}

class AddSavingsLog extends SavingsLogEvent {
  final SavingsLogsCompanion savingsLog;
  final dynamic savingsLogType;

  const AddSavingsLog(this.savingsLog, this.savingsLogType);

  @override
  List<Object> get props => [savingsLog];
}

class UpdateSavingsLog extends SavingsLogEvent {
  final SavingsLog savingsLog;
  final SavingTransactionTypes savingsLogType;

  const UpdateSavingsLog(this.savingsLog, this.savingsLogType);

  @override
  List<Object> get props => [savingsLog];
}

class DeleteSavingsLog extends SavingsLogEvent {
  final SavingsLog savingsLog;

  const DeleteSavingsLog(this.savingsLog);

  @override
  List<Object> get props => [savingsLog];
}

class DeleteSavingsLogBySaving extends SavingsLogEvent {
  final int savingId;

  const DeleteSavingsLogBySaving(this.savingId);

  @override
  List<Object> get props => [savingId];
}
