
import '../../entity/coin_chart_entity.dart';
import '../../repository/coin_details_repository.dart';

class GetCoinChartUseCase {
  const GetCoinChartUseCase(this._repository);

  final CoinDetailsRepository _repository;

  Future<CoinChart> call({
    required String coinId,
    required String currency,
    required String period,
  }) {
    return _repository.getCoinChart(
      coinId: coinId,
      currency: currency,
      period: period,
    );
  }
}
