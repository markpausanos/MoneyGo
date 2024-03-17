import 'package:equatable/equatable.dart';
import 'package:moneygo/data/app_database.dart';

abstract class SourceState extends Equatable {
  @override
  List<Object> get props => [];
}

class SourcesLoading extends SourceState {}

class SourcesLoaded extends SourceState {
  final List<Source> sources;

  SourcesLoaded(this.sources);

  @override
  List<Object> get props => [sources];
}

class SourcesError extends SourceState {
  final String message;

  SourcesError(this.message);

  @override
  List<Object> get props => [message];
}

class SourcesSaveSuccess extends SourceState {
  final String name;

  SourcesSaveSuccess(this.name);

  @override
  List<Object> get props => [name];
}

class SourcesUpdateSuccess extends SourceState {
  final String name;

  SourcesUpdateSuccess(this.name);

  @override
  List<Object> get props => [name];
}

class SourcesDeleteSuccess extends SourceState {}
