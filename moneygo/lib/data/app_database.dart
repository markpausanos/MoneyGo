import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:moneygo/data/tables/sources.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'tables/categories.dart';
import 'tables/transactions.dart';
import 'tables/transfers.dart';
import 'tables/incomes.dart';
import 'tables/expenses.dart';

part 'app_database.g.dart';

@DriftDatabase(
    tables: [Categories, Sources, Transactions, Transfers, Incomes, Expenses])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'moneygo.db'));
    return NativeDatabase(file);
  });
}
