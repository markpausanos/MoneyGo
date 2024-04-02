import 'package:drift/drift.dart';
import 'package:moneygo/data/tables/budget/transactions.dart';
import 'package:moneygo/data/tables/budget/sources.dart';
import 'package:moneygo/data/tables/budget/categories.dart';

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
  RealColumn get updatedBalance => real().withDefault(const Constant(0.0))();
}
