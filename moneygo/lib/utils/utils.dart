import 'package:intl/intl.dart';

class Utils {
  static final List<String> monthsMMM = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  static final List<String> monthsFull = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  static String getMonthMMM(int month) {
    return monthsMMM[month - 1];
  }

  static String getMonthFull(int month) {
    return monthsFull[month - 1];
  }

  static String getFormattedDateMMM(DateTime date) {
    return '${getMonthMMM(date.month)} ${date.day}, ${date.year}';
  }

  static String getFormattedDateFull(DateTime date) {
    return '${getMonthFull(date.month)} ${date.day}, ${date.year}';
  }

  static String getFormattedDateShort(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year % 100}';
  }

  static String getFormattedDateAndTimeWithAMPM(DateTime date) {
    return '${getFormattedDateMMM(date)} ${date.hour % 12}:${date.minute.toString().padLeft(2, '0')} ${date.hour < 12 ? 'AM' : 'PM'}';
  }

  static String getRemainingDays(DateTime startDate, DateTime endDate) {
    final difference = endDate.difference(startDate).inDays;

    if (difference == 1) {
      return '1 day remaining';
    } else if (difference > 1) {
      return '$difference days remaining';
    } else {
      return 'Ends today';
    }
  }

  static String formatNumber(double number) {
    final formatter = NumberFormat('#,##0.00');
    if (number >= 1000000000) {
      return '${formatter.format(number / 1000000000)}B';
    } else if (number >= 1000000) {
      return '${formatter.format(number / 1000000)}M';
    }

    return formatter.format(number);
  }
}
