import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/tables/categories.dart';

part 'categories.g.dart';

@DriftAccessor(tables: [Categories])
class CategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$CategoriesDaoMixin {
  CategoriesDao(super.db);

  Future<List<Category>> getAllCategories() => select(categories).get();

  Future<Category?> getCategoryById(int id) =>
      (select(categories)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Stream<List<Category>> watchAllCategories() => select(categories).watch();

  Future<int> insertCategory(CategoriesCompanion category) =>
      into(categories).insert(category);

  Future<bool> updateCategory(Category category) =>
      update(categories).replace(category);

  Future<int> deleteCategory(Category category) =>
      delete(categories).delete(category);

  Future<int> deleteCategoryById(int id) =>
      (delete(categories)..where((tbl) => tbl.id.equals(id))).go();
}
