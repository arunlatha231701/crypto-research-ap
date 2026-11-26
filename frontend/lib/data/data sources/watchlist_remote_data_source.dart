
import 'package:frontend/core/network/api_endpoints.dart';
import 'package:frontend/core/network/api_service.dart';
import 'package:frontend/data/models/watchlist_item_model.dart';

class WatchlistRemoteDataSource {
  WatchlistRemoteDataSource(this._apiService);

  final ApiService _apiService;

  Future<List<WatchlistItemModel>> getWatchlist() async {
    final response = await _apiService.get(
      ApiEndpoints.watchlist,
    );

    final json = _parseResponse(response.data);
    _validateResponse(json);

    final data = json['data'];

    if (data is! List) {
      throw const FormatException(
        'Invalid watchlist data received from server.',
      );
    }

    return data.map((item) {
      if (item is! Map) {
        throw const FormatException(
          'Invalid watchlist item received from server.',
        );
      }

      return WatchlistItemModel.fromJson(
        Map<String, dynamic>.from(item),
      );
    }).toList();
  }

  Future<WatchlistItemModel> addToWatchlist(String coinId) async {
    final response = await _apiService.post(
      ApiEndpoints.watchlist,
      data: {
        'coin_id': coinId.trim().toLowerCase(),
      },
    );

    final json = _parseResponse(response.data);
    _validateResponse(json);

    final data = json['data'];

    if (data is! Map) {
      throw const FormatException(
        'Invalid added watchlist item received from server.',
      );
    }

    return WatchlistItemModel.fromJson(
      Map<String, dynamic>.from(data),
    );
  }

  Future<void> removeFromWatchlist(int itemId) async {
    final response = await _apiService.delete(
      ApiEndpoints.removeWatchlistItem(itemId),
    );

    final json = _parseResponse(response.data);
    _validateResponse(json);
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
            'Unable to complete watchlist request.',
      );
    }
  }
}
