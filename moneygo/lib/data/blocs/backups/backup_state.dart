import 'package:equatable/equatable.dart';

abstract class BackupState extends Equatable {
  @override
  List<Object> get props => [];
}

class BackupLoading extends BackupState {}

class BackupLoaded extends BackupState {
  final List<String> backups;

  BackupLoaded(this.backups);

  @override
  List<Object> get props => [backups];
}

class BackupError extends BackupState {
  final String message;

  BackupError(this.message);

  @override
  List<Object> get props => [message];
}

class BackupSaveSuccess extends BackupState {}

class BackupDeleteSuccess extends BackupState {
  final int id;

  BackupDeleteSuccess(this.id);

  @override
  List<Object> get props => [id];
}

class BackupRestoreSuccess extends BackupState {}
