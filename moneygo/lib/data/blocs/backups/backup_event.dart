import 'package:equatable/equatable.dart';

abstract class BackupEvent extends Equatable {
  @override
  List<Object> get props => [];

  const BackupEvent();
}

class LoadBackups extends BackupEvent {}

class AddBackup extends BackupEvent {}

class DeleteBackup extends BackupEvent {
  final int id;

  const DeleteBackup(this.id);

  @override
  List<Object> get props => [id];
}

class RestoreBackup extends BackupEvent {
  final String dateFileName;

  const RestoreBackup(this.dateFileName);

  @override
  List<Object> get props => [dateFileName];
}
