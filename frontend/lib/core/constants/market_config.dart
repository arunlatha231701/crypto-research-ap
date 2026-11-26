abstract final class MarketConfig {
  static const String defaultCurrency = 'inr';

  static const List<String> supportedCurrencies = ['inr', 'usd', 'eur', 'gbp'];

  static const int defaultPageSize = 20;
  static const int dashboardPageSize = 50;
  static const int initialPage = 1;

  static const int minimumPageSize = 1;
  static const int maximumPageSize = 100;
}
