import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/blocs/categories/category_bloc.dart';
import 'package:moneygo/data/blocs/periods/period_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_bloc.dart';
import 'package:moneygo/data/blocs/sources/source_bloc.dart';
import 'package:moneygo/data/blocs/transactions/transaction_bloc.dart';
import 'package:moneygo/data/daos/category_dao.dart';
import 'package:moneygo/data/daos/expense_dao.dart';
import 'package:moneygo/data/daos/income_dao.dart';
import 'package:moneygo/data/daos/period_dao.dart';
import 'package:moneygo/data/daos/source_dao.dart';
import 'package:moneygo/data/daos/transaction_dao.dart';
import 'package:moneygo/data/daos/transfer_dao.dart';
import 'package:moneygo/data/repositories/category_repository.dart';
import 'package:moneygo/data/repositories/period_repository.dart';
import 'package:moneygo/data/repositories/settings_repository.dart';
import 'package:moneygo/data/repositories/source_repository.dart';
import 'package:moneygo/data/repositories/transaction_repository.dart';
import 'package:moneygo/routes.dart';
import 'package:moneygo/ui/widgets/Themes/app_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await initDatabase();
  runApp(MyApp(database: database));
}

Future<AppDatabase> initDatabase() async {
  return AppDatabase(openConnection());
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>(create: (_) => database),
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(
            settingsRepository: SettingsRepository(),
          ),
        ),
        BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc(
            categoryRepository: CategoryRepository(
                CategoryDao(context.read()), PeriodDao(context.read())),
          ),
        ),
        BlocProvider<SourceBloc>(
          create: (context) => SourceBloc(
            sourceRepository: SourceRepository(SourceDao(context.read())),
          ),
        ),
        BlocProvider<PeriodBloc>(
          create: (context) => PeriodBloc(
            periodRepository: PeriodRepository(
                PeriodDao(context.read()), CategoryDao(context.read())),
          ),
        ),
        BlocProvider<TransactionBloc>(
          create: (context) => TransactionBloc(
            transactionRepository: TransactionRepository(
              TransactionDao(context.read()),
              ExpenseDao(context.read()),
              SourceDao(context.read()),
              CategoryDao(context.read()),
              IncomeDao(context.read()),
              TransferDao(context.read()),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
