import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  @override
  List<Object> get props => [];

  const SettingsEvent();
}

class LoadSettings extends SettingsEvent {}

class SaveSetting extends SettingsEvent {
  final String key;
  final String value;

  const SaveSetting(this.key, this.value);

  @override
  List<Object> get props => [key, value];
}

class UpdateSetting extends SettingsEvent {
  final String key;
  final String value;

  const UpdateSetting(this.key, this.value);

  @override
  List<Object> get props => [key, value];
}

class DeleteSetting extends SettingsEvent {
  final String key;

  const DeleteSetting(this.key);

  @override
  List<Object> get props => [key];
}
