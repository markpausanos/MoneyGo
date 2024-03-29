import 'package:drift/drift.dart';
import 'package:moneygo/data/tables/budget/transactions.dart';
import 'package:moneygo/data/tables/budget/sources.dart';

@DataClassName('Transfer')
class Transfers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transactionId => integer().customConstraint(
      'REFERENCES transactions(id) ON DELETE CASCADE NOT NULL')();
  IntColumn get fromSourceId => integer()
      .customConstraint('REFERENCES sources(id) ON DELETE CASCADE NOT NULL')();
  IntColumn get toSourceId => integer()
      .customConstraint('REFERENCES sources(id) ON DELETE CASCADE NOT NULL')();
}
