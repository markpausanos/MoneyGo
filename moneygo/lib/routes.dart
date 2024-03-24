import 'package:flutter/material.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/models/expense_model.dart';
import 'package:moneygo/data/models/income_model.dart';
import 'package:moneygo/data/models/interfaces/transaction_subtype.dart';
import 'package:moneygo/ui/screens/categories.dart';
import 'package:moneygo/ui/screens/edit_expense.dart';
import 'package:moneygo/ui/screens/edit_income.dart';
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
      case '/expense/edit':
        final Map<String, dynamic> args =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => EditExpenseScreen(
            transaction: args['transaction'] as Transaction,
            expense: args['expense'] as ExpenseModel,
            previousRoute: args['previousRoute'] as String?,
          ),
        );

      case '/income/new':
        return MaterialPageRoute(builder: (_) => const NewIncomeScreen());
      case '/income/edit':
        final Map<String, dynamic> args =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => EditIncomeScreen(
            transaction: args['transaction'] as Transaction,
            income: args['income'] as IncomeModel,
            previousRoute: args['previousRoute'] as String?,
          ),
        );

      case '/transfer/new':
        return MaterialPageRoute(builder: (_) => const NewTransferScreen());

      case '/transactions':
        return MaterialPageRoute(builder: (_) => const TransactionsScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
