import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_event.dart';
import 'package:moneygo/data/blocs/settings/settings_state.dart';
import 'package:moneygo/data/repositories/settings_repository.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;

  SettingsBloc({required this.settingsRepository}) : super(SettingsLoading()) {
    on<LoadSettings>(_onLoadSettings);
    on<SaveSetting>(_onAddSetting);
    on<UpdateSetting>(_onUpdateSetting);
    on<DeleteSetting>(_onDeleteSetting);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    try {
      final settings = await settingsRepository.getAllSettings();
      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  void _onAddSetting(SaveSetting event, Emitter<SettingsState> emit) async {
    try {
      await settingsRepository.saveData(event.key, event.value);
      final settings = await settingsRepository.getAllSettings();
      emit(SettingsSaveSuccess(event.key));
      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  void _onUpdateSetting(
      UpdateSetting event, Emitter<SettingsState> emit) async {
    try {
      await settingsRepository.updateData(event.key, event.value);
      final settings = await settingsRepository.getAllSettings();
      emit(SettingsUpdateSuccess(event.key));
      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  void _onDeleteSetting(
      DeleteSetting event, Emitter<SettingsState> emit) async {
    try {
      await settingsRepository.deleteData(event.key);
      add(LoadSettings());
      emit(SettingsDeleteSuccess(event.key));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
}
