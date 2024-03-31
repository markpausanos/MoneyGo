import 'package:drift/drift.dart' hide Column;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/blocs/budget/categories/category_bloc.dart';
import 'package:moneygo/data/blocs/budget/categories/category_event.dart';
import 'package:moneygo/data/blocs/budget/categories/category_state.dart';
import 'package:moneygo/data/blocs/settings/settings_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_event.dart';
import 'package:moneygo/data/blocs/settings/settings_state.dart';
import 'package:moneygo/ui/utils/screen_utils.dart';
import 'package:moneygo/ui/widgets/Buttons/dialog_button.dart';
import 'package:moneygo/ui/widgets/CheckBoxWithItem/budget/category_checkbox.dart';
import 'package:moneygo/ui/widgets/IconButton/large_icon_button.dart';
import 'package:moneygo/ui/widgets/Loaders/loading_state.dart';
import 'package:moneygo/ui/widgets/SizedBoxes/dashed_box_with_message.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

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
  bool _isMoved = false;

  final _categoriesNames = ["Custom", "Savings", "Debts"];
  int _currentIndex = 0;
  final Map<int, bool> _checkedStates = {};
  List<Category> _categories = [];
  bool _containsChecked = false;

  @override
  void initState() {
    super.initState();

    for (final category in _categories) {
      _checkedStates[category.id] = false;
    }
    BlocProvider.of<CategoryBloc>(context).add(LoadCategories());
    BlocProvider.of<SettingsBloc>(context).add(LoadSettings());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CategoryBloc, CategoryState>(listener: (context, state) {
          if (state is CategoriesSaveSuccess && !_isMoved) {
            ScreenUtils.showSnackBarAddOrUpdate(
                context, 'Category ${state.name} has been added');
          } else if (state is CategoriesUpdateSuccess && !_isMoved) {
            ScreenUtils.showSnackBarAddOrUpdate(
                context, 'Category has been updated');
          } else if (state is CategoriesDeleteSuccess && !_isMoved) {
            ScreenUtils.showSnackBarDelete(context, 'Category/ies deleted');
          }
        }),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: CustomColorScheme.appBarCards,
          leading: IconButtonLarge(
              onPressed: () => Navigator.popAndPushNamed(context, "/home"),
              icon: Icons.arrow_back,
              color: Colors.white),
          title: const Text('Categories',
              style: CustomTextStyleScheme.appBarTitleCards),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // IconButton left
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _currentIndex = _currentIndex == 0
                              ? _categoriesNames.length - 1
                              : _currentIndex - 1;
                        });
                      },
                      icon: const Icon(Icons.arrow_circle_left,
                          color: CustomColorScheme.appBlue),
                    ),
                    Container(
                      width: 130,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: CustomColorScheme.headerWithText,
                      ),
                      padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                      child: Center(
                        child: Text(_categoriesNames[_currentIndex],
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _currentIndex =
                              _currentIndex == _categoriesNames.length - 1
                                  ? 0
                                  : _currentIndex + 1;
                        });
                      },
                      icon: const Icon(Icons.arrow_circle_right,
                          color: CustomColorScheme.appBlue),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
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
                            key: Key(_containsChecked.toString()),
                            onPressed: () {
                              _categories.isEmpty
                                  ? null
                                  : _containsChecked
                                      ? _unselectAllCategories()
                                      : _selectAllCategories();
                            },
                            icon: _containsChecked
                                ? const Icon(
                                    Icons.cancel_rounded,
                                    color: CustomColorScheme.appRed,
                                  )
                                : const Icon(
                                    Icons.select_all,
                                    color: CustomColorScheme.appBlue,
                                  )),
                      ),
                    ],
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: () {
                      int checkedCount = _checkedStates.values
                          .where((element) => element)
                          .length;

                      if (checkedCount == 2) {
                        return IconButton(
                          key: const ValueKey('swap'),
                          onPressed: _swapSelectedCategories,
                          icon: const Icon(Icons.swap_vert_rounded,
                              color: CustomColorScheme.appBlue),
                        );
                      } else if (checkedCount == 1) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Move to topmost
                            IconButton(
                              key: const ValueKey('top'),
                              onPressed: () {
                                final Category category =
                                    _categories.firstWhere((category) =>
                                        _checkedStates[category.id] ?? false);
                                _moveCategoryToTopMost(category);
                              },
                              icon: const Icon(Icons.vertical_align_top_rounded,
                                  color: CustomColorScheme.appGreen),
                            ),

                            IconButton(
                              key: const ValueKey('singleUp'),
                              onPressed: () {
                                final Category category =
                                    _categories.firstWhere((category) =>
                                        _checkedStates[category.id] ?? false);
                                _moveCategoryUp(category);
                              },
                              icon: const Icon(Icons.move_up,
                                  color: CustomColorScheme.appGreen),
                            ),

                            IconButton(
                              key: const ValueKey('singleDown'),
                              onPressed: () {
                                final Category category =
                                    _categories.firstWhere((category) =>
                                        _checkedStates[category.id] ?? false);
                                _moveCategoryDown(category);
                              },
                              icon: const Icon(Icons.move_down,
                                  color: CustomColorScheme.appRed),
                            ),

                            // Move to bottommost
                            IconButton(
                              key: const ValueKey('bottom'),
                              onPressed: () {
                                final Category category =
                                    _categories.firstWhere((category) =>
                                        _checkedStates[category.id] ?? false);
                                _moveCategoryToBottomMost(category);
                              },
                              icon: const Icon(
                                  Icons.vertical_align_bottom_rounded,
                                  color: CustomColorScheme.appRed),
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox();
                      }
                    }(),
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
                      key: Key(_containsChecked.toString()),
                      onPressed: _containsChecked
                          ? _handleDeleteConfirmation
                          : _showAddCategoryDialog,
                      icon: _containsChecked
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

              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    border: Border.fromBorderSide(BorderSide(
                        color: CustomColorScheme.backgroundColor, width: 2.0)),
                  ),
                  child: SingleChildScrollView(
                    child: BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        if (state is CategoriesLoading) {
                          return const Loader();
                        } else if (state is CategoriesLoaded) {
                          _categories = state.categories;
                          return _buildCategoryList(state.categories);
                        } else if (state is CategoriesError) {
                          return DashedWidgetWithMessage(
                              message: 'Error: ${state.message}');
                        } else {
                          return const DashedWidgetWithMessage(
                              message: 'Error loading categories');
                        }
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: CustomColorScheme.backgroundColor,
                    width: 2.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: CustomTextStyleScheme.cardViewAll,
                    ),
                    Row(
                      children: [
                        BlocBuilder<SettingsBloc, SettingsState>(
                          builder: (context, state) {
                            if (state is SettingsLoaded) {
                              final settings = state.settings;
                              var currency = settings['currency'] ?? '\$';
                              return Text(
                                currency,
                                style: CustomTextStyleScheme.cardViewAll,
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        BlocBuilder<CategoryBloc, CategoryState>(
                          builder: (context, state) {
                            if (state is CategoriesLoaded) {
                              final double total = state.categories
                                  .map((category) => category.maxBudget)
                                  .fold(0, (a, b) => a + b);
                              return Text(
                                total.toStringAsFixed(2),
                                style: CustomTextStyleScheme.cardViewAll,
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Center(
              //   child: Container(
              //     decoration: const BoxDecoration(
              //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //         color: CustomColorScheme.headerWithText),
              //     padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
              //     child: const Text(
              //       "Savings",
              //       style: TextStyle(color: Colors.white),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 20),
              // const DashedWidgetWithMessage(message: "No savings found"),
              // const SizedBox(height: 20),
              // Center(
              //   child: Container(
              //     decoration: const BoxDecoration(
              //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //         color: CustomColorScheme.headerWithText),
              //     padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
              //     child: const Text(
              //       "Debts",
              //       style: TextStyle(color: Colors.white),
              //     ),
              //   ),
              // ),

              // const DashedWidgetWithMessage(message: "No debts found"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList(List<Category> categories) {
    return categories.isEmpty
        ? const DashedWidgetWithMessage(message: 'No categories found')
        : Column(
            children: categories.map((category) {
              return Column(
                children: [
                  CategoryCheckBox(
                    id: category.id,
                    name: category.name,
                    budget: category.maxBudget,
                    isChecked: _checkedStates[category.id] ?? false,
                    onChanged: (bool? value) {
                      setState(() {
                        _checkedStates[category.id] = value ?? false;
                        _containsChecked = _checkedStates.containsValue(true);
                      });
                    },
                    onLongPressed: () => _showUpdateCategoryDialog(category),
                    onTap: () {
                      setState(() {
                        _checkedStates[category.id] =
                            !(_checkedStates[category.id] ?? false);
                        _containsChecked = _checkedStates.containsValue(true);
                      });
                    },
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

  void _selectAllCategories() {
    setState(() {
      for (final category in _categories) {
        _checkedStates[category.id] = true;
      }
      _containsChecked = true;
    });
  }

  void _unselectAllCategories() {
    setState(() {
      for (final category in _categories) {
        _checkedStates[category.id] = false;
      }
      _containsChecked = false;
    });
  }

  void _swapSelectedCategories() {
    final List<Category> categories = _categories;
    final List<Category> checkedCategories = categories
        .where((category) => _checkedStates[category.id] ?? false)
        .toList();

    final int firstIndex = categories.indexOf(checkedCategories[0]);

    final int secondIndex = categories.indexOf(checkedCategories[1]);

    final Category firstCategory = categories[firstIndex];

    final Category secondCategory = categories[secondIndex];

    final int firstOrder = firstCategory.order;

    final int secondOrder = secondCategory.order;
    final Category updatedFirstCategory =
        firstCategory.copyWith(order: secondOrder);
    final Category updatedSecondCategory =
        secondCategory.copyWith(order: firstOrder);

    BlocProvider.of<CategoryBloc>(context)
        .add(UpdateCategory(updatedFirstCategory));
    BlocProvider.of<CategoryBloc>(context)
        .add(UpdateCategory(updatedSecondCategory));

    setState(() {
      _isMoved = true;
    });
  }

  void _moveCategoryUp(Category category) {
    final List<Category> categories = _categories;
    final int index = categories.indexOf(category);

    if (index > 0) {
      final Category previousCategory = categories[index - 1];
      final int order = category.order;
      final int previousOrder = previousCategory.order;

      final Category updatedCategory = category.copyWith(order: previousOrder);
      final Category updatedPreviousCategory =
          previousCategory.copyWith(order: order);

      BlocProvider.of<CategoryBloc>(context)
          .add(UpdateCategory(updatedCategory));
      BlocProvider.of<CategoryBloc>(context)
          .add(UpdateCategory(updatedPreviousCategory));
    }

    _isMoved = true;
  }

  void _moveCategoryDown(Category category) {
    final List<Category> categories = _categories;
    final int index = categories.indexOf(category);

    if (index < categories.length - 1) {
      final Category nextCategory = categories[index + 1];
      final int order = category.order;
      final int nextOrder = nextCategory.order;

      final Category updatedCategory = category.copyWith(order: nextOrder);
      final Category updatedNextCategory = nextCategory.copyWith(order: order);

      BlocProvider.of<CategoryBloc>(context)
          .add(UpdateCategory(updatedCategory));
      BlocProvider.of<CategoryBloc>(context)
          .add(UpdateCategory(updatedNextCategory));
    }

    _isMoved = true;
  }

  void _moveCategoryToTopMost(Category category) {
    final List<Category> categories = _categories;
    int startIndex = 0;
    int endIndex = categories.indexOf(category);

    for (int i = startIndex; i < endIndex; i++) {
      final Category updatedCategory = categories[i].copyWith(order: i + 1);
      BlocProvider.of<CategoryBloc>(context)
          .add(UpdateCategory(updatedCategory));
    }

    final Category updatedCategory = category.copyWith(order: 0);

    BlocProvider.of<CategoryBloc>(context).add(UpdateCategory(updatedCategory));

    _isMoved = true;
  }

  void _moveCategoryToBottomMost(Category category) {
    final List<Category> categories = _categories;
    int startIndex = categories.indexOf(category);
    int endIndex = categories.length - 1;

    for (int i = startIndex + 1; i <= endIndex; i++) {
      final Category updatedCategory = categories[i].copyWith(order: i - 1);
      BlocProvider.of<CategoryBloc>(context)
          .add(UpdateCategory(updatedCategory));
    }

    final Category updatedCategory =
        category.copyWith(order: categories.length - 1);

    BlocProvider.of<CategoryBloc>(context).add(UpdateCategory(updatedCategory));

    _isMoved = true;
  }

  Future<void> _saveCategory() async {
    final String name = _nameController.text;
    final String budgetString = _budgetController.text;
    final double? budget = double.tryParse(budgetString);

    if (name.isNotEmpty && budget != null) {
      final category = CategoriesCompanion(
        name: Value(name),
        maxBudget: Value(budget),
        balance: Value(budget),
      );

      BlocProvider.of<CategoryBloc>(context).add(AddCategory(category));

      _nameController.clear();
      _budgetController.clear();
    }

    _isMoved = false;
  }

  Future<void> _updateCategory(Category category) async {
    final String name = _nameController.text;
    final String budgetString = _budgetController.text;

    final double? budget = double.tryParse(budgetString);

    if (name.isNotEmpty && budget != null) {
      category = category.copyWith(name: name, maxBudget: budget);

      BlocProvider.of<CategoryBloc>(context).add(UpdateCategory(category));

      _nameController.clear();
      _budgetController.clear();
    }

    _isMoved = false;
  }

  Future<void> _deleteCategories() async {
    List<int> categoryIdsToDelete = _categories
        .where((category) => _checkedStates[category.id] ?? false)
        .map((category) => category.id)
        .toList();

    for (final categoryId in categoryIdsToDelete) {
      BlocProvider.of<CategoryBloc>(context).add(DeleteCategory(categoryId));
    }

    _unselectAllCategories();

    _isMoved = false;
  }

  Future<void> _showAddCategoryDialog() async {
    final result = await _showCategoryDialog(title: 'Add Category');

    if (result == 'save') {
      await _saveCategory();
    }
  }

  Future<void> _showUpdateCategoryDialog(Category category) async {
    final result = await _showCategoryDialog(
        title: 'Update Category',
        name: category.name,
        budget: category.maxBudget.toString());

    if (result == 'save') {
      await _updateCategory(category);
    }
  }

  Future<void> _handleDeleteConfirmation() async {
    if (_containsChecked) {
      await ScreenUtils.showConfirmationDialog(
        context: context,
        title: 'Delete Categories',
        content: 'Are you sure you want to delete the selected categories?',
        onConfirm: () => _deleteCategories(),
      );
    } else {
      _showAddCategoryDialog();
    }
  }

  Future<String?> _showCategoryDialog(
      {String? title, String? name, String? budget}) async {
    _nameController.text = name ?? '';
    _budgetController.text = budget ?? '';

    return await showDialog<String>(
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
              child: Column(
                children: [
                  const SizedBox(height: 15.0),
                  Center(
                    child: Text(
                      title ?? '',
                      style: CustomTextStyleScheme.dialogTitle,
                    ),
                  ),
                  const SizedBox(height: 15.0),
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
                      } else if (value.length > 15) {
                        return 'Must not exceed 15 characters';
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
                      if (value == null || value.isEmpty) {
                        _budgetController.text = '0.0';
                      } else if (double.tryParse(value) == null) {
                        return 'Please enter a numerical budget';
                      } else if (double.parse(value) < 0.0) {
                        return 'Budget must be not be less than 0';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      _validateForm();
                    },
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DialogButton(
                        onPressed: () => Navigator.of(context).pop('cancel'),
                        text: 'Cancel',
                        backgroundColor: CustomColorScheme.dialogButtonCancel,
                        textColor: Colors.black,
                      ),
                      DialogButton(
                        onPressed: _validateForm,
                        text: 'Save',
                        backgroundColor: CustomColorScheme.dialogButtonSave,
                        textColor: CustomColorScheme.appGreen,
                        borderColor: CustomColorScheme.appGreen,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
