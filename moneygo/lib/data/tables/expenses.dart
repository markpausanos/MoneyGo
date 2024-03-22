import 'package:drift/drift.dart';
import 'package:moneygo/data/tables/transactions.dart';
import 'package:moneygo/data/tables/sources.dart';
import 'package:moneygo/data/tables/categories.dart';

@DataClassName('Expense')
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transactionId => integer().customConstraint(
      'REFERENCES transactions(id) ON DELETE CASCADE NOT NULL')();
  IntColumn get sourceId => integer()
      .customConstraint('REFERENCES sources(id) ON DELETE CASCADE NOT NULL')();
  IntColumn get categoryId => integer()
      .customConstraint('REFERENCES categories(id) ON DELETE SET NULL')
      .nullable()();
}
