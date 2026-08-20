import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String formatDate(DateTime? date, {String format = 'dd MMMM yyyy'}) {
    if (date == null) return '-';
    try {
      return DateFormat(format, 'id_ID').format(date);
    } catch (_) {
      return DateFormat(format).format(date);
    }
  }

  static String timeAgo(DateTime? date) {
    if (date == null) return '-';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return formatDate(date, format: 'dd MMM yyyy');
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }
}
