import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/tables/categories.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  Stream<List<Category>> watchAllCategories() => select(categories).watch();

  Future<List<Category>> getAllCategories() async =>
      await select(categories).get();

  Future<Category?> getCategoryById(int id) async =>
      await (select(categories)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<int> insertCategory(CategoriesCompanion category) async =>
      await into(categories).insert(category);

  Future<bool> updateCategory(Category category) async =>
      await update(categories).replace(category);

  Future<int> deleteCategory(Category category) async =>
      await delete(categories).delete(category);

  Future<int> deleteCategoryById(int id) async =>
      await (delete(categories)..where((tbl) => tbl.id.equals(id))).go();
}
