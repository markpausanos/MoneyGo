import 'package:drift/drift.dart';
import 'package:moneygo/data/tables/savings/savings_logs.dart';
import 'package:moneygo/data/tables/savings/savings.dart';
import 'package:moneygo/data/tables/budget/sources.dart';

@DataClassName('SavingsOut')
class SavingsOuts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get savingsLogId => integer().customConstraint(
      'REFERENCES savings_logs(id) ON DELETE CASCADE NOT NULL')();
  IntColumn get savingsId => integer()
      .customConstraint('REFERENCES savings(id) ON DELETE CASCADE NOT NULL')();
  IntColumn get sourceId => integer()
      .customConstraint('REFERENCES sources(id) ON DELETE CASCADE NOT NULL')();
}
