
import 'package:frontend/domain/entity/global_market_stats_entity.dart';
import 'package:frontend/domain/entity/market_coin_entity.dart';

abstract interface class MarketRepository {
  Future<GlobalMarketStats> getGlobalMarketStats();

  // Existing paginated market data.
  Future<List<MarketCoin>> getMarketCoins({
    required String currency,
    required int perPage,
    required int page,
  });

  // Fetch market data for specific cryptocurrency IDs.
  Future<List<MarketCoin>> getMarketCoinsByIds({
    required String currency,
    required List<String> ids,
  });
}
