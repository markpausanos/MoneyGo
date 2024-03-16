import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/blocs/categories/category_bloc.dart';
import 'package:moneygo/data/daos/category_dao.dart';
import 'package:moneygo/data/repositories/category_repository.dart';
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
        BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc(
            categoryRepository: CategoryRepository(CategoryDao(context.read())),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        routes: AppRoutes.routes,
      ),
    );
  }
}
