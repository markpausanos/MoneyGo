import 'package:equatable/equatable.dart';
import 'package:moneygo/data/app_database.dart';

abstract class SavingEvent extends Equatable {
  @override
  List<Object> get props => [];

  const SavingEvent();
}

class LoadSavings extends SavingEvent {}

class AddSaving extends SavingEvent {
  final SavingsCompanion saving;

  const AddSaving(this.saving);

  @override
  List<Object> get props => [saving];
}

class UpdateSaving extends SavingEvent {
  final Saving saving;

  const UpdateSaving(this.saving);

  @override
  List<Object> get props => [saving];
}

class DeleteSaving extends SavingEvent {
  final int savingId;

  const DeleteSaving(this.savingId);

  @override
  List<Object> get props => [savingId];
}
