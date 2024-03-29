import 'package:flutter/material.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/models/budget/expense_model.dart';
import 'package:moneygo/data/models/budget/income_model.dart';
import 'package:moneygo/data/models/budget/transfer_model.dart';
import 'package:moneygo/ui/screens/budget/categories/categories.dart';
import 'package:moneygo/ui/screens/budget/categories/view_categories/view_category.dart';
import 'package:moneygo/ui/screens/budget/sources/view_sources/view_source.dart';
import 'package:moneygo/ui/screens/budget/transactions/edit_transactions/edit_expense.dart';
import 'package:moneygo/ui/screens/budget/transactions/edit_transactions/edit_income.dart';
import 'package:moneygo/ui/screens/budget/transactions/edit_transactions/edit_transfer.dart';
import 'package:moneygo/ui/screens/home.dart';
import 'package:moneygo/ui/screens/budget/transactions/new_transactions/new_expense.dart';
import 'package:moneygo/ui/screens/budget/transactions/new_transactions/new_income.dart';
import 'package:moneygo/ui/screens/budget/transactions/new_transactions/new_transfer.dart';
import 'package:moneygo/ui/screens/budget/sources/sources.dart';
import 'package:moneygo/ui/screens/budget/transactions/transactions.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case '/categories':
        return MaterialPageRoute(builder: (_) => const CategoriesScreen());
      case '/categories/view':
        final Category category = settings.arguments as Category;
        return MaterialPageRoute(
          builder: (_) => ViewCategoryScreen(category: category),
        );

      case '/sources':
        return MaterialPageRoute(builder: (_) => const SourcesScreen());
      case '/sources/view':
        final Source source = settings.arguments as Source;
        return MaterialPageRoute(
          builder: (_) => ViewSourceScreen(source: source),
        );

      case '/transactions':
        return MaterialPageRoute(builder: (_) => const TransactionsScreen());

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
      case '/transfer/edit':
        final Map<String, dynamic> args =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => EditTransferScreen(
            transaction: args['transaction'] as Transaction,
            transfer: args['transfer'] as TransferModel,
            previousRoute: args['previousRoute'] as String?,
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
