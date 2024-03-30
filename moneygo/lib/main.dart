import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/blocs/backups/backup_bloc.dart';
import 'package:moneygo/data/blocs/backups/backup_event.dart';
import 'package:moneygo/data/blocs/budget/categories/category_bloc.dart';
import 'package:moneygo/data/blocs/budget/periods/period_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_bloc.dart';
import 'package:moneygo/data/blocs/budget/sources/source_bloc.dart';
import 'package:moneygo/data/blocs/budget/transactions/transaction_bloc.dart';
import 'package:moneygo/data/daos/budget/category_dao.dart';
import 'package:moneygo/data/daos/budget/expense_dao.dart';
import 'package:moneygo/data/daos/budget/income_dao.dart';
import 'package:moneygo/data/daos/budget/period_dao.dart';
import 'package:moneygo/data/daos/budget/source_dao.dart';
import 'package:moneygo/data/daos/budget/transaction_dao.dart';
import 'package:moneygo/data/daos/budget/transfer_dao.dart';
import 'package:moneygo/data/repositories/backup_repository.dart';
import 'package:moneygo/data/repositories/budget/category_repository.dart';
import 'package:moneygo/data/repositories/budget/period_repository.dart';
import 'package:moneygo/data/repositories/settings_repository.dart';
import 'package:moneygo/data/repositories/budget/source_repository.dart';
import 'package:moneygo/data/repositories/budget/transaction_repository.dart';
import 'package:moneygo/routes.dart';
import 'package:moneygo/ui/widgets/Themes/app_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await initDatabase();
  final path = '${(await getApplicationDocumentsDirectory()).path}/moneygo.db';

  runApp(
    BlocProvider<BackupBloc>(
      create: (context) => BackupBloc(
        backupRepository: BackupRepository(path, database),
      ),
      child: MyApp(database: database, path: path),
    ),
  );
}

Future<AppDatabase> initDatabase() async {
  return AppDatabase(openConnection());
}

class MyApp extends StatefulWidget {
  final AppDatabase database;
  final String path;

  const MyApp({super.key, required this.database, required this.path});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<BackupBloc>(context).add(AddBackup());
  }

  @override
  Widget build(BuildContext context) {
    final periodDao = PeriodDao(widget.database);
    final categoryDao = CategoryDao(widget.database);
    final incomeDao = IncomeDao(widget.database);
    final expenseDao = ExpenseDao(widget.database);
    final sourceDao = SourceDao(widget.database);
    final transactionDao = TransactionDao(widget.database);
    final transferDao = TransferDao(widget.database);

    final backUpRepository = BackupRepository(widget.path, widget.database);
    final settingsRepository = SettingsRepository();
    final sourceRepository = SourceRepository(sourceDao);
    final periodRepository = PeriodRepository(periodDao, categoryDao);
    final categoryRepository =
        CategoryRepository(categoryDao, periodRepository);
    final transactionRepository = TransactionRepository(
      transactionDao,
      expenseDao,
      sourceDao,
      categoryDao,
      incomeDao,
      transferDao,
      periodDao,
    );

    return MultiProvider(
      providers: [
        Provider<AppDatabase>(create: (_) => widget.database),
        BlocProvider<BackupBloc>(
          create: (context) => BackupBloc(
            backupRepository: backUpRepository,
          ),
        ),
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(
            settingsRepository: settingsRepository,
          ),
        ),
        BlocProvider<CategoryBloc>(
            create: (context) => CategoryBloc(
                  categoryRepository: categoryRepository,
                )),
        BlocProvider<SourceBloc>(
          create: (context) => SourceBloc(
            sourceRepository: sourceRepository,
          ),
        ),
        BlocProvider<PeriodBloc>(
            create: (context) => PeriodBloc(
                  periodRepository: periodRepository,
                )),
        BlocProvider<TransactionBloc>(
            create: (context) => TransactionBloc(
                  transactionRepository: transactionRepository,
                )),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
