
import 'package:frontend/data/data%20sources/market_remote_data_source.dart';
import 'package:frontend/domain/entity/global_market_stats_entity.dart';
import 'package:frontend/domain/entity/market_coin_entity.dart';
import 'package:frontend/domain/repository/market_repository.dart';

import '../models/global_market_stats_model.dart';
import '../models/market_coin_model.dart';

class MarketRepositoryImpl implements MarketRepository {
  MarketRepositoryImpl(this._remoteDataSource);

  final MarketRemoteDataSource _remoteDataSource;

  @override
  Future<GlobalMarketStats> getGlobalMarketStats() async {
    final model = await _remoteDataSource.getGlobalMarketStats();

    return _mapGlobalStats(model);
  }

  @override
  Future<List<MarketCoin>> getMarketCoins({
    required String currency,
    required int perPage,
    required int page,
  }) async {
    final models = await _remoteDataSource.getMarketCoins(
      currency: currency,
      perPage: perPage,
      page: page,
    );

    return models.map(_mapMarketCoin).toList(growable: false);
  }

  @override
  Future<List<MarketCoin>> getMarketCoinsByIds({
    required String currency,
    required List<String> ids,
  }) async {
    if (ids.isEmpty) {
      return const [];
    }

    final models = await _remoteDataSource.getMarketCoinsByIds(
      currency: currency,
      ids: ids,
    );

    return models.map(_mapMarketCoin).toList(growable: false);
  }

  GlobalMarketStats _mapGlobalStats(GlobalMarketStatsModel model) {
    return GlobalMarketStats(
      activeCryptocurrencies: model.activeCryptocurrencies,
      markets: model.markets,
      totalMarketCap: model.totalMarketCap,
      totalVolume: model.totalVolume,
      marketCapPercentage: model.marketCapPercentage,
      marketCapChangePercentage24h:
      model.marketCapChangePercentage24h,
      updatedAt: model.updatedAt,
    );
  }

  MarketCoin _mapMarketCoin(MarketCoinModel model) {
    return MarketCoin(
      id: model.id,
      symbol: model.symbol,
      name: model.name,
      image: model.image,
      currentPrice: model.currentPrice,
      marketCap: model.marketCap,
      marketCapRank: model.marketCapRank,
      totalVolume: model.totalVolume,
      high24h: model.high24h,
      low24h: model.low24h,
      priceChangePercentage24h:
      model.priceChangePercentage24h,
      circulatingSupply: model.circulatingSupply,
    );
  }
}
