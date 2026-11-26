import 'package:frontend/data/models/global_market_stats_model.dart';
import 'package:frontend/data/models/market_coin_model.dart';

import '../../../core/constants/market_config.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/api_service.dart';

class MarketRemoteDataSource {
  MarketRemoteDataSource(this._apiService);

  final ApiService _apiService;

  Future<GlobalMarketStatsModel> getGlobalMarketStats() async {
    final response = await _apiService.get(ApiEndpoints.marketGlobal);

    final responseData = response.data as Map<String, dynamic>;

    _validateResponse(responseData);

    final data = responseData['data'] as Map<String, dynamic>;

    return GlobalMarketStatsModel.fromJson(data);
  }

  Future<List<MarketCoinModel>> getMarketCoins({
    required String currency,
    required int perPage,
    required int page,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.marketCoins,
      queryParameters: {
        'currency': currency,
        'per_page': perPage,
        'page': page,
      },
    );

    final responseData = response.data as Map<String, dynamic>;

    _validateResponse(responseData);

    final data = responseData['data'] as List<dynamic>;

    return data
        .map((coin) => MarketCoinModel.fromJson(coin as Map<String, dynamic>))
        .toList(growable: false);
  }


  Future<List<MarketCoinModel>> getMarketCoinsByIds({
    required String currency,
    required List<String> ids,
  }) async {
    if (ids.isEmpty) {
      return const [];
    }

    final response = await _apiService.get(
      ApiEndpoints.marketCoins,
      queryParameters: {
        'currency': currency,
        'ids': ids.join(','),
      },
    );

    final responseData = response.data as Map<String, dynamic>;

    _validateResponse(responseData);

    final data = responseData['data'] as List<dynamic>;

    return data
        .map(
          (coin) => MarketCoinModel.fromJson(
        coin as Map<String, dynamic>,
      ),
    )
        .toList(growable: false);
  }


  void _validateResponse(Map<String, dynamic> response) {
    if (response['success'] == true) return;

    throw ApiException(
      message:
          response['message']?.toString() ?? 'Unable to retrieve market data.',
      type: ApiErrorType.badResponse,
      errors: response['errors'],
    );
  }
}
