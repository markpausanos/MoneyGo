import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';

class BaseDateTimePicker extends StatefulWidget {
  final Function(DateTime) onDateTimeChanged;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final String? Function(String?)? validator;

  const BaseDateTimePicker({
    super.key,
    required this.onDateTimeChanged,
    this.initialDate,
    this.firstDate,
    this.validator,
  });

  @override
  State<BaseDateTimePicker> createState() => _BaseDateTimePickerState();
}

class _BaseDateTimePickerState extends State<BaseDateTimePicker> {
  final _dateController = TextEditingController();
  late DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.initialDate ?? DateTime.now();
    _dateController.text = DateFormat("MMMM dd, yyyy 'at' hh:mm a")
        .format(widget.initialDate ?? selectedDateTime);
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: widget.firstDate ?? DateTime(2020, 01),
      lastDate: DateTime.now(),
    );
    if (pickedDate == null) return;

    if (!mounted) return;

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

    widget.onDateTimeChanged(updatedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _dateController,
      validator: widget.validator,
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
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
        errorStyle: const TextStyle(
          backgroundColor: Colors.white,
          color: Colors.red,
        ),
        labelText: "Date and Time",
      ),
      onTap: () => _pickDateTime(context),
      readOnly: true,
    );
  }
}
