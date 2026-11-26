
import 'package:frontend/data/data sources/coin_details_remote_data_source.dart';
import 'package:frontend/domain/entity/coin_chart_entity.dart';
import 'package:frontend/domain/entity/coin_details_entity.dart';
import 'package:frontend/domain/repository/coin_details_repository.dart';

class CoinDetailsRepositoryImpl implements CoinDetailsRepository {
  CoinDetailsRepositoryImpl(this._remoteDataSource);

  final CoinDetailsRemoteDataSource _remoteDataSource;

  @override
  Future<CoinDetails> getCoinDetails(String coinId) async {
    final model = await _remoteDataSource.getCoinDetails(coinId);
    return model.toEntity();
  }

  @override
  Future<CoinChart> getCoinChart({
    required String coinId,
    required String currency,
    required String period,
  }) async {
    final model = await _remoteDataSource.getCoinChart(
      coinId: coinId,
      currency: currency,
      period: period,
    );

    return model.toEntity();
  }
}
