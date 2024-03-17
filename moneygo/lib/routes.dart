import 'package:flutter/widgets.dart';
import 'package:moneygo/ui/screens/categories.dart';
import 'package:moneygo/ui/screens/home.dart';
import 'package:moneygo/ui/screens/sources.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const HomeScreen(),
    '/home': (context) => const HomeScreen(),
    '/categories': (context) => const CategoriesScreen(),
    '/sources': (context) => const SourcesScreen(),
  };
}
