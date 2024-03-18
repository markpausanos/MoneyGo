import 'package:intl/intl.dart';

class Utils {
  static final List<String> months = [
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

  static String getMonth(int month) {
    return months[month - 1];
  }

  static String getFormattedDate(DateTime date) {
    return '${getMonth(date.month)} ${date.day}, ${date.year}';
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
