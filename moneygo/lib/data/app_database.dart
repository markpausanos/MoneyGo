import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:moneygo/data/tables/budget/categories.dart';
import 'package:moneygo/data/tables/budget/expenses.dart';
import 'package:moneygo/data/tables/budget/incomes.dart';
import 'package:moneygo/data/tables/budget/periods.dart';
import 'package:moneygo/data/tables/budget/sources.dart';
import 'package:moneygo/data/tables/budget/transactions.dart';
import 'package:moneygo/data/tables/budget/transfers.dart';
import 'package:moneygo/data/tables/savings/savings_ins.dart';
import 'package:moneygo/data/tables/savings/savings_logs.dart';
import 'package:moneygo/data/tables/savings/savings_outs.dart';
import 'package:moneygo/data/tables/savings/savings_transfers.dart';
import 'package:moneygo/data/tables/savings/savings.dart';
import 'package:moneygo/data/tables/savings/vaults.dart';
import 'package:moneygo/utils/enums.dart';
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
  Periods,
  Vaults,
  Savings,
  SavingsLogs,
  SavingsIns,
  SavingsOuts,
  SavingsTransfers,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 2; // Increment the schema version

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) {
          // When creating the database, create all tables
          return m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from == 1) {
            await m.createTable(vaults);
            await m.createTable(savings);
            await m.createTable(savingsLogs);
            await m.createTable(savingsIns);
            await m.createTable(savingsOuts);
            await m.createTable(savingsTransfers);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'moneygo.db'));

    return NativeDatabase(file);
  });
}
