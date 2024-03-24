import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/blocs/categories/category_event.dart';
import 'package:moneygo/data/blocs/categories/category_state.dart';
import 'package:moneygo/data/repositories/category_repository.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryBloc({required this.categoryRepository})
      : super(CategoriesLoading()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
  }

  void _onLoadCategories(
      LoadCategories event, Emitter<CategoryState> emit) async {
    try {
      final categories = await categoryRepository.getAllCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }

  void _onAddCategory(AddCategory event, Emitter<CategoryState> emit) async {
    try {
      await categoryRepository.insertCategory(event.category);
      final categories = await categoryRepository.getAllCategories();

      emit(CategoriesSaveSuccess(event.category.name.value));
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }

  void _onUpdateCategory(
      UpdateCategory event, Emitter<CategoryState> emit) async {
    try {
      await categoryRepository.updateCategory(event.category);
      final categories = await categoryRepository.getAllCategories();
      emit(CategoriesUpdateSuccess(event.category.name));
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }

  void _onDeleteCategory(
      DeleteCategory event, Emitter<CategoryState> emit) async {
    try {
      await categoryRepository.deleteCategoryById(event.categoryId);
      add(LoadCategories());
      emit(CategoriesDeleteSuccess());
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }
}
