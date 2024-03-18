import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';

class BaseDateTimePicker extends StatefulWidget {
  const BaseDateTimePicker({super.key});

  @override
  State<BaseDateTimePicker> createState() => _BaseDateTimePickerState();
}

class _BaseDateTimePickerState extends State<BaseDateTimePicker> {
  final _dateController = TextEditingController();
  late DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = DateTime.now();
    _dateController.text =
        DateFormat("MMMM dd, yyyy 'at' hh:mm a").format(selectedDateTime);
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );
    if (pickedTime == null) return;

    if (!mounted) return;

    final DateTime updatedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      selectedDateTime = updatedDateTime;
      _dateController.text =
          DateFormat("MMMM dd, yyyy 'at' hh:mm a").format(updatedDateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _dateController,
      decoration: InputDecoration(
        filled: true,
        fillColor: CustomColorScheme.backgroundColor,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: CustomColorScheme.appBlue, width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: "Date and Time",
      ),
      onTap: () => _pickDateTime(context),
      readOnly: true,
    );
  }
}
