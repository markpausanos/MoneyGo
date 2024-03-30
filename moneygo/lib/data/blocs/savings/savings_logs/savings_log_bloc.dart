import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/blocs/savings/savings_logs/savings_log_event.dart';
import 'package:moneygo/data/blocs/savings/savings_logs/savings_log_state.dart';
import 'package:moneygo/data/models/savings/savings_in_model.dart';
import 'package:moneygo/data/models/savings/savings_out_model.dart';
import 'package:moneygo/data/models/savings/savings_transfer_model.dart';
import 'package:moneygo/data/repositories/savings/savings_log_repository.dart';

class SavingsLogBloc extends Bloc<SavingsLogEvent, SavingsLogState> {
  final SavingsLogRepository savingsLogRepository;

  SavingsLogBloc({required this.savingsLogRepository})
      : super(SavingsLogsLoading()) {
    on<LoadSavingsLogs>(_onLoadSavingsLogs);
    // on<AddSavingsLog>(_onAddSavingsLog);
    // on<UpdateSavingsLog>(_onUpdateSavingsLog);
    // on<DeleteSavingsLog>(_onDeleteSavingsLog);
  }

  void _onLoadSavingsLogs(
      LoadSavingsLogs event, Emitter<SavingsLogState> emit) async {
    try {
      final savingsLogs = await savingsLogRepository.getAllSavingsLogs();
      emit(SavingsLogsLoaded(savingsLogs));
    } catch (e) {
      emit(SavingsLogsError(e.toString()));
    }
  }

  // void _onAddSavingsLog(
  //     AddSavingsLog event, Emitter<SavingsLogState> emit) async {
  //   try {
  //     if (event.savingsLogType == null) {
  //       emit(SavingsLogsError('Savings log type is required'));
  //       return;
  //     }
  //     if (event.savingsLogType is! SavingsInModel &&
  //         event.savingsLogType is! SavingsOutModel &&
  //         event.savingsLogType is! SavingsTransferModel) {
  //       emit(SavingsLogsError('Invalid savings log type'));
  //       return;
  //     }
  //     await savingsLogRepository.insertSavingsLog(
  //         event.savingsLog, event.savingsLogType);

  //     final savingsLogs = await savingsLogRepository.getAllSavingsLogs();

  //     emit(SavingsLogsSaveSuccess());
  //     emit(SavingsLogsLoaded(savingsLogs));
  //   } catch (e) {
  //     emit(SavingsLogsError(e.toString()));
  //   }
  // }

  // void _onUpdateSavingsLog(
  //     UpdateSavingsLog event, Emitter<SavingsLogState> emit) async {
  //   try {
  //     await savingsLogRepository.updateSavingsLog(
  //         event.savingsLog, event.savingsLogType);
  //     final savingsLogs = await savingsLogRepository.getAllSavingsLogs();
  //     emit(SavingsLogsUpdateSuccess());
  //     emit(SavingsLogsLoaded(savingsLogs));
  //   } catch (e) {
  //     emit(SavingsLogsError(e.toString()));
  //   }
  // }

  // void _onDeleteSavingsLog(
  //     DeleteSavingsLog event, Emitter<SavingsLogState> emit) async {
  //   try {
  //     await savingsLogRepository.deleteSavingsLog(event.savingsLog);
  //     final savingsLogs = await savingsLogRepository.getAllSavingsLogs();
  //     emit(SavingsLogsDeleteSuccess());
  //     emit(SavingsLogsLoaded(savingsLogs));
  //   } catch (e) {
  //     emit(SavingsLogsError(e.toString()));
  //   }
  // }
}
