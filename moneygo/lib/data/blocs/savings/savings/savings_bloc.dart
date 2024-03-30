import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/blocs/savings/savings/savings_event.dart';
import 'package:moneygo/data/blocs/savings/savings/savings_state.dart';
import 'package:moneygo/data/repositories/savings/savings_repository.dart';

class SavingBloc extends Bloc<SavingEvent, SavingState> {
  final SavingsRepository savingRepository;

  SavingBloc({required this.savingRepository}) : super(SavingsLoading()) {
    on<LoadSavings>(_onLoadSavings);
    on<AddSaving>(_onAddSaving);
    on<UpdateSaving>(_onUpdateSaving);
    on<DeleteSaving>(_onDeleteSaving);
  }

  void _onLoadSavings(LoadSavings event, Emitter<SavingState> emit) async {
    try {
      final savings = await savingRepository.getAllSavings();
      emit(SavingsLoaded(savings));
    } catch (e) {
      emit(SavingsError(e.toString()));
    }
  }

  void _onAddSaving(AddSaving event, Emitter<SavingState> emit) async {
    try {
      await savingRepository.insertSaving(event.saving);
      final savings = await savingRepository.getAllSavings();
      emit(SavingsSaveSuccess(event.saving.name.value));
      emit(SavingsLoaded(savings));
    } catch (e) {
      emit(SavingsError(e.toString()));
    }
  }

  void _onUpdateSaving(UpdateSaving event, Emitter<SavingState> emit) async {
    try {
      await savingRepository.updateSaving(event.saving);
      final savings = await savingRepository.getAllSavings();
      emit(SavingsUpdateSuccess(event.saving.name));
      emit(SavingsLoaded(savings));
    } catch (e) {
      emit(SavingsError(e.toString()));
    }
  }

  void _onDeleteSaving(DeleteSaving event, Emitter<SavingState> emit) async {
    try {
      await savingRepository.deleteSavingById(event.savingId);
      add(LoadSavings());
      emit(SavingsDeleteSuccess());
    } catch (e) {
      emit(SavingsError(e.toString()));
    }
  }
}
