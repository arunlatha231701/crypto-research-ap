
import '../entity/coin_chart_entity.dart';
import '../entity/coin_details_entity.dart';

abstract interface class CoinDetailsRepository {
  Future<CoinDetails> getCoinDetails(String coinId);

  Future<CoinChart> getCoinChart({
    required String coinId,
    required String currency,
    required String period,
  });
}
