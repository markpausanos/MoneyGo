import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:moneygo/ui/widgets/Buttons/dialog_button.dart';
import 'package:moneygo/ui/widgets/DateTimePicker/base_datetime_picker.dart';
import 'package:moneygo/ui/widgets/IconButton/large_icon_button.dart';
import 'package:moneygo/ui/widgets/Textfields/base_textfield.dart';
import 'package:moneygo/ui/widgets/Textfields/textfield_with_dropdown.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';
import 'package:moneygo/utils/transaction_types.dart';

class NewExpenseScreen extends StatefulWidget {
  const NewExpenseScreen({super.key});

  @override
  State<NewExpenseScreen> createState() => _NewExpenseScreenState();
}

class _NewExpenseScreenState extends State<NewExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _selectedDateTime = DateTime.now();
  int? _selectedSourceId;
  int? _selectedCategoryId;
  bool _stayOnPage = false;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<SourceBloc>(context).add(LoadSources());
    BlocProvider.of<CategoryBloc>(context).add(LoadCategories());
    BlocProvider.of<TransactionBloc>(context).add(LoadTransactions());
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
          if (state is TransactionsSaveSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Expense saved successfully'),
                duration: Duration(seconds: 2),
                backgroundColor: CustomColorScheme.appGreen,
              ),
            );

            if (!_stayOnPage) {
              Navigator.popAndPushNamed(context, "/home");
            }
          }
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: CustomColorScheme.appBarCards,
              leading: IconButtonLarge(
                  onPressed: () => Navigator.popAndPushNamed(context, "/home"),
                  icon: Icons.arrow_back,
                  color: Colors.white),
              title: const Text('Expense Details',
                  style: CustomTextStyleScheme.appBarTitleCards),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(35, 30, 35, 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    BaseDateTimePicker(onDateTimeChanged: _onDateTimeChanged),
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
                      labelText: "Description",
                      maxLines: 10,
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Switch(
                              value: _stayOnPage,
                              onChanged: (value) {
                                setState(() {
                                  _stayOnPage = value;
                                });
                              },
                              activeColor: CustomColorScheme.appGreen,
                              inactiveTrackColor:
                                  CustomColorScheme.backgroundColor,
                              trackOutlineColor: MaterialStateProperty.all(
                                  CustomColorScheme.appGray),
                              trackOutlineWidth:
                                  const MaterialStatePropertyAll(0.5),
                            ),
                            const SizedBox(width: 3),
                            const Text(
                              "Stay on page",
                            ),
                          ],
                        ),
                        DialogButton(
                          onPressed: _onSaveExpense,
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
        Map<int, String> categoryMap = {
          for (var category in state.categories) category.id: category.name
        };

        categoryMap[0] = "None";
        return BaseDropdownFormField(
          dropDownItemList: categoryMap,
          initialValue: null,
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

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name cannot be empty";
    }
    return null;
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return "Amount cannot be empty";
    }
    // Check if the value is a valid double
    final doubleValue = double.tryParse(value);
    if (doubleValue == null) {
      return "Please enter a valid number";
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
      // If the form is valid, process the data
      String title = _titleController.text;
      String amount = _amountController.text;
      String description = _descriptionController.text;
      int sourceId = _selectedSourceId!;
      int categoryId = _selectedCategoryId ?? 0;
      DateTime selectedDate = _selectedDateTime;

      final transaction = TransactionsCompanion(
          title: Value(title),
          amount: Value(double.parse(amount)),
          description: Value(description),
          date: Value(selectedDate),
          type: const Value(TransactionTypes.expense));

      // Create a new expense object
      final expense = ExpensesCompanion(
          sourceId: Value(sourceId),
          categoryId: categoryId == 0 ? const Value(null) : Value(categoryId));

      BlocProvider.of<TransactionBloc>(context)
          .add(AddExpenseTransaction(transaction, expense));

      // Clear the form fields
      _titleController.clear();
      _amountController.clear();
      _descriptionController.clear();
    }
  }
}
