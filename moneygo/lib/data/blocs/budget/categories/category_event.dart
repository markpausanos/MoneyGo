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

  const AddCategory(this.category);

  @override
  List<Object> get props => [category];
}

class UpdateCategory extends CategoryEvent {
  final Category category;

  const UpdateCategory(this.category);

  @override
  List<Object> get props => [category];
}

class DeleteCategory extends CategoryEvent {
  final int categoryId;

  const DeleteCategory(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}
