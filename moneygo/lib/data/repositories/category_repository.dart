import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/daos/category_dao.dart';

class CategoryRepository {
  final CategoryDao _categoriesDao;

  CategoryRepository(this._categoriesDao);

  Stream<List<Category>> watchAllCategories() =>
      _categoriesDao.watchAllCategories();

  Future<List<Category>> getAllCategories() async {
    var categories = await _categoriesDao.getAllCategories();

    return categories
        .where((category) => category.dateDeleted == null)
        .toList();
  }

  Future<Category?> getCategoryById(int id) async =>
      await _categoriesDao.getCategoryById(id);

  Future<int> insertCategory(CategoriesCompanion category) async {
    if (category.maxBudget.value == null) {
      throw Exception('Max budget cannot be null');
    } else if (category.maxBudget.value! < 0) {
      throw Exception('Max budget cannot be negative');
    }

    return await _categoriesDao.insertCategory(category);
  }

  Future<bool> updateCategory(Category category) async {
    if (category.maxBudget == null) {
      throw Exception('Max budget cannot be null');
    } else if (category.maxBudget! < 0) {
      throw Exception('Max budget cannot be negative');
    }

    return await _categoriesDao.updateCategory(category);
  }

  Future<bool> deleteCategory(Category category) {
    category = category.copyWith(dateDeleted: Value(DateTime.now()));

    return _categoriesDao.updateCategory(category);
  }

  Future<bool> deleteCategoryById(int id) async {
    var category = await getCategoryById(id);

    if (category == null) {
      throw Exception('Category not found');
    }

    category = category.copyWith(dateDeleted: Value(DateTime.now()));

    return await _categoriesDao.updateCategory(category);
  }
}
