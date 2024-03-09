import 'package:drift/drift.dart';
import 'tables/account_table.dart';
import 'tables/budget_category.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Accounts, BudgetCategories])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}
