
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/core/constants/market_config.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/presentation/viewmodels/market_state.dart';
import 'package:frontend/providers/providers.dart';

class MarketViewModel extends AsyncNotifier<MarketState> {
  bool _isRefreshing = false;
  int _requestVersion = 0;

  @override
  Future<MarketState> build() async {
    final currency = ref.watch(marketCurrencyProvider);

    final getMarketCoins =
    ref.watch(getMarketCoinsUseCaseProvider);

    final coins = await getMarketCoins.call(
      currency: currency,
      perPage: MarketConfig.defaultPageSize,
      page: MarketConfig.initialPage,
    );

    return MarketState(
      coins: List.unmodifiable(coins),
      currency: currency,
      currentPage: MarketConfig.initialPage,
      hasMore: coins.length >= MarketConfig.defaultPageSize,
    );
  }

  // Search
  void updateSearch(String query) {
    final current = state.asData?.value;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(searchQuery: query),
    );
  }

  // Sorting
  void updateSort(MarketSortOption option) {
    final current = state.asData?.value;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(sortOption: option),
    );
  }

  // Gainers and losers filter
  void updateFilter(MarketChangeFilter filter) {
    final current = state.asData?.value;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(changeFilter: filter),
    );
  }

  // Pull-to-refresh


  Future<void> refresh() async {
    if (_isRefreshing) return;

    final previousState = state.asData?.value;
    if (previousState == null) return;

    _isRefreshing = true;

    // Invalidate any pagination request already in progress.
    _requestVersion++;

    try {
      final currency = ref.read(marketCurrencyProvider);
      final getMarketCoins = ref.read(getMarketCoinsUseCaseProvider);

      final coins = await getMarketCoins.call(
        currency: currency,
        perPage: MarketConfig.defaultPageSize,
        page: MarketConfig.initialPage,
      );

      final latestState = state.asData?.value;
      if (latestState == null) return;

      state = AsyncData(
        MarketState(
          coins: List.unmodifiable(coins),
          currency: currency,
          currentPage: MarketConfig.initialPage,
          hasMore: coins.length >= MarketConfig.defaultPageSize,
          searchQuery: latestState.searchQuery,
          sortOption: latestState.sortOption,
          changeFilter: latestState.changeFilter,
        ),
      );
    } catch (_) {
      // Keep the existing list if refreshing fails.
      // Also clear any pagination loading state invalidated by refresh.
      final latestState = state.asData?.value;

      if (latestState != null) {
        state = AsyncData(
          latestState.copyWith(
            isLoadingMore: false,
            clearLoadMoreError: true,
          ),
        );
      }
    } finally {
      _isRefreshing = false;
    }
  }



  // Pagination

  Future<void> loadMore() async {
    if (_isRefreshing) return;

    final current = state.asData?.value;

    if (current == null ||
        current.isLoadingMore ||
        !current.hasMore) {
      return;
    }

    // Remember which request generation this pagination belongs to.
    final requestVersion = _requestVersion;

    state = AsyncData(
      current.copyWith(
        isLoadingMore: true,
        clearLoadMoreError: true,
      ),
    );

    try {
      final nextPage = current.currentPage + 1;
      final getMarketCoins = ref.read(getMarketCoinsUseCaseProvider);

      final newCoins = await getMarketCoins.call(
        currency: current.currency,
        perPage: MarketConfig.defaultPageSize,
        page: nextPage,
      );

      // Ignore the response if a refresh has started since this request.
      if (requestVersion != _requestVersion || _isRefreshing) {
        return;
      }

      final latest = state.asData?.value;
      if (latest == null) return;

      // Prevent duplicate coins when pages overlap.
      final existingIds = latest.coins.map((coin) => coin.id).toSet();

      final uniqueNewCoins = newCoins
          .where((coin) => !existingIds.contains(coin.id))
          .toList(growable: false);

      state = AsyncData(
        latest.copyWith(
          coins: List.unmodifiable([
            ...latest.coins,
            ...uniqueNewCoins,
          ]),
          currentPage: nextPage,
          hasMore: newCoins.length >= MarketConfig.defaultPageSize,
          isLoadingMore: false,
          clearLoadMoreError: true,
        ),
      );
    } catch (error) {
      // Ignore errors from outdated pagination requests.
      if (requestVersion != _requestVersion || _isRefreshing) {
        return;
      }

      final latest = state.asData?.value;

      if (latest != null) {
        state = AsyncData(
          latest.copyWith(
            isLoadingMore: false,
            loadMoreError: _getFriendlyErrorMessage(error),
          ),
        );
      }
    }
  }


  // Retry pagination after an error.
  Future<void> retryLoadMore() async {
    await loadMore();
  }
  String _getFriendlyErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }

    return 'Unable to load more coins. Please try again.';
  }
}
