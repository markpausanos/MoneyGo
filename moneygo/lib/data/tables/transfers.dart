import 'package:drift/drift.dart';
import 'package:moneygo/data/tables/transactions.dart';
import 'package:moneygo/data/tables/sources.dart';

@DataClassName('Transfer')
class Transfers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transactionId => integer().customConstraint(
      'REFERENCES transactions(id) ON DELETE CASCADE NOT NULL')();
  IntColumn get fromSourceId =>
      integer().customConstraint('REFERENCES sources(id)').nullable()();
  IntColumn get toSourceId =>
      integer().customConstraint('REFERENCES sources(id)').nullable()();
}
