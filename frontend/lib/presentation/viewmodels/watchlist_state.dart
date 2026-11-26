
import 'package:frontend/domain/entity/market_coin_entity.dart';
import 'package:frontend/domain/entity/watchlist_item_entity.dart';

class WatchlistState {
  const WatchlistState({
    this.items = const [],
    this.marketCoinsById = const {},
    this.isLoading = false,
    this.isRefreshing = false,
    this.isAdding = false,
    this.removingItemIds = const {},
    this.errorMessage,
    this.marketDataError,
    this.addingCoinIds = const {},
  });

  final List<WatchlistItem> items;

  /// Market information indexed by the coin's ID.
  final Map<String, MarketCoin> marketCoinsById;

  final bool isLoading;
  final bool isRefreshing;
  final bool isAdding;
  final Set<int> removingItemIds;
  final String? errorMessage;
  final String? marketDataError;
  final Set<String> addingCoinIds;

  bool get isEmpty => items.isEmpty;

  bool containsCoin(String coinId) {
    final normalizedId = coinId.trim().toLowerCase();

    return items.any(
          (item) => item.coinId.toLowerCase() == normalizedId,
    );
  }

  MarketCoin? marketCoinFor(String coinId) {
    return marketCoinsById[coinId.trim().toLowerCase()];
  }

  WatchlistState copyWith({
    List<WatchlistItem>? items,
    Map<String, MarketCoin>? marketCoinsById,
    bool? isLoading,
    bool? isRefreshing,
    bool? isAdding,
    Set<int>? removingItemIds,
    Set<String>? addingCoinIds,
    String? errorMessage,
    String? marketDataError,
    bool clearError = false,
    bool clearMarketDataError = false,
  }) {
    return WatchlistState(
      items: items ?? this.items,
      marketCoinsById: marketCoinsById ?? this.marketCoinsById,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isAdding: isAdding ?? this.isAdding,
      removingItemIds: removingItemIds ?? this.removingItemIds,
      addingCoinIds: addingCoinIds ?? this.addingCoinIds,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      marketDataError: clearMarketDataError
          ? null
          : marketDataError ?? this.marketDataError,
    );
  }
}
