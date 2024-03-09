import 'package:moneygo/data/models/category.dart';

class SourceCategory extends Category {
  double amount = 0;

  SourceCategory({
    required super.id,
    required super.name,
  }) {
    amount = 0.0;
  }
}
