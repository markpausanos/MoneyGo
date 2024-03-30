import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/daos/budget/category_dao.dart';
import 'package:moneygo/data/repositories/budget/period_repository.dart';

class CategoryRepository {
  final CategoryDao _categoriesDao;
  final PeriodRepository _periodRepository;

  CategoryRepository(
    this._categoriesDao,
    this._periodRepository,
  );

  Stream<List<Category>> watchAllCategories() =>
      _categoriesDao.watchAllCategories();

  Future<List<Category>> getAllCategories() async {
    var categories = await _categoriesDao.getAllCategories();
    var period = await _periodRepository.getLatestPeriod();

    var latestPeriod = period;

    categories = categories
        .where((category) => category.periodId == latestPeriod.id)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    // check if all category orders are 0
    if (categories.every((category) => category.order == 0)) {
      for (var i = 0; i < categories.length; i++) {
        categories[i] = categories[i].copyWith(order: i);
        await _categoriesDao.updateCategory(categories[i]);
      }
    }

    return categories;
  }

  Future<Category?> getCategoryById(int id) async =>
      await _categoriesDao.getCategoryById(id);

  Future<int> insertCategory(CategoriesCompanion category) async {
    var categoryCount = (await _categoriesDao.getAllCategories()).length;

    if (category.name.value.isEmpty) {
      throw Exception('Name cannot be empty');
    } else if (category.maxBudget.value < 0) {
      throw Exception('Max budget cannot be negative');
    }

    var period = await _periodRepository.getLatestPeriod();

    category = category.copyWith(
      periodId: Value(period.id),
      order: Value(categoryCount),
    );

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
        dateUpdated: Value(DateTime.now()));

    return await _categoriesDao.updateCategory(category);
  }

  Future<int> deleteCategory(Category category) async {
    return await _categoriesDao.deleteCategory(category);
  }

  Future<int> deleteCategoryById(int id) async {
    return await _categoriesDao.deleteCategoryById(id);
  }
}
