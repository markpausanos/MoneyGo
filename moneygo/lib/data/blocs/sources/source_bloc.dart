import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/blocs/sources/source_event.dart';
import 'package:moneygo/data/blocs/sources/source_state.dart';
import 'package:moneygo/data/repositories/budget/source_repository.dart';

class SourceBloc extends Bloc<SourceEvent, SourceState> {
  final SourceRepository sourceRepository;

  SourceBloc({required this.sourceRepository}) : super(SourcesLoading()) {
    on<LoadSources>(_onLoadSources);
    on<AddSource>(_onAddSource);
    on<UpdateSource>(_onUpdateSource);
    on<DeleteSource>(_onDeleteSource);
  }

  void _onLoadSources(LoadSources event, Emitter<SourceState> emit) async {
    try {
      final sources = await sourceRepository.getAllSources();
      emit(SourcesLoaded(sources));
    } catch (e) {
      emit(SourcesError(e.toString()));
    }
  }

  void _onAddSource(AddSource event, Emitter<SourceState> emit) async {
    try {
      await sourceRepository.insertSource(event.source);
      final sources = await sourceRepository.getAllSources();
      emit(SourcesSaveSuccess(event.source.name.value));
      emit(SourcesLoaded(sources));
    } catch (e) {
      emit(SourcesError(e.toString()));
    }
  }

  void _onUpdateSource(UpdateSource event, Emitter<SourceState> emit) async {
    try {
      await sourceRepository.updateSource(event.source);
      final sources = await sourceRepository.getAllSources();
      emit(SourcesUpdateSuccess(event.source.name));
      emit(SourcesLoaded(sources));
    } catch (e) {
      emit(SourcesError(e.toString()));
    }
  }

  void _onDeleteSource(DeleteSource event, Emitter<SourceState> emit) async {
    try {
      await sourceRepository.deleteSourceById(event.sourceId);
      add(LoadSources());
      emit(SourcesDeleteSuccess());
    } catch (e) {
      emit(SourcesError(e.toString()));
    }
  }
}
