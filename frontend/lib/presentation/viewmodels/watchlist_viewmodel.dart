
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/domain/entity/market_coin_entity.dart';
import 'package:frontend/domain/usecase/market/get_market_coins_by_ids_usecase.dart';
import 'package:frontend/domain/usecase/watchlist/add_to_watchlist_usecase.dart';
import 'package:frontend/domain/usecase/watchlist/get_watchlist_usecase.dart';
import 'package:frontend/domain/usecase/watchlist/remove_from_watchlist_usecase.dart';
import 'package:frontend/presentation/viewmodels/watchlist_state.dart';
import 'package:frontend/providers/providers.dart';

class WatchlistViewModel extends Notifier<WatchlistState> {
  late GetWatchlistUseCase _getWatchlist;
  late AddToWatchlistUseCase _addToWatchlist;
  late RemoveFromWatchlistUseCase _removeFromWatchlist;
  late GetMarketCoinsByIdsUseCase _getMarketCoinsByIds;

  @override
  WatchlistState build() {
    _getWatchlist = ref.read(getWatchlistUseCaseProvider);
    _addToWatchlist = ref.read(addToWatchlistUseCaseProvider);
    _removeFromWatchlist = ref.read(removeFromWatchlistUseCaseProvider);
    _getMarketCoinsByIds =
        ref.read(getMarketCoinsByIdsUseCaseProvider);

    Future.microtask(loadWatchlist);

    return const WatchlistState(isLoading: true);
  }

  Future<void> loadWatchlist() async {
    state = state.copyWith(
      isLoading: state.items.isEmpty,
      isRefreshing: state.items.isNotEmpty,
      clearError: true,
      clearMarketDataError: true,
    );

    try {
      final items = await _getWatchlist();

      state = state.copyWith(
        items: items,
        isLoading: false,
        isRefreshing: false,
        clearError: true,
      );

      await _loadMarketData(
        items.map((item) => item.coinId).toList(),
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorMessage: _readableError(error),
      );
    }
  }

  Future<void> _loadMarketData(List<String> coinIds) async {
    final normalizedIds = coinIds
        .map((id) => id.trim().toLowerCase())
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    if (normalizedIds.isEmpty) {
      state = state.copyWith(
        marketCoinsById: const {},
        clearMarketDataError: true,
      );
      return;
    }

    try {
      final currency = ref.read(marketCurrencyProvider);

      final coins = await _getMarketCoinsByIds(
        currency: currency,
        ids: normalizedIds,
      );

      final marketCoinsById = <String, MarketCoin>{
        for (final coin in coins)
          coin.id.toLowerCase(): coin,
      };

      state = state.copyWith(
        marketCoinsById: marketCoinsById,
        clearMarketDataError: true,
      );
    } catch (error) {
      // Keep saved coins visible even if market data cannot be fetched.
      state = state.copyWith(
        marketDataError: _readableError(error),
      );
    }
  }

  Future<bool> addCoin(String coinId) async {
    final normalizedId = coinId.trim().toLowerCase();

    if (normalizedId.isEmpty || state.containsCoin(normalizedId)) {
      return false;
    }

    if (state.addingCoinIds.contains(normalizedId)) {
      return false;
    }

    state = state.copyWith(
      addingCoinIds: {
        ...state.addingCoinIds,
        normalizedId,
      },
      isAdding: true,
      clearError: true,
    );

    try {
      final item = await _addToWatchlist(normalizedId);

      final remainingIds = {...state.addingCoinIds}
        ..remove(normalizedId);

      state = state.copyWith(
        items: [...state.items, item],
        addingCoinIds: remainingIds,
        isAdding: remainingIds.isNotEmpty,
        clearError: true,
      );

      await _loadMarketData(
        state.items.map((savedItem) => savedItem.coinId).toList(),
      );

      return true;
    } catch (error) {
      final remainingIds = {...state.addingCoinIds}
        ..remove(normalizedId);

      state = state.copyWith(
        addingCoinIds: remainingIds,
        isAdding: remainingIds.isNotEmpty,
        errorMessage: _readableError(error),
      );

      return false;
    }
  }

  Future<bool> removeCoin(int itemId) async {
    if (state.removingItemIds.contains(itemId)) return false;

    state = state.copyWith(
      removingItemIds: {...state.removingItemIds, itemId},
      clearError: true,
    );

    try {
      await _removeFromWatchlist(itemId);

      final updatedItems = state.items
          .where((item) => item.id != itemId)
          .toList();

      final remainingCoinIds = updatedItems
          .map((item) => item.coinId.toLowerCase())
          .toSet();

      final updatedMarketCoins = Map<String, MarketCoin>.from(
        state.marketCoinsById,
      )..removeWhere(
            (coinId, _) => !remainingCoinIds.contains(coinId),
      );

      state = state.copyWith(
        items: updatedItems,
        marketCoinsById: updatedMarketCoins,
        removingItemIds: {
          ...state.removingItemIds,
        }..remove(itemId),
        clearError: true,
      );

      return true;
    } catch (error) {
      state = state.copyWith(
        removingItemIds: {
          ...state.removingItemIds,
        }..remove(itemId),
        errorMessage: _readableError(error),
      );

      return false;
    }
  }

  String _readableError(Object error) {
    if (error is ApiException) return error.message;
    if (error is FormatException) return error.message;

    return error.toString().replaceFirst('Exception: ', '');
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
