import 'package:drift/drift.dart';
import 'package:moneygo/data/tables/sources.dart';
import 'package:moneygo/data/tables/transactions.dart';

@DataClassName('Income')
class Incomes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transactionId => integer().customConstraint(
      'REFERENCES transactions(id) ON DELETE CASCADE NOT NULL')();
  IntColumn get placedOnsourceId => integer()
      .customConstraint('REFERENCES sources(id) ON DELETE CASCADE NOT NULL')();
}
