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
import 'package:moneygo/data/models/transfer_model.dart';
import 'package:moneygo/ui/utils/screen_utils.dart';
import 'package:moneygo/ui/widgets/Buttons/dialog_button.dart';
import 'package:moneygo/ui/widgets/DateTimePicker/base_datetime_picker.dart';
import 'package:moneygo/ui/widgets/IconButton/large_icon_button.dart';
import 'package:moneygo/ui/widgets/Textfields/base_textfield.dart';
import 'package:moneygo/ui/widgets/Textfields/textfield_with_dropdown.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class EditTransferScreen extends StatefulWidget {
  final Transaction transaction;
  final TransferModel transfer;
  final String? previousRoute;

  const EditTransferScreen(
      {super.key,
      required this.transaction,
      required this.transfer,
      this.previousRoute});

  @override
  State<EditTransferScreen> createState() => _EditTransferScreenState();
}

class _EditTransferScreenState extends State<EditTransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _selectedDateTime = DateTime.now();
  int? _selectedFromSourceId;
  int? _selectedToSourceId;

  @override
  void initState() {
    super.initState();

    _titleController.text = widget.transaction.title;
    _amountController.text = widget.transaction.amount.toString();
    _descriptionController.text = widget.transaction.description ?? '';
    _selectedDateTime = widget.transaction.date;
    _selectedFromSourceId = widget.transfer.fromSource.id;
    _selectedToSourceId = widget.transfer.toSource.id;

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
                content: Text('Transfer updated successfully'),
                duration: Duration(seconds: 2),
                backgroundColor: CustomColorScheme.appGreen,
              ),
            );

            Navigator.popAndPushNamed(context, widget.previousRoute ?? '/home');
          }
          if (state is TransactionsDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Transfer deleted successfully'),
                duration: Duration(seconds: 2),
                backgroundColor: CustomColorScheme.appRed,
              ),
            );

            Navigator.popAndPushNamed(context, widget.previousRoute ?? '/home');
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
              title: const Text('Edit Transfer Details',
                  style: CustomTextStyleScheme.appBarTitleCards),
              centerTitle: true,
              actions: [
                IconButtonLarge(
                  icon: Icons.delete,
                  color: Colors.white,
                  onPressed: () => _onDeleteTransfer(),
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
                    _buildSourceFromDropdown(),
                    const SizedBox(height: 25),
                    _buildSourceToDropdown(),
                    const SizedBox(height: 25),
                    BaseTextField(
                      controller: _descriptionController,
                      labelText: "Description",
                      maxLines: 10,
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DialogButton(
                          onPressed: _onSaveTransfer,
                          text: "Save Transfer",
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

  Widget _buildSourceFromDropdown() {
    return BlocBuilder<SourceBloc, SourceState>(builder: (context, state) {
      if (state is SourcesLoaded) {
        Map<int, String> sourceMap = {
          for (var source in state.sources) source.id: source.name
        };

        return BaseDropdownFormField(
          isReadOnly: true,
          dropDownItemList: sourceMap,
          initialValue: _selectedFromSourceId,
          onChanged: (int? id) {
            if (id != null) _onSourceFromChanged(id);
          },
          labelText: "Source From (Not Editable)",
          validator: _validateDropDownSourceFrom,
        );
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildSourceToDropdown() {
    return BlocBuilder<SourceBloc, SourceState>(builder: (context, state) {
      if (state is SourcesLoaded) {
        Map<int, String> sourceMap = {
          for (var source in state.sources) source.id: source.name
        };

        return BaseDropdownFormField(
          dropDownItemList: sourceMap,
          initialValue: _selectedToSourceId,
          onChanged: (int? id) {
            if (id != null) _onSourceToChanged(id);
          },
          labelText: "Source To",
          validator: _validateDropDownSourceTo,
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

  String? _validateDropDownSourceFrom(int? value) {
    if (value == null || value == 0) {
      return "Please choose or add an item here first";
    }
    if (_selectedToSourceId != null && value == _selectedToSourceId) {
      return "Source From and Source To cannot be the same";
    }
    return null;
  }

  String? _validateDropDownSourceTo(int? value) {
    if (value == null || value == 0) {
      return "Please choose or add an item here first";
    }
    if (_selectedFromSourceId != null && value == _selectedFromSourceId) {
      return "Source From and Source To cannot be the same";
    }
    return null;
  }

  void _onDateTimeChanged(DateTime dateTime) {
    setState(() {
      _selectedDateTime = dateTime;
    });
  }

  void _onSourceFromChanged(int id) {
    setState(() {
      _selectedFromSourceId = id;
      if (_selectedFromSourceId == _selectedToSourceId) {
        _selectedToSourceId = null;
      }
    });
  }

  void _onSourceToChanged(int id) {
    setState(() {
      _selectedToSourceId = id;
    });
  }

  void _onSaveTransfer() {
    if (_formKey.currentState!.validate()) {
      String title = _titleController.text;
      String amount = _amountController.text;
      String description = _descriptionController.text;
      int fromSourceId = _selectedFromSourceId!;
      int toSourceId = _selectedToSourceId!;
      DateTime selectedDateTime = _selectedDateTime;

      final transaction = widget.transaction.copyWith(
        title: title,
        amount: double.parse(amount),
        date: selectedDateTime,
        description: Value(description),
      );

      final transfer = widget.transfer.copyWith(
        fromSource: widget.transfer.fromSource.copyWith(id: fromSourceId),
        toSource: widget.transfer.toSource.copyWith(id: toSourceId),
      );

      BlocProvider.of<TransactionBloc>(context)
          .add(UpdateTransaction(transaction, transfer));
    }
  }

  void _onDeleteTransfer() {
    ScreenUtils.showConfirmationDialog(
        context: context,
        title: "Delete Transaction",
        content: "Are you sure to delete this transaction?",
        onConfirm: () => _deleteTransfer());
  }

  Future<void> _deleteTransfer() async {
    BlocProvider.of<TransactionBloc>(context)
        .add(DeleteTransaction(widget.transaction));
  }
}
