import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/blocs/categories/category_bloc.dart';
import 'package:moneygo/data/blocs/categories/category_event.dart';
import 'package:moneygo/data/blocs/categories/category_state.dart';
import 'package:moneygo/data/blocs/sources/source_bloc.dart';
import 'package:moneygo/data/blocs/sources/source_event.dart';
import 'package:moneygo/data/blocs/sources/source_state.dart';
import 'package:moneygo/ui/widgets/Buttons/dialog_button.dart';
import 'package:moneygo/ui/widgets/DateTimePicker/base_datetime_picker.dart';
import 'package:moneygo/ui/widgets/IconButton/large_icon_button.dart';
import 'package:moneygo/ui/widgets/Textfields/base_textfield.dart';
import 'package:moneygo/ui/widgets/Textfields/textfield_with_dropdown.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class NewTransactionScreen extends StatefulWidget {
  const NewTransactionScreen({super.key});

  @override
  State<NewTransactionScreen> createState() => _NewTransactionScreenState();
}

class _NewTransactionScreenState extends State<NewTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _selectedDateTime = DateTime.now();
  int? _selectedSourceId = null;
  int? _selectedCategoryId = null;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<SourceBloc>(context).add(LoadSources());
    BlocProvider.of<CategoryBloc>(context).add(LoadCategories());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomColorScheme.appBarCards,
        leading: IconButtonLarge(
            onPressed: () => Navigator.pop(context),
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
              BaseTextField(
                controller: _nameController,
                labelText: "Name",
                validator: _validateName,
              ),
              const SizedBox(height: 25),
              BaseDateTimePicker(onDateTimeChanged: _onDateTimeChanged),
              const SizedBox(height: 25),
              _buildSourceDropdown(),
              const SizedBox(height: 25),
              _buildCategoryDropdown(),
              const SizedBox(height: 25),
              BaseTextField(
                controller: _amountController,
                labelText: "Amount",
                validator: _validateAmount, // Validation for amount
              ),
              const SizedBox(height: 25),
              BaseTextField(
                controller: _descriptionController,
                labelText: "Description",
                maxLines: 10,
              ),
              const SizedBox(height: 25),
              DialogButton(
                onPressed: _onSaveExpense,
                text: "Save Expense",
                backgroundColor: CustomColorScheme.appGreenLight,
                textColor: CustomColorScheme.appGreen,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceDropdown() {
    return BlocBuilder<SourceBloc, SourceState>(builder: (context, state) {
      if (state is SourcesLoaded) {
        Map<int, String> sourceMap = {
          for (var source in state.sources) source.id: source.name
        };

        _selectedSourceId ??= sourceMap.keys.first;

        return BaseDropdownFormField(
            dropDownItemList: sourceMap,
            initialValue: sourceMap.keys.first,
            onChanged: _onSourceChanged,
            labelText: "Source");
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

        _selectedCategoryId ??= categoryMap.keys.first;

        return BaseDropdownFormField(
            dropDownItemList: categoryMap,
            initialValue: categoryMap.keys.first,
            onChanged: _onCategoryChanged,
            labelText: "Category");
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

  void _onCategoryChanged(int id) {
    setState(() {
      _selectedCategoryId = id;
    });
  }

  void _onSaveExpense() {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, process the data
      String name = _nameController.text;
      String amount = _amountController.text;
      String description = _descriptionController.text;
      int sourceId = _selectedSourceId!;
      int categoryId = _selectedCategoryId!;
      DateTime selectedDate = _selectedDateTime;

      // Handle the form submission logic here
      // For example, sending data to a server, saving in a database, etc.
      print(
          "Name: $name, Amount: $amount, Description: $description, SourceId: $sourceId, CategoryId: $categoryId, Date: $selectedDate");
    }
  }
}
