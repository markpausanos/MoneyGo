import 'package:drift/drift.dart';
import 'package:moneygo/data/tables/periods.dart';

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  RealColumn get maxBudget => real().withDefault(const Constant(0.0))();
  RealColumn get balance => real().withDefault(const Constant(0.0))();
  DateTimeColumn get dateCreated =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dateUpdated =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get dateDeleted => dateTime().nullable()();
  IntColumn get periodId => integer()
      .customConstraint('REFERENCES periods(id) ON DELETE CASCADE NOT NULL')();
}
