import 'package:intl/intl.dart';

class DateHelper {
  static String toApiFormat(DateTime date) {
    final local = date.toLocal();
    final offset = local.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final hours = offset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    final dateText = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(local);
    return '$dateText$sign$hours:$minutes';
  }

  static String nowForApi() {
    return toApiFormat(DateTime.now());
  }

  static bool isToday(DateTime? date) {
    if (date == null) {
      return false;
    }
    final now = DateTime.now();
    final local = date.toLocal();
    return local.year == now.year &&
        local.month == now.month &&
        local.day == now.day;
  }

  static String display(DateTime? date) {
    if (date == null) {
      return '-';
    }
    return DateFormat('dd MMM yyyy, hh:mm a').format(date.toLocal());
  }
}
