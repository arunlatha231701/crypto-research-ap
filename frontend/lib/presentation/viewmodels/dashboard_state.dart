import 'package:frontend/domain/entity/global_market_stats_entity.dart';
import 'package:frontend/domain/entity/market_coin_entity.dart';

class DashboardData {
  const DashboardData({
    required this.globalStats,
    required this.marketCoins,
    required this.currency,
  });

  final GlobalMarketStats globalStats;
  final List<MarketCoin> marketCoins;
  final String currency;

  List<MarketCoin> get topGainers {
    return _getMarketMovers(descending: true);
  }

  List<MarketCoin> get topLosers {
    return _getMarketMovers(descending: false);
  }

  List<MarketCoin> _getMarketMovers({required bool descending}) {
    final coins = marketCoins
        .where((coin) => coin.priceChangePercentage24h != null)
        .toList();

    coins.sort((a, b) {
      final aChange = a.priceChangePercentage24h!;
      final bChange = b.priceChangePercentage24h!;

      return descending
          ? bChange.compareTo(aChange)
          : aChange.compareTo(bChange);
    });

    return coins.take(3).toList(growable: false);
  }

  List<MarketCoin> get marketOverview {
    return marketCoins.take(5).toList(growable: false);
  }
}
