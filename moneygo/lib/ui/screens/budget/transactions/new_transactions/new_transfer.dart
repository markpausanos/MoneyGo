import 'package:drift/drift.dart' hide Column;
import 'package:expression_language/expression_language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/blocs/budget/sources/source_bloc.dart';
import 'package:moneygo/data/blocs/budget/sources/source_event.dart';
import 'package:moneygo/data/blocs/budget/sources/source_state.dart';
import 'package:moneygo/data/blocs/budget/transactions/transaction_bloc.dart';
import 'package:moneygo/data/blocs/budget/transactions/transaction_event.dart';
import 'package:moneygo/data/blocs/budget/transactions/transaction_state.dart';
import 'package:moneygo/ui/widgets/Buttons/dialog_button.dart';
import 'package:moneygo/ui/widgets/DateTimePicker/base_datetime_picker.dart';
import 'package:moneygo/ui/widgets/IconButton/large_icon_button.dart';
import 'package:moneygo/ui/widgets/Textfields/base_textfield.dart';
import 'package:moneygo/ui/widgets/Textfields/textfield_with_dropdown.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';
import 'package:moneygo/utils/enums.dart';

class NewTransferScreen extends StatefulWidget {
  const NewTransferScreen({super.key});

  @override
  State<NewTransferScreen> createState() => _NewTransferScreenState();
}

class _NewTransferScreenState extends State<NewTransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _selectedDateTime = DateTime.now();
  int? _selectedFromSourceId;
  int? _selectedToSourceId;
  bool _stayOnPage = false;

  @override
  void initState() {
    super.initState();

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
          if (state is TransactionsSaveSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Transfer saved successfully'),
                duration: Duration(seconds: 2),
                backgroundColor: CustomColorScheme.appGreen,
              ),
            );

            if (!_stayOnPage) {
              Navigator.popAndPushNamed(context, "/home");
            }
          }
          if (state is TransactionsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 2),
                backgroundColor: CustomColorScheme.appRed,
              ),
            );
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
              title: const Text('New Transfer',
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
                    ),
                    const SizedBox(height: 25),
                    _buildSourceFromDropdown(),
                    const SizedBox(height: 25),
                    _buildSourceToDropdown(),
                    const SizedBox(height: 25),
                    BaseTextField(
                      controller: _descriptionController,
                      labelText: "Description (Optional)",
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

        _selectedFromSourceId ??=
            sourceMap.isNotEmpty ? sourceMap.keys.first : null;
        return BaseDropdownFormField(
          dropDownItemList: sourceMap,
          initialValue: _selectedFromSourceId,
          onChanged: (int? id) {
            if (id != null) _onSourceFromChanged(id);
          },
          labelText: "Source From",
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

        _selectedToSourceId ??=
            sourceMap.isNotEmpty ? sourceMap.keys.elementAt(1) : null;

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
    });
  }

  void _onSourceToChanged(int id) {
    setState(() {
      _selectedToSourceId = id;
    });
  }

  void _onSaveTransfer() {
    if (_formKey.currentState!.validate()) {
      String title = _titleController.text.trim();
      String amount = _amountController.text.trim();
      String description = _descriptionController.text.trim();
      int sourceFromId = _selectedFromSourceId ?? 0;
      int sourceToId = _selectedToSourceId ?? 0;
      DateTime selectedDate = _selectedDateTime;

      final transaction = TransactionsCompanion(
          title: Value(title),
          amount: Value(double.parse(amount)),
          description: Value(description),
          date: Value(selectedDate),
          type: const Value(TransactionTypes.transfer));

      final transfer = TransfersCompanion(
        fromSourceId: Value(sourceFromId),
        toSourceId: Value(sourceToId),
      );

      BlocProvider.of<TransactionBloc>(context)
          .add(AddTransaction(transaction, transfer));

      _titleController.clear();
      _amountController.clear();
      _descriptionController.clear();
    }
  }
}
