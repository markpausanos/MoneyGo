import "package:moneygo/data/models/category.dart";

class BudgetCategory extends Category {
  double? maxAmount;
  double? currentAmount;

  BudgetCategory({
    required super.id,
    required super.name,
    this.maxAmount,
    this.currentAmount,
  });
}
