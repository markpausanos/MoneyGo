import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/blocs/budget/categories/category_bloc.dart';
import 'package:moneygo/data/blocs/budget/categories/category_event.dart';
import 'package:moneygo/data/blocs/budget/periods/period_bloc.dart';
import 'package:moneygo/data/blocs/budget/periods/period_event.dart';
import 'package:moneygo/data/blocs/budget/periods/period_state.dart';
import 'package:moneygo/ui/widgets/Cards/base_card.dart';
import 'package:moneygo/ui/widgets/Loaders/loading_state.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';
import 'package:moneygo/utils/utils.dart';

class BudgetPeriodCard extends StatefulWidget {
  const BudgetPeriodCard({super.key});

  @override
  State<BudgetPeriodCard> createState() => _BudgetPeriodCardState();
}

class _BudgetPeriodCardState extends State<BudgetPeriodCard> {
  final TextEditingController _dateController = TextEditingController();
  Period? _currentPeriod;
  DateTime? _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PeriodBloc>(context).add(LoadPeriods());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PeriodBloc, PeriodState>(builder: (context, state) {
      if (state is PeriodsLoaded) {
        _currentPeriod = state.period;
        BlocProvider.of<CategoryBloc>(context).add(LoadCategories());
        if (_currentPeriod != null) {
          return InkWell(
            borderRadius: BorderRadius.circular(12),
            splashColor: CustomColorScheme.backgroundColor,
            child: BaseCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Budget Period',
                            textAlign: TextAlign.left,
                            style: CustomTextStyleScheme.cardTitle,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: 15,
                            height: 15,
                            child: Tooltip(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(10),
                              triggerMode: TooltipTriggerMode.tap,
                              message: _getTooltipMessage(),
                              showDuration: const Duration(seconds: 5),
                              textAlign: TextAlign.center,
                              child: const Icon(
                                Icons.info_outline,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Tooltip(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(10),
                            message: _getCurrentDateTooltipMessage(),
                            textAlign: TextAlign.center,
                            triggerMode: TooltipTriggerMode.tap,
                            showDuration: const Duration(seconds: 5),
                            child: Text(
                              _currentPeriod!.endDate != null
                                  ? Utils.getRemainingDays(
                                      DateTime.now(), _currentPeriod!.endDate!)
                                  : 'TBA days remaining',
                              textAlign: TextAlign.right,
                              style: CustomTextStyleScheme.cardTitle.copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              _showDialog(
                                  title: 'Edit Budget Period',
                                  endTime: _currentPeriod!.endDate);
                            },
                            child: const Icon(
                              Icons.edit_calendar_outlined,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        return const Center(child: Loader());
      } else {
        return const Center(child: Loader());
      }
    });
  }

  String _getTooltipMessage() {
    return 'This is the current budget period. The budget period is the time frame in which all transactions are recorded and budgeted for. The budget categories are reset at the end of each period.';
  }

  String _getCurrentDateTooltipMessage() {
    return 'Start Date: ${Utils.getFormattedDateShort(_currentPeriod!.startDate)} 00:00:00\nEnd Date: ${_currentPeriod!.endDate != null ? '${Utils.getFormattedDateShort(_currentPeriod!.endDate!)} 23:59:59' : 'TBA'}\n\nClick the edit icon to change the end date of the period.';
  }

  void _savePeriod() {
    if (_selectedDate != null) {
      var newEndDate = DateTime(_selectedDate!.year, _selectedDate!.month,
          _selectedDate!.day, 23, 59, 59);

      _currentPeriod = _currentPeriod!.copyWith(endDate: Value(newEndDate));

      BlocProvider.of<PeriodBloc>(context).add(UpdatePeriod(_currentPeriod!));
    }
  }

  Future<DateTime?> _showDatePickerDialog(
      BuildContext context, DateTime? initialDate) async {
    DateTime now = DateTime.now();
    DateTime firstDate = DateTime(now.year, now.month, now.day);
    DateTime lastDate = DateTime(now.year + 5);

    return showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: firstDate, // Set to current date
      lastDate: lastDate,
      currentDate: DateTime(now.year, now.month, now.day),
    );
  }

  Future<void> _showDialog({String? title, DateTime? endTime}) async {
    final dialogFormKey = GlobalKey<FormState>();
    if (endTime != null) {
      _dateController.text = Utils.getFormattedDateMMM(endTime);
    }

    final result = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          titlePadding: const EdgeInsets.all(0.0),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          buttonPadding: const EdgeInsets.all(0.0),
          title: Container(
            decoration: const BoxDecoration(
              color: CustomColorScheme.appGreen,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 15.0),
                Center(
                    child: Text(title ?? 'Budget Period Dialog',
                        style: CustomTextStyleScheme.dialogTitle)),
                const SizedBox(height: 15.0),
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: dialogFormKey,
              child: Column(
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.disabled,
                    controller: _dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'End Date',
                    ),
                    onTap: () async {
                      DateTime? selectedDate =
                          await _showDatePickerDialog(context, endTime);

                      // Get the start of the current day.
                      DateTime now = DateTime.now();
                      DateTime today = DateTime(now.year, now.month, now.day);

                      // Compare the selected date to the start of today.
                      if (selectedDate != null &&
                          selectedDate.isAfter(
                              today.subtract(const Duration(days: 1)))) {
                        setState(() {
                          _selectedDate = selectedDate;
                          _dateController.text =
                              Utils.getFormattedDateMMM(_selectedDate!);
                        });
                      }
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please select a date'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        onPressed: () => Navigator.of(context).pop('cancel'),
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.black)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColorScheme.dialogButtonSave,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            side: const BorderSide(
                                color: CustomColorScheme.appGreen, width: 0.5)),
                        onPressed: () {
                          if (dialogFormKey.currentState?.validate() ?? false) {
                            _savePeriod();
                            Navigator.of(context).pop('save');
                          }
                        },
                        child: const Text('Save',
                            style:
                                TextStyle(color: CustomColorScheme.appGreen)),
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

    if (result == 'save') {
      if (mounted) {
        BlocProvider.of<PeriodBloc>(context).add(LoadPeriods());
      }
    }
  }
}
