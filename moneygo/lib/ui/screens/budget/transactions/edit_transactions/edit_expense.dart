import 'package:drift/drift.dart' hide Column;
import 'package:expression_language/expression_language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/blocs/categories/category_bloc.dart';
import 'package:moneygo/data/blocs/categories/category_event.dart';
import 'package:moneygo/data/blocs/categories/category_state.dart';
import 'package:moneygo/data/blocs/periods/period_bloc.dart';
import 'package:moneygo/data/blocs/periods/period_state.dart';
import 'package:moneygo/data/blocs/sources/source_bloc.dart';
import 'package:moneygo/data/blocs/sources/source_event.dart';
import 'package:moneygo/data/blocs/sources/source_state.dart';
import 'package:moneygo/data/blocs/transactions/transaction_bloc.dart';
import 'package:moneygo/data/blocs/transactions/transaction_event.dart';
import 'package:moneygo/data/blocs/transactions/transaction_state.dart';
import 'package:moneygo/data/models/budget/expense_model.dart';
import 'package:moneygo/ui/utils/screen_utils.dart';
import 'package:moneygo/ui/widgets/Buttons/dialog_button.dart';
import 'package:moneygo/ui/widgets/DateTimePicker/base_datetime_picker.dart';
import 'package:moneygo/ui/widgets/IconButton/large_icon_button.dart';
import 'package:moneygo/ui/widgets/Textfields/base_textfield.dart';
import 'package:moneygo/ui/widgets/Textfields/textfield_with_dropdown.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class EditExpenseScreen extends StatefulWidget {
  final Transaction transaction;
  final ExpenseModel expense;
  final String? previousRoute;

  const EditExpenseScreen(
      {super.key,
      required this.transaction,
      required this.expense,
      this.previousRoute});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _selectedDateTime = DateTime.now();
  int? _selectedSourceId;
  int? _selectedCategoryId;

  Period? _currentPeriod;
  Map<int, Category?> _categoryMap = {};

  @override
  void initState() {
    super.initState();

    _titleController.text = widget.transaction.title;
    _amountController.text = widget.transaction.amount.toString();
    _descriptionController.text = widget.transaction.description ?? '';
    _selectedDateTime = widget.transaction.date;
    _selectedSourceId = widget.expense.source.id;
    _selectedCategoryId = widget.expense.category?.id;

    BlocProvider.of<SourceBloc>(context).add(LoadSources());
    BlocProvider.of<CategoryBloc>(context).add(LoadCategories());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionsUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Expense updated successfully'),
                duration: Duration(seconds: 2),
                backgroundColor: CustomColorScheme.appGreen,
              ),
            );
            if (widget.previousRoute != null) {
              Navigator.popAndPushNamed(context, widget.previousRoute!);
            } else {
              Navigator.pop(context);
            }
          }
          if (state is TransactionsDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Expense deleted successfully'),
                duration: Duration(seconds: 2),
                backgroundColor: CustomColorScheme.appRed,
              ),
            );

            if (widget.previousRoute != null) {
              Navigator.popAndPushNamed(context, widget.previousRoute!);
            } else {
              Navigator.pop(context);
            }
          }
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: CustomColorScheme.appBarCards,
              leading: IconButtonLarge(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icons.arrow_back,
                  color: Colors.white),
              title: const Text('Edit Expense Details',
                  style: CustomTextStyleScheme.appBarTitleCards),
              centerTitle: true,
              actions: [
                IconButtonLarge(
                  icon: Icons.delete,
                  color: Colors.white,
                  onPressed: () => _onDeleteExpense(),
                )
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(35, 30, 35, 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    BlocBuilder<PeriodBloc, PeriodState>(
                        builder: (context, state) {
                      if (state is PeriodsLoaded) {
                        _currentPeriod = state.period;
                      }
                      return BaseDateTimePicker(
                        onDateTimeChanged: _onDateTimeChanged,
                        validator: _validateDate,
                      );
                    }),
                    const SizedBox(height: 25),
                    BaseTextField(
                      controller: _titleController,
                      labelText: "Name",
                      validator: _validateName,
                    ),
                    const SizedBox(height: 25),
                    BaseTextField(
                      controller: _amountController,
                      labelText: "Amount",
                      validator: _validateAmount,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 25),
                    _buildSourceDropdown(),
                    const SizedBox(height: 25),
                    _buildCategoryDropdown(),
                    const SizedBox(height: 25),
                    BaseTextField(
                      controller: _descriptionController,
                      labelText: "Description (Optional)",
                      maxLines: 10,
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DialogButton(
                          onPressed: () => _onSaveExpense(),
                          text: "Save Expense",
                          backgroundColor: CustomColorScheme.appGreenLight,
                          textColor: CustomColorScheme.appGreen,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )));
  }

  Widget _buildSourceDropdown() {
    return BlocBuilder<SourceBloc, SourceState>(builder: (context, state) {
      if (state is SourcesLoaded) {
        Map<int, String> sourceMap = {
          for (var source in state.sources) source.id: source.name
        };

        _selectedSourceId ??=
            sourceMap.isNotEmpty ? sourceMap.keys.first : null;
        return BaseDropdownFormField(
          dropDownItemList: sourceMap,
          initialValue: _selectedSourceId,
          onChanged: (int? id) {
            if (id != null) _onSourceChanged(id);
          },
          labelText: "Source",
          validator: _validateDropDown,
        );
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildCategoryDropdown() {
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
      if (state is CategoriesLoaded) {
        _categoryMap = {
          for (var category in state.categories) category.id: category
        };

        _categoryMap[0] = null;
        return BaseDropdownFormField(
          dropDownItemList: _categoryMap.map((key, value) {
            return MapEntry(key, value?.name ?? "None");
          }),
          initialValue: _selectedCategoryId,
          onChanged: (int? id) {
            _onCategoryChanged(id);
          },
          labelText: "Category",
        );
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  String? _validateDate(String? dateTime) {
    Category? selectedCategory = _categoryMap[_selectedCategoryId];

    if (selectedCategory != null && dateTime != null) {
      if (_currentPeriod != null) {
        DateFormat format = DateFormat("MMMM dd, yyyy 'at' hh:mm a");
        DateTime dateTimeParsed = format.parse(dateTime);

        if (dateTimeParsed.isBefore(_currentPeriod!.startDate) ||
            (_currentPeriod!.endDate != null &&
                dateTimeParsed.isAfter(_currentPeriod!.endDate!))) {
          return "Date must be current for the selected category";
        }
      }
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null) {
      return "Name cannot be null";
    } else if (value.length > 25) {
      return "Name must be less than 25 characters";
    } else if (value.isEmpty) {
      _titleController.text = "Unnamed";
    }
    return null;
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return "Amount cannot be empty";
    }

    try {
      final parser = ExpressionParser(const {});
      final expression = parser.parse(value);
      final result = expression.evaluate();
      if (result is! Decimal && result is! Number) {
        return "Please enter a valid number or expression";
      }
      _amountController.text = result.toString();
    } catch (e) {
      return "Invalid expression";
    }

    return null; // Return null if the input is valid
  }

  String? _validateDropDown(int? value) {
    if (value == null || value == 0) {
      return "Please choose or add an item here first";
    }
    return null;
  }

  void _onDateTimeChanged(DateTime dateTime) {
    setState(() {
      _selectedDateTime = dateTime;
    });
  }

  void _onSourceChanged(int id) {
    setState(() {
      _selectedSourceId = id;
    });
  }

  void _onCategoryChanged(int? id) {
    setState(() {
      _selectedCategoryId = id;
      if (id == 0 || id == null) {
        _selectedCategoryId = null;
      }
    });
  }

  void _onSaveExpense() {
    if (_formKey.currentState!.validate()) {
      String title = _titleController.text;
      String amount = _amountController.text;
      String description = _descriptionController.text;
      int sourceId = _selectedSourceId!;
      int categoryId = _selectedCategoryId ?? 0;
      DateTime selectedDate = _selectedDateTime;

      final transaction = widget.transaction.copyWith(
        title: title,
        amount: double.parse(amount),
        date: selectedDate,
        description: Value(description),
      );

      widget.expense.category ??= Category(
          id: categoryId,
          name: "",
          maxBudget: 0,
          balance: 0,
          dateCreated: DateTime.now(),
          periodId: 0);

      final expense = widget.expense.copyWith(
        source: widget.expense.source.copyWith(id: sourceId),
        category: categoryId == 0
            ? null
            : widget.expense.category?.copyWith(id: categoryId),
      );

      BlocProvider.of<TransactionBloc>(context)
          .add(UpdateTransaction(transaction, expense));
    }
  }

  void _onDeleteExpense() {
    ScreenUtils.showConfirmationDialog(
        context: context,
        title: "Delete Transaction",
        content: "Are you sure to delete this transaction?",
        onConfirm: () => _deleteExpense());
  }

  Future<void> _deleteExpense() async {
    BlocProvider.of<TransactionBloc>(context)
        .add(DeleteTransaction(widget.transaction));
  }
}
