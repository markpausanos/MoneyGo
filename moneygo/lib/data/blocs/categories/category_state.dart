import 'package:equatable/equatable.dart';
import 'package:moneygo/data/app_database.dart';

abstract class CategoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class CategoriesLoading extends CategoryState {}

class CategoriesLoaded extends CategoryState {
  final List<Category> categories;

  CategoriesLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class CategoriesError extends CategoryState {
  final String message;

  CategoriesError(this.message);

  @override
  List<Object> get props => [message];
}

class CategoriesSaveSuccess extends CategoryState {
  final String name;

  CategoriesSaveSuccess(this.name);

  @override
  List<Object> get props => [name];
}
