
import 'package:frontend/domain/repository/market_repository.dart';

import '../../entity/market_coin_entity.dart';

class GetMarketCoinsUseCase {
  const GetMarketCoinsUseCase(this._repository);

  final MarketRepository _repository;

  Future<List<MarketCoin>> call({
    required String currency,
    required int perPage,
    required int page,
  }) {
    return _repository.getMarketCoins(
      currency: currency,
      perPage: perPage,
      page: page,
    );
  }
}
