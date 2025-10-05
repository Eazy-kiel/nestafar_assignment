// lib/core/utils/price_formatter.dart
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class PriceFormatter {
  static String format(double price) {
    final formatter = NumberFormat('#,##0', 'en_US');
    return '${AppConstants.currency}${formatter.format(price)}';
  }

  static String formatWithDecimals(double price) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return '${AppConstants.currency}${formatter.format(price)}';
  }
}
