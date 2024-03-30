import 'package:equatable/equatable.dart';
import 'package:moneygo/data/app_database.dart';

abstract class PeriodEvent extends Equatable {
  @override
  List<Object> get props => [];

  const PeriodEvent();
}

class LoadPeriods extends PeriodEvent {}

class AddPeriod extends PeriodEvent {
  final PeriodsCompanion period;

  const AddPeriod(this.period);

  @override
  List<Object> get props => [period];
}

class UpdatePeriod extends PeriodEvent {
  final Period period;

  const UpdatePeriod(this.period);

  @override
  List<Object> get props => [period];
}

class DeletePeriod extends PeriodEvent {
  final Period period;

  const DeletePeriod(this.period);

  @override
  List<Object> get props => [period];
}
