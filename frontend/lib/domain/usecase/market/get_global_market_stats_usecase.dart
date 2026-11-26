

import 'package:frontend/domain/entity/global_market_stats_entity.dart';
import 'package:frontend/domain/repository/market_repository.dart';

class GetGlobalMarketStatsUseCase {
  const GetGlobalMarketStatsUseCase(this._repository);

  final MarketRepository _repository;

  Future<GlobalMarketStats> call() {
    return _repository.getGlobalMarketStats();
  }
}
