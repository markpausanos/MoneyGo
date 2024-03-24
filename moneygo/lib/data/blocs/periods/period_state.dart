import 'package:equatable/equatable.dart';
import 'package:moneygo/data/app_database.dart';

abstract class PeriodState extends Equatable {
  @override
  List<Object> get props => [];
}

class PeriodsLoading extends PeriodState {}

class PeriodsLoaded extends PeriodState {
  final Period period;

  PeriodsLoaded(this.period);

  @override
  List<Object> get props => [period];
}

class PeriodsError extends PeriodState {
  final String message;

  PeriodsError(this.message);

  @override
  List<Object> get props => [message];
}

class PeriodsSaveSuccess extends PeriodState {}

class PeriodsUpdateSuccess extends PeriodState {}

class PeriodsDeleteSuccess extends PeriodState {}
