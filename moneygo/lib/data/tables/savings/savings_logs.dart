import 'package:drift/drift.dart';
import 'package:moneygo/utils/enums.dart';

@DataClassName('SavingsLog')
class SavingsLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get dateCreated =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dateUpdated =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  IntColumn get type => intEnum<SavingTransactionTypes>()();
}
