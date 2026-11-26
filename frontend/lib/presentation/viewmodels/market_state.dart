
import 'package:frontend/domain/entity/market_coin_entity.dart';

enum MarketSortOption {
  marketCap,
  priceAscending,
  priceDescending,
  changeAscending,
  changeDescending,
  name,
}

enum MarketChangeFilter {
  all,
  gainers,
  losers,
}

class MarketState {
  const MarketState({
    required this.coins,
    required this.currency,
    this.currentPage = 1,
    this.hasMore = true,
    this.searchQuery = '',
    this.sortOption = MarketSortOption.marketCap,
    this.changeFilter = MarketChangeFilter.all,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  final List<MarketCoin> coins;
  final String currency;
  final int currentPage;
  final bool hasMore;
  final String searchQuery;
  final MarketSortOption sortOption;
  final MarketChangeFilter changeFilter;
  final bool isLoadingMore;
  final String? loadMoreError;

  /// Applies search, filter and sorting locally to the loaded coins.
  List<MarketCoin> get visibleCoins {
    final query = searchQuery.trim().toLowerCase();

    final filteredCoins = coins.where((coin) {
      final matchesSearch = query.isEmpty ||
          coin.name.toLowerCase().contains(query) ||
          coin.symbol.toLowerCase().contains(query) ||
          coin.id.toLowerCase().contains(query);

      final change = coin.priceChangePercentage24h;

      final matchesFilter = switch (changeFilter) {
        MarketChangeFilter.all => true,
        MarketChangeFilter.gainers => change != null && change > 0,
        MarketChangeFilter.losers => change != null && change < 0,
      };

      return matchesSearch && matchesFilter;
    }).toList();

    switch (sortOption) {
      case MarketSortOption.marketCap:
        filteredCoins.sort(
              (a, b) => (a.marketCapRank ?? 999999)
              .compareTo(b.marketCapRank ?? 999999),
        );

      case MarketSortOption.priceAscending:
        filteredCoins.sort(
              (a, b) => (a.currentPrice ?? 0)
              .compareTo(b.currentPrice ?? 0),
        );

      case MarketSortOption.priceDescending:
        filteredCoins.sort(
              (a, b) => (b.currentPrice ?? 0)
              .compareTo(a.currentPrice ?? 0),
        );

      case MarketSortOption.changeAscending:
        filteredCoins.sort(
              (a, b) => (a.priceChangePercentage24h ?? 0)
              .compareTo(b.priceChangePercentage24h ?? 0),
        );

      case MarketSortOption.changeDescending:
        filteredCoins.sort(
              (a, b) => (b.priceChangePercentage24h ?? 0)
              .compareTo(a.priceChangePercentage24h ?? 0),
        );

      case MarketSortOption.name:
        filteredCoins.sort(
              (a, b) => a.name.toLowerCase()
              .compareTo(b.name.toLowerCase()),
        );
    }

    return List.unmodifiable(filteredCoins);
  }

  MarketState copyWith({
    List<MarketCoin>? coins,
    String? currency,
    int? currentPage,
    bool? hasMore,
    String? searchQuery,
    MarketSortOption? sortOption,
    MarketChangeFilter? changeFilter,
    bool? isLoadingMore,
    String? loadMoreError,
    bool clearLoadMoreError = false,
  }) {
    return MarketState(
      coins: coins ?? this.coins,
      currency: currency ?? this.currency,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
      changeFilter: changeFilter ?? this.changeFilter,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError:
      clearLoadMoreError ? null : loadMoreError ?? this.loadMoreError,
    );
  }
}
