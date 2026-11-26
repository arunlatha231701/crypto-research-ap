import 'package:intl/intl.dart';

abstract final class DashboardFormatters {
  static String compactCurrency(double value, String currency) {
    return NumberFormat.compactCurrency(
      locale: _localeFor(currency),
      name: currency.toUpperCase(),
      decimalDigits: 2,
    ).format(value);
  }

  static String price(double? value, String currency) {
    if (value == null) return '—';

    return NumberFormat.currency(
      locale: _localeFor(currency),
      name: currency.toUpperCase(),
      decimalDigits: value < 1 ? 4 : 2,
    ).format(value);
  }

  static String percentage(double? value) {
    if (value == null) return '—';

    final prefix = value > 0 ? '+' : '';

    return '$prefix${value.toStringAsFixed(2)}%';
  }

  static String compactNumber(num value) {
    return NumberFormat.compact().format(value);
  }

  static String _localeFor(String currency) {
    return switch (currency.toLowerCase()) {
      'inr' => 'en_IN',
      'usd' => 'en_US',
      'eur' => 'en_IE',
      'gbp' => 'en_GB',
      _ => 'en_US',
    };
  }
}
