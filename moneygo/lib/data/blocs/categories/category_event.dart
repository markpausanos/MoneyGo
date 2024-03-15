import 'package:equatable/equatable.dart';
import 'package:moneygo/data/app_database.dart';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object> get props => [];

  const CategoryEvent();
}

class LoadCategories extends CategoryEvent {}

class AddCategory extends CategoryEvent {
  final CategoriesCompanion category;

  AddCategory(this.category);

  @override
  List<Object> get props => [category];
}

class DeleteCategory extends CategoryEvent {
  final int categoryId;

  DeleteCategory(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}
