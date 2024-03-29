import 'package:drift/drift.dart';
import 'package:moneygo/data/tables/savings/savings_logs.dart';
import 'package:moneygo/data/tables/savings/savings.dart';

@DataClassName('SavingsTransfer')
class SavingsTransfers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get savingsLogId => integer().customConstraint(
      'REFERENCES savings_logs(id) ON DELETE CASCADE NOT NULL')();
  IntColumn get fromSavingsId => integer()
      .customConstraint('REFERENCES savings(id) ON DELETE CASCADE NOT NULL')();
  IntColumn get toSavingsId => integer()
      .customConstraint('REFERENCES savings(id) ON DELETE CASCADE NOT NULL')();
}
