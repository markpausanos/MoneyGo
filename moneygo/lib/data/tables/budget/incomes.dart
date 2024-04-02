import 'package:drift/drift.dart';
import 'package:moneygo/data/tables/budget/sources.dart';
import 'package:moneygo/data/tables/budget/transactions.dart';

@DataClassName('Income')
class Incomes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transactionId => integer().customConstraint(
      'REFERENCES transactions(id) ON DELETE CASCADE NOT NULL')();
  IntColumn get placedOnsourceId => integer()
      .customConstraint('REFERENCES sources(id) ON DELETE CASCADE NOT NULL')();
  RealColumn get updatedBalance => real().withDefault(const Constant(0.0))();
}
