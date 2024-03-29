import 'package:drift/drift.dart';
import 'package:moneygo/data/tables/budget/periods.dart';
import 'package:moneygo/utils/enums.dart';

@DataClassName('Transaction')
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get dateCreated =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dateUpdated =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  IntColumn get type => intEnum<TransactionTypes>()();
}
