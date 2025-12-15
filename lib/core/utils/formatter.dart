import 'package:intl/intl.dart';

/// Utility class for formatting numbers and dates
class Formatter {
  /// Format price with 2 decimal places
  static String formatPrice(double price) {
    return price.toStringAsFixed(2);
  }

  /// Format percentage with 2 decimal places and % sign
  static String formatPercent(double percent) {
    final sign = percent >= 0 ? '+' : '';
    return '$sign${percent.toStringAsFixed(2)}%';
  }

  /// Format volume in thousands (張)
  static String formatVolume(int volume) {
    final lots = (volume / 1000).round();
    return NumberFormat('#,###').format(lots);
  }

  /// Format large numbers with thousand separators
  static String formatNumber(num number) {
    return NumberFormat('#,##0').format(number);
  }

  /// Format currency with NT$ prefix
  static String formatCurrency(double amount) {
    return 'NT\$ ${NumberFormat('#,##0.00').format(amount)}';
  }

  /// Format date as yyyy-MM-dd
  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Format datetime as yyyy-MM-dd HH:mm:ss
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  /// Format time as HH:mm
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  /// Format change with + or - sign
  static String formatChange(double change) {
    final sign = change >= 0 ? '+' : '';
    return '$sign${formatPrice(change)}';
  }

  /// Format shares in lots (張)
  static String formatShares(int shares) {
    return '$shares張';
  }

  /// Format risk reward ratio
  static String formatRiskRewardRatio(double ratio) {
    return '1:${ratio.toStringAsFixed(2)}';
  }
}
