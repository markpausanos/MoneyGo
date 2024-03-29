import 'package:drift/drift.dart' hide Column;
import 'package:expression_language/expression_language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/blocs/sources/source_bloc.dart';
import 'package:moneygo/data/blocs/sources/source_event.dart';
import 'package:moneygo/data/blocs/sources/source_state.dart';
import 'package:moneygo/data/blocs/transactions/transaction_bloc.dart';
import 'package:moneygo/data/blocs/transactions/transaction_event.dart';
import 'package:moneygo/data/blocs/transactions/transaction_state.dart';
import 'package:moneygo/data/models/budget/income_model.dart';
import 'package:moneygo/ui/utils/screen_utils.dart';
import 'package:moneygo/ui/widgets/Buttons/dialog_button.dart';
import 'package:moneygo/ui/widgets/DateTimePicker/base_datetime_picker.dart';
import 'package:moneygo/ui/widgets/IconButton/large_icon_button.dart';
import 'package:moneygo/ui/widgets/Textfields/base_textfield.dart';
import 'package:moneygo/ui/widgets/Textfields/textfield_with_dropdown.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class EditIncomeScreen extends StatefulWidget {
  final Transaction transaction;
  final IncomeModel income;
  final String? previousRoute;

  const EditIncomeScreen(
      {super.key,
      required this.transaction,
      required this.income,
      this.previousRoute});

  @override
  State<EditIncomeScreen> createState() => _EditIncomeScreen();
}

class _EditIncomeScreen extends State<EditIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _selectedDateTime = DateTime.now();
  int? _selectedSourceId;

  @override
  void initState() {
    super.initState();

    _titleController.text = widget.transaction.title;
    _amountController.text = widget.transaction.amount.toString();
    _descriptionController.text = widget.transaction.description ?? '';
    _selectedDateTime = widget.transaction.date;
    _selectedSourceId = widget.income.placedOnSource.id;

    BlocProvider.of<SourceBloc>(context).add(LoadSources());
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
          if (state is TransactionsUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Income updated successfully'),
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
                content: Text('Income deleted successfully'),
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
              title: const Text('Edit Income Details',
                  style: CustomTextStyleScheme.appBarTitleCards),
              centerTitle: true,
              actions: [
                IconButtonLarge(
                  icon: Icons.delete,
                  color: Colors.white,
                  onPressed: () => _onDeleteIncome(),
                )
              ],
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
                          onPressed: () => _onSaveIncome(),
                          text: "Save Income",
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

        return BaseDropdownFormField(
          dropDownItemList: sourceMap,
          initialValue: _selectedSourceId,
          onChanged: (int? id) {
            if (id != null) _onSourceChanged(id);
          },
          labelText: "Received on",
          validator: _validateDropDown,
        );
      } else {
        return const CircularProgressIndicator();
      }
    });
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

  void _onSaveIncome() {
    if (_formKey.currentState!.validate()) {
      String title = _titleController.text;
      String amount = _amountController.text;
      String description = _descriptionController.text;
      int sourceId = _selectedSourceId!;
      DateTime selectedDateTime = _selectedDateTime;

      final transaction = widget.transaction.copyWith(
        title: title,
        amount: double.parse(amount),
        date: selectedDateTime,
        description: Value(description),
      );

      final income = widget.income.copyWith(
        placedOnSource: widget.income.placedOnSource.copyWith(id: sourceId),
      );

      BlocProvider.of<TransactionBloc>(context)
          .add(UpdateTransaction(transaction, income));
    }
  }

  void _onDeleteIncome() {
    ScreenUtils.showConfirmationDialog(
        context: context,
        title: "Delete Transaction",
        content: "Are you sure to delete this transaction?",
        onConfirm: () => _deleteIncome());
  }

  Future<void> _deleteIncome() async {
    BlocProvider.of<TransactionBloc>(context)
        .add(DeleteTransaction(widget.transaction));
  }
}
