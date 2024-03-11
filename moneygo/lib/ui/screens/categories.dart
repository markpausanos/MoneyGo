import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/dao/categories.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _nameController = TextEditingController();
  final _budgetController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _showAddCategoryDialog() async {
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          titlePadding: const EdgeInsets.all(0.0),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          buttonPadding: const EdgeInsets.all(0.0),
          title: Container(
              color: CustomColorScheme.appBarCategories,
              child: const Column(
                children: [
                  SizedBox(height: 10.0),
                  Center(
                    child: Text(
                      'Add New Category',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              )),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  controller: _budgetController,
                  decoration: const InputDecoration(labelText: 'Budget'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop('save');
              },
            ),
          ],
        );
      },
    );

    if (result == 'save') {
      await _saveCategory();
    }
  }

  Future<void> _saveCategory() async {
    final String name = _nameController.text;
    final String budgetString = _budgetController.text;
    final double? budget = double.tryParse(budgetString);

    if (name.isNotEmpty && budget != null) {
      final category = CategoriesCompanion(
          name: Value(name), maxBudget: Value(budget), balance: Value(budget));

      final AppDatabase database =
          Provider.of<AppDatabase>(context, listen: false);
      final CategoriesDao categoriesDao = CategoriesDao(database);

      try {
        final int id = await categoriesDao.insertCategory(category);
        print("Category saved with id: $id");
      } catch (e) {
        print("Error saving category: $e");
      }

      _nameController.clear();
      _budgetController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColorScheme.appBarCategories,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white)),
        title: const Text('Categories', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: _showAddCategoryDialog,
              icon: const Icon(
                Icons.add_circle_rounded,
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}
