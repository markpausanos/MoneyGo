import 'package:flutter/widgets.dart';
import 'package:moneygo/ui/screens/categories.dart';
import 'package:moneygo/ui/screens/home.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const HomeScreen(username: "markpausanos"),
    '/home': (context) => const HomeScreen(username: "markpausanos"),
    '/categories': (context) => const CategoriesScreen()
  };
}
