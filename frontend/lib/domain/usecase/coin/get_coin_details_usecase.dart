
import '../../entity/coin_details_entity.dart';
import '../../repository/coin_details_repository.dart';

class GetCoinDetailsUseCase {
  const GetCoinDetailsUseCase(this._repository);

  final CoinDetailsRepository _repository;

  Future<CoinDetails> call(String coinId) {
    return _repository.getCoinDetails(coinId);
  }
}
