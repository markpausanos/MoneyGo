import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/daos/category_dao.dart';

class CategoryRepository {
  final CategoryDao _categoriesDao;

  CategoryRepository(this._categoriesDao);

  Stream<List<Category>> watchAllCategories() =>
      _categoriesDao.watchAllCategories();

  Future<List<Category>> getAllCategories() async {
    return await _categoriesDao.getAllCategories();
  }

  Future<Category?> getCategoryById(int id) async =>
      await _categoriesDao.getCategoryById(id);

  Future<int> insertCategory(CategoriesCompanion category) async {
    if (category.name.value.isEmpty) {
      throw Exception('Name cannot be empty');
    } else if (category.maxBudget.value < 0) {
      throw Exception('Max budget cannot be negative');
    }

    return await _categoriesDao.insertCategory(category);
  }

  Future<bool> updateCategory(Category category) async {
    if (category.name.isEmpty) {
      throw Exception('Name cannot be empty');
    } else if (category.maxBudget < 0) {
      throw Exception('Max budget cannot be negative');
    }

    var categoryToBeUpdated = await getCategoryById(category.id);

    if (categoryToBeUpdated == null) {
      throw Exception('Category not found');
    }

    var budgetDifference = category.maxBudget - categoryToBeUpdated.maxBudget;

    category = category.copyWith(
        balance: category.balance + budgetDifference,
        dateUpdated: Value(DateTime.now()),
        periodId: 1);

    return await _categoriesDao.updateCategory(category);
  }

  Future<int> deleteCategory(Category category) async {
    return await _categoriesDao.deleteCategory(category);
  }

  Future<int> deleteCategoryById(int id) async {
    return await _categoriesDao.deleteCategoryById(id);
  }
}
