abstract final class ApiEndpoints {
  // Market
  static const String marketGlobal = 'market/global/';
  static const String marketCoins = 'market/coins/';

  // Coins
  static const String coinMarket = 'coins/market/';
  static const String coinSearch = 'coins/search/';

  static String coinDetails(String coinId) {
    return 'coins/$coinId/';
  }

  static String coinChart(String coinId) {
    return 'coins/$coinId/chart/';
  }

  // Authentication
  static const String register = 'auth/register/';
  static const String login = 'auth/login/';
  static const String changeUsername = 'auth/change-username/';
  static const String changePassword = 'auth/change-password/';

  // Watchlist
  static const String watchlist = 'watchlist/';

  static String removeWatchlistItem(int itemId) {
    return 'watchlist/$itemId/';
  }

  static const String profile = 'auth/profile/';
}
