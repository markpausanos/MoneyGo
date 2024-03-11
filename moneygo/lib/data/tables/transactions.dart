import 'package:drift/drift.dart';

@DataClassName('Transaction')
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get dateCreated =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dateUpdated =>
      dateTime().withDefault(currentDateAndTime).nullable()();
}
