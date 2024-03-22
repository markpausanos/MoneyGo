import 'package:collection/collection.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/blocs/periods/period_bloc.dart';
import 'package:moneygo/data/blocs/periods/period_event.dart';
import 'package:moneygo/data/blocs/periods/period_state.dart';
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
        _currentPeriod = state.periods.firstWhereOrNull(
          (period) =>
              period.startDate.isBefore(DateTime.now()) &&
              (period.endDate == null ||
                  period.endDate!.isAfter(DateTime.now()) ||
                  period.endDate!.isAtSameMomentAs(DateTime.now())),
        );

        DateTime newStartDate;
        if (_currentPeriod == null) {
          var previousPeriod = state.periods.firstOrNull;

          if (previousPeriod != null && previousPeriod.endDate != null) {
            newStartDate = previousPeriod.endDate!.add(const Duration(days: 1));
          } else {
            newStartDate = DateTime.now();
            newStartDate = DateTime(
                newStartDate.year, newStartDate.month, newStartDate.day);
          }
          var newPeriod = PeriodsCompanion(
              startDate: Value(newStartDate), endDate: const Value(null));

          BlocProvider.of<PeriodBloc>(context).add(AddPeriod(newPeriod));
        }

        if (_currentPeriod != null) {
          return InkWell(
            borderRadius: BorderRadius.circular(12),
            splashColor: CustomColorScheme.backgroundColor,
            onLongPress: () => _showDialog(
                title: "Edit Period", endTime: _currentPeriod!.endDate),
            child: BaseCard(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Budget Period',
                      textAlign: TextAlign.left,
                      style: CustomTextStyleScheme.cardTitle,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          _currentPeriod!.endDate != null
                              ? '${Utils.getFormattedDateShort(_currentPeriod!.startDate)} - ${Utils.getFormattedDateShort(_currentPeriod!.endDate!)}'
                              : '${Utils.getFormattedDateShort(_currentPeriod!.startDate)} - TBA',
                          textAlign: TextAlign.right,
                          style: CustomTextStyleScheme.cardTitle,
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: IconButton(
                            iconSize: 20,
                            padding: const EdgeInsets.only(right: 5),
                            onPressed: () => _showDialog(
                                title: "Edit Period",
                                endTime: _currentPeriod!.endDate),
                            icon: const Icon(
                              Icons.edit_calendar_outlined,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            )),
          );
        }
        return const Center(child: Loader());
      } else {
        return const Center(child: Loader());
      }
    });
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
