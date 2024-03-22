import 'package:flutter/material.dart';
import 'package:moneygo/ui/screens/categories.dart';
import 'package:moneygo/ui/screens/home.dart';
import 'package:moneygo/ui/screens/new_expense.dart';
import 'package:moneygo/ui/screens/new_income.dart';
import 'package:moneygo/ui/screens/new_transfer.dart';
import 'package:moneygo/ui/screens/sources.dart';
import 'package:moneygo/ui/screens/transactions.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/categories':
        return MaterialPageRoute(builder: (_) => const CategoriesScreen());
      case '/sources':
        return MaterialPageRoute(builder: (_) => const SourcesScreen());
      case '/expense/new':
        return MaterialPageRoute(builder: (_) => const NewExpenseScreen());
      case '/income/new':
        return MaterialPageRoute(builder: (_) => const NewIncomeScreen());
      case '/transfer/new':
        return MaterialPageRoute(builder: (_) => const NewTransferScreen());
      case '/transactions':
        return MaterialPageRoute(builder: (_) => const TransactionsScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
