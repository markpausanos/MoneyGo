import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/blocs/backups/backup_event.dart';
import 'package:moneygo/data/blocs/backups/backup_state.dart';
import 'package:moneygo/data/repositories/backup_repository.dart';

class BackupBloc extends Bloc<BackupEvent, BackupState> {
  final BackupRepository backupRepository;

  BackupBloc({required this.backupRepository}) : super(BackupLoading()) {
    on<LoadBackups>(_onLoadBackups);
    on<AddBackup>(_onAddBackup);
    on<RestoreBackup>(_onRestoreBackup);
  }

  void _onLoadBackups(LoadBackups event, Emitter<BackupState> emit) async {
    try {
      final backups = await backupRepository.getAllBackups();
      emit(BackupLoaded(backups));
    } catch (e) {
      emit(BackupError(e.toString()));
    }
  }

  void _onAddBackup(AddBackup event, Emitter<BackupState> emit) async {
    try {
      await backupRepository.addBackup();
      final backups = await backupRepository.getAllBackups();
      emit(BackupSaveSuccess());
      emit(BackupLoaded(backups));
    } catch (e) {
      emit(BackupError(e.toString()));
    }
  }

  void _onRestoreBackup(RestoreBackup event, Emitter<BackupState> emit) async {
    try {
      await backupRepository.restoreBackup(event.dateFileName);

      emit(BackupRestoreSuccess());
    } catch (e) {
      emit(BackupError(e.toString()));
    }
  }
}
