import 'package:flutter/material.dart';
import 'package:moneygo/routes.dart';
import 'package:provider/provider.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/ui/widgets/Themes/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase(openConnection());
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return Provider<AppDatabase>(
      create: (_) => database,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        routes: AppRoutes.routes,
      ),
    );
  }
}
