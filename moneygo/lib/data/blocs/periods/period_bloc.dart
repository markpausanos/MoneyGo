import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/blocs/periods/period_event.dart';
import 'package:moneygo/data/blocs/periods/period_state.dart';
import 'package:moneygo/data/repositories/period_repository.dart';

class PeriodBloc extends Bloc<PeriodEvent, PeriodState> {
  final PeriodRepository periodRepository;

  PeriodBloc({required this.periodRepository}) : super(PeriodsLoading()) {
    on<LoadPeriods>(_onLoadPeriods);
    on<AddPeriod>(_onAddPeriod);
    on<UpdatePeriod>(_onUpdatePeriod);
    on<DeletePeriod>(_onDeletePeriod);
  }

  void _onLoadPeriods(LoadPeriods event, Emitter<PeriodState> emit) async {
    try {
      final periods = await periodRepository.getAllPeriods();
      emit(PeriodsLoaded(periods));
    } catch (e) {
      emit(PeriodsError(e.toString()));
    }
  }

  void _onAddPeriod(AddPeriod event, Emitter<PeriodState> emit) async {
    try {
      await periodRepository.insertPeriod(event.period);
      final periods = await periodRepository.getAllPeriods();
      emit(PeriodsSaveSuccess());
      emit(PeriodsLoaded(periods));
    } catch (e) {
      emit(PeriodsError(e.toString()));
    }
  }

  void _onUpdatePeriod(UpdatePeriod event, Emitter<PeriodState> emit) async {
    try {
      await periodRepository.updatePeriod(event.period);
      final periods = await periodRepository.getAllPeriods();
      emit(PeriodsUpdateSuccess());
      emit(PeriodsLoaded(periods));
    } catch (e) {
      emit(PeriodsError(e.toString()));
    }
  }

  void _onDeletePeriod(DeletePeriod event, Emitter<PeriodState> emit) async {
    try {
      await periodRepository.deletePeriod(event.period);
      add(LoadPeriods());
      emit(PeriodsDeleteSuccess());
    } catch (e) {
      emit(PeriodsError(e.toString()));
    }
  }
}
