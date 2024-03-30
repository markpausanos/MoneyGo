import 'package:equatable/equatable.dart';
import 'package:moneygo/data/app_database.dart';

abstract class SourceEvent extends Equatable {
  @override
  List<Object> get props => [];

  const SourceEvent();
}

class LoadSources extends SourceEvent {}

class AddSource extends SourceEvent {
  final SourcesCompanion source;

  const AddSource(this.source);

  @override
  List<Object> get props => [source];
}

class UpdateSource extends SourceEvent {
  final Source source;

  const UpdateSource(this.source);

  @override
  List<Object> get props => [source];
}

class DeleteSource extends SourceEvent {
  final int sourceId;

  const DeleteSource(this.sourceId);

  @override
  List<Object> get props => [sourceId];
}
