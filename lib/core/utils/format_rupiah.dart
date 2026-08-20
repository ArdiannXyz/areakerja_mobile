import 'package:intl/intl.dart';

class FormatRupiah {
  FormatRupiah._();

  static String format(num? amount, {bool withSymbol = true}) {
    if (amount == null) return withSymbol ? 'Rp 0' : '0';
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: withSymbol ? 'Rp ' : '',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String formatCompact(num? amount) {
    if (amount == null) return '0';
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)} M';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)} jt';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)} rb';
    }
    return amount.toString();
  }
}
