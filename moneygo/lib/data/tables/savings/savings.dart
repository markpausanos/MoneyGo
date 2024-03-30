import 'package:drift/drift.dart';
import 'package:moneygo/data/tables/savings/vaults.dart';

@DataClassName('Saving')
class Savings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  RealColumn get amount => real().withDefault(const Constant(0.0))();
  IntColumn get vaultId => integer()
      .customConstraint('REFERENCES vaults(id) ON DELETE CASCADE NOT NULL')();
  RealColumn get goalAmount => real().nullable()();
  DateTimeColumn get goalEndDate => dateTime().nullable()();
  DateTimeColumn get dateCreated =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dateUpdated =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  IntColumn get order => integer().withDefault(const Constant(0))();
}
