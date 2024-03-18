import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/blocs/categories/category_bloc.dart';
import 'package:moneygo/data/blocs/categories/category_event.dart';
import 'package:moneygo/data/blocs/categories/category_state.dart';
import 'package:moneygo/data/blocs/sources/source_bloc.dart';
import 'package:moneygo/data/blocs/sources/source_event.dart';
import 'package:moneygo/data/blocs/sources/source_state.dart';
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
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

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
        child: Column(
          children: [
            BaseTextField(controller: _nameController, labelText: "Name"),
            const SizedBox(height: 25),
            const BaseDateTimePicker(),
            const SizedBox(height: 25),
            _buildSourceDropdown(),
            const SizedBox(height: 25),
            _buildCategoryDropdown(),
            const SizedBox(height: 25),
            BaseTextField(controller: _amountController, labelText: "Amount"),
            const SizedBox(height: 25),
            BaseTextField(
              controller: _descriptionController,
              labelText: "Description",
              height: 250,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceDropdown() {
    return BlocBuilder<SourceBloc, SourceState>(builder: (context, state) {
      if (state is SourcesLoaded) {
        return BaseDropdownFormField(
            dropDownItemList:
                state.sources.map((source) => source.name).toList(),
            initialValue: "",
            labelText: "Source");
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildCategoryDropdown() {
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
      if (state is CategoriesLoaded) {
        return BaseDropdownFormField(
            dropDownItemList:
                state.categories.map((category) => category.name).toList(),
            initialValue: "",
            labelText: "Category");
      } else {
        return const CircularProgressIndicator();
      }
    });
  }
}
