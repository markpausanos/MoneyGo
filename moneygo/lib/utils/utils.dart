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
}
