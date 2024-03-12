import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/dao/categories.dart';
import 'package:moneygo/ui/widgets/CheckBoxWithItem/checkbox_with_item.dart';
import 'package:moneygo/ui/widgets/IconButton/large_icon_button.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _nameController = TextEditingController();
  final _budgetController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

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
              decoration: const BoxDecoration(
                color: CustomColorScheme.appBarCategories,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)),
              ),
              child: const Column(
                children: [
                  SizedBox(height: 15.0),
                  Center(
                    child: Text(
                      'Add New Category',
                      style: CustomTextStyleScheme.dialogTitle,
                    ),
                  ),
                  SizedBox(height: 15.0),
                ],
              )),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidate
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    controller: _nameController,
                    decoration: const InputDecoration(
                        labelText: 'Name',
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      validateForm();
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _budgetController,
                    decoration: const InputDecoration(
                        labelText: 'Budget',
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          double.tryParse(value) == null) {
                        return 'Please enter a proper budget';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      validateForm();
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(onPressed: validateForm, child: const Text('Save'))
          ],
        );
      },
    );

    if (result == 'save') {
      await _saveCategory();
    }
  }

  void validateForm() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop('save');
    } else {
      setState(() {
        _autoValidate = true;
      });
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

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Category '$name' saved successfully"),
              backgroundColor: Colors.green,
            ),
          );
        }
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomColorScheme.appBarCategories,
        leading: IconButtonLarge(
            onPressed: () => Navigator.pop(context),
            icon: Icons.arrow_back,
            color: Colors.white),
        title: const Text('Categories',
            style: CustomTextStyleScheme.appBarTitleCategories),
        centerTitle: true,
        actions: [
          IconButtonLarge(
            onPressed: _showAddCategoryDialog,
            icon: Icons.add_circle_rounded,
            color: Colors.white,
          )
        ],
      ),
      body: const SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 18.0, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [SizedBox(height: 20), CheckBoxWithItem()],
          )),
    );
  }
}
