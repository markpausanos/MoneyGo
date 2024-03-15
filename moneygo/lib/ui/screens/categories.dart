import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/blocs/categories/category_bloc.dart';
import 'package:moneygo/data/blocs/categories/category_event.dart';
import 'package:moneygo/data/blocs/categories/category_state.dart';
import 'package:moneygo/data/dao/categories.dart';
import 'package:moneygo/data/tables/categories.dart';
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

  List<Category> categories = [];
  Map<int, bool> checkedStates = {};
  bool containsChecked = false;

  @override
  void initState() {
    super.initState();

    for (final category in categories) {
      checkedStates[category.id] = false;
    }
    BlocProvider.of<CategoryBloc>(context).add(LoadCategories());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state is CategoriesSaveSuccess) {
          _showSnackBarAddCategory(state.name);
        }
      },
      child: Scaffold(
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
              onPressed: () {},
              icon: Icons.restart_alt_rounded,
              color: Colors.white,
            )
          ],
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(25.0, 10.0, 18.0, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(
                          milliseconds: 200), // Adjust the duration as needed
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      child: IconButton(
                          key: Key(containsChecked.toString()),
                          onPressed: () {
                            containsChecked
                                ? _unselectAllCategories()
                                : _selectAllCategories();
                          },
                          icon: containsChecked
                              ? const Icon(
                                  Icons.cancel_rounded,
                                  color: CustomColorScheme.appRed,
                                )
                              : const Icon(
                                  Icons.select_all,
                                  color: CustomColorScheme.appBlue,
                                )),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      child: IconButton(
                        key: Key(containsChecked.toString()),
                        onPressed: containsChecked
                            ? _showDeleteConfirmationDialog
                            : _showAddCategoryDialog,
                        icon: containsChecked
                            ? const Icon(
                                Icons.delete_rounded,
                                color: CustomColorScheme.appRed,
                              )
                            : const Icon(
                                Icons.add_circle_outline_rounded,
                                color: CustomColorScheme.appGreen,
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoriesLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is CategoriesLoaded) {
                      categories = state.categories;
                      return _buildCategoryList(state.categories);
                    } else if (state is CategoriesError) {
                      return Text('Error: ${state.message}');
                    } else {
                      return const Text('No categories found');
                    }
                  },
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildCategoryList(List<Category> categories) {
    return Column(
      children: categories.map((category) {
        return Column(
          children: [
            CheckBoxWithItem(
              isChecked: checkedStates[category.id] ?? false,
              onChanged: (bool? value) {
                setState(() {
                  checkedStates[category.id] = value ?? false;
                  containsChecked = checkedStates.containsValue(true);
                });
              },
              id: category.id,
              name: category.name,
              budget: category.maxBudget ?? 0.0,
            ),
            const SizedBox(height: 10),
          ],
        );
      }).toList(),
    );
  }

  void _validateForm() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop('save');
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _showSnackBarAddCategory(String categoryName) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: CustomColorScheme.appGreen,
      content: Text('Category $categoryName added'),
      duration: const Duration(seconds: 2),
    ));
  }

  void _selectAllCategories() {
    setState(() {
      for (final category in categories) {
        checkedStates[category.id] = true;
      }
      containsChecked = true;
    });
  }

  void _unselectAllCategories() {
    setState(() {
      for (final category in categories) {
        checkedStates[category.id] = false;
      }
      containsChecked = false;
    });
  }

  Future<void> _saveCategory() async {
    final String name = _nameController.text;
    final String budgetString = _budgetController.text;
    final double? budget = double.tryParse(budgetString);

    if (name.isNotEmpty && budget != null) {
      final category = CategoriesCompanion(
          name: Value(name), maxBudget: Value(budget), balance: Value(budget));

      BlocProvider.of<CategoryBloc>(context).add(AddCategory(category));

      _nameController.clear();
      _budgetController.clear();
    }
  }

  Future<void> _deleteCategories() async {
    List<int> categoryIdsToDelete = categories
        .where((category) => checkedStates[category.id] ?? false)
        .map((category) => category.id)
        .toList();

    for (final categoryId in categoryIdsToDelete) {
      BlocProvider.of<CategoryBloc>(context).add(DeleteCategory(categoryId));
    }

    setState(() {
      checkedStates.clear();
      containsChecked = false;
    });
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
                color: CustomColorScheme.appGreen,
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
                            borderSide:
                                BorderSide(color: CustomColorScheme.appRed))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      _validateForm();
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _budgetController,
                    decoration: const InputDecoration(
                        labelText: 'Budget',
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColorScheme.appRed))),
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
                      _validateForm();
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(onPressed: _validateForm, child: const Text('Save'))
          ],
        );
      },
    );

    if (result == 'save') {
      await _saveCategory();
    }
  }

  Future<void> _showDeleteConfirmationDialog() async {
    final bool? result = await showDialog<bool>(
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
                color: CustomColorScheme.appRed,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)),
              ),
              child: const Column(
                children: [
                  SizedBox(height: 15.0),
                  Center(
                    child: Text(
                      'Delete Categories',
                      style: CustomTextStyleScheme.dialogTitle,
                    ),
                  ),
                  SizedBox(height: 15.0),
                ],
              )),
          content: const SingleChildScrollView(
            child: Center(
              child: Text(
                  'Are you sure you want to delete the selected categories?',
                  style: CustomTextStyleScheme.dialogBody,
                  textAlign: TextAlign.center),
            ),
          ),
          actions: <Widget>[
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                CustomColorScheme.dialogButtonCancel),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            )),
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.black))),
                    const SizedBox(width: 10.0),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                CustomColorScheme.appRed),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            )),
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Delete',
                            style: TextStyle(color: Colors.white)))
                  ],
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ],
        );
      },
    );

    if (result ?? false) {
      await _deleteCategories();
    }
  }
}
