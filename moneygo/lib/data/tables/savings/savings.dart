import 'package:drift/drift.dart';
import 'package:moneygo/data/tables/savings/vaults.dart';

@DataClassName('Saving')
class Savings extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  IntColumn get vaultId => integer()
      .customConstraint('REFERENCES vaults(id) ON DELETE CASCADE NOT NULL')();
  RealColumn get goalAmount => real().nullable()();
  DateTimeColumn get goalEndDate => dateTime().nullable()();
  DateTimeColumn get dateCreated =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dateUpdated =>
      dateTime().withDefault(currentDateAndTime).nullable()();
}
