import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/blocs/categories/category_event.dart';
import 'package:moneygo/data/blocs/categories/category_state.dart';
import 'package:moneygo/data/dao/categories.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoriesDao categoriesDao;

  CategoryBloc({required this.categoriesDao}) : super(CategoriesLoading()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<DeleteCategory>(_onDeleteCategory);
  }

  void _onLoadCategories(
      LoadCategories event, Emitter<CategoryState> emit) async {
    try {
      final categories = await categoriesDao.getAllCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }

  void _onAddCategory(AddCategory event, Emitter<CategoryState> emit) async {
    try {
      await categoriesDao.insertCategory(event.category);
      final categories = await categoriesDao.getAllCategories();
      emit(CategoriesSaveSuccess(event.category.name.value));
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }

  void _onDeleteCategory(
      DeleteCategory event, Emitter<CategoryState> emit) async {
    try {
      await categoriesDao.deleteCategoryById(event.categoryId);
      add(LoadCategories());
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }
}
