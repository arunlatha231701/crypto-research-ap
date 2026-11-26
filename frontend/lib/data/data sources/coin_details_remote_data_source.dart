
import 'package:frontend/core/network/api_endpoints.dart';
import 'package:frontend/core/network/api_service.dart';
import 'package:frontend/data/models/coin_chart_model.dart';
import 'package:frontend/data/models/coin_details_model.dart';

class CoinDetailsRemoteDataSource {
  CoinDetailsRemoteDataSource(this._apiService);

  final ApiService _apiService;

  Future<CoinDetailsModel> getCoinDetails(String coinId) async {
    final response = await _apiService.get(
      ApiEndpoints.coinDetails(coinId),
    );

    final json = _parseResponse(response.data);
    _validateResponse(json);

    final data = json['data'];

    if (data is! Map) {
      throw const FormatException(
        'Invalid coin details data received from server.',
      );
    }

    return CoinDetailsModel.fromJson(
      Map<String, dynamic>.from(data),
    );
  }

  Future<CoinChartModel> getCoinChart({
    required String coinId,
    required String currency,
    required String period,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.coinChart(coinId),
      queryParameters: {
        'currency': currency.toLowerCase(),
        'period': period,
      },
    );

    final json = _parseResponse(response.data);
    _validateResponse(json);

    final data = json['data'];

    if (data is! Map) {
      throw const FormatException(
        'Invalid coin chart data received from server.',
      );
    }

    return CoinChartModel.fromJson(
      Map<String, dynamic>.from(data),
    );
  }

  Map<String, dynamic> _parseResponse(dynamic responseData) {
    if (responseData is! Map) {
      throw const FormatException(
        'Invalid API response format.',
      );
    }

    return Map<String, dynamic>.from(responseData);
  }

  void _validateResponse(Map<String, dynamic> response) {
    if (response['success'] != true) {
      throw Exception(
        response['message']?.toString() ??
            'Unable to fetch coin information.',
      );
    }
  }
}
