
import 'package:frontend/domain/entity/market_coin_entity.dart';
import 'package:frontend/domain/repository/market_repository.dart';

class GetMarketCoinsByIdsUseCase {
  const GetMarketCoinsByIdsUseCase(this._repository);

  final MarketRepository _repository;

  Future<List<MarketCoin>> call({
    required String currency,
    required List<String> ids,
  }) {
    return _repository.getMarketCoinsByIds(
      currency: currency,
      ids: ids,
    );
  }
}
