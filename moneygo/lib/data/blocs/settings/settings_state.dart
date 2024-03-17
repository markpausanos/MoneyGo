import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {
  @override
  List<Object> get props => [];
}

class SettingsLoading extends SettingsState {}

class SettingsError extends SettingsState {
  final String message;

  SettingsError(this.message);

  @override
  List<Object> get props => [message];
}

class SettingsLoaded extends SettingsState {
  final Map<String, String> settings;

  SettingsLoaded(this.settings);

  @override
  List<Object> get props => [settings];
}

class SettingsSaveSuccess extends SettingsState {
  final String key;

  SettingsSaveSuccess(this.key);

  @override
  List<Object> get props => [key];
}

class SettingsUpdateSuccess extends SettingsState {
  final String key;

  SettingsUpdateSuccess(this.key);

  @override
  List<Object> get props => [key];
}

class SettingsDeleteSuccess extends SettingsState {
  final String key;

  SettingsDeleteSuccess(this.key);

  @override
  List<Object> get props => [key];
}
