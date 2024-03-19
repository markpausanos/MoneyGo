import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:moneygo/data/tables/categories.dart';
import 'package:moneygo/data/tables/expenses.dart';
import 'package:moneygo/data/tables/incomes.dart';
import 'package:moneygo/data/tables/periods.dart';
import 'package:moneygo/data/tables/sources.dart';
import 'package:moneygo/data/tables/transactions.dart';
import 'package:moneygo/data/tables/transfers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Categories,
  Sources,
  Transactions,
  Transfers,
  Incomes,
  Expenses,
  Periods
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      });
}

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'moneygo.db'));

    return NativeDatabase(file);
  });
}
