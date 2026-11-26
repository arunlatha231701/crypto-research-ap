
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/domain/entity/portfolio_holding_entity.dart';
import 'package:frontend/domain/repository/portfolio_repository.dart';
import 'package:frontend/presentation/viewmodels/portfolio_state.dart';
import 'package:frontend/providers/providers.dart';

class PortfolioViewModel extends Notifier<PortfolioState> {
  late PortfolioRepository _repository;

  @override
  PortfolioState build() {
    _repository = ref.read(portfolioRepositoryProvider);

    Future.microtask(loadPortfolio);

    return const PortfolioState(isLoading: true);
  }

  Future<void> loadPortfolio() async {
    state = state.copyWith(
      isLoading: state.holdings.isEmpty,
      clearError: true,
    );

    try {
      final holdings = await _repository.getHoldings();

      state = state.copyWith(
        holdings: holdings,
        isLoading: false,
        clearError: true,
      );

      await _loadMarketData();
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _readableError(error),
      );
    }
  }

  Future<void> _loadMarketData() async {
    if (state.holdings.isEmpty) {
      state = state.copyWith(marketCoinsById: const {});
      return;
    }

    try {
      final currency = ref.read(marketCurrencyProvider);
      final ids = state.holdings
          .map((holding) => holding.coinId.toLowerCase())
          .toSet()
          .toList();

      final coins = await ref.read(
        getMarketCoinsByIdsUseCaseProvider,
      )(
        currency: currency,
        ids: ids,
      );

      state = state.copyWith(
        marketCoinsById: {
          for (final coin in coins)
            coin.id.toLowerCase(): coin,
        },
        clearMarketDataError: true,
      );
    } catch (error) {
      state = state.copyWith(
        marketDataError: _readableError(error),
      );
    }
  }

  Future<bool> addHolding({
    required String coinId,
    required double quantity,
    required double purchasePrice,
    required DateTime purchaseDate,
  }) async {
    final normalizedId = coinId.trim().toLowerCase();

    if (normalizedId.isEmpty ||
        !quantity.isFinite ||
        !purchasePrice.isFinite ||
        quantity <= 0 ||
        purchasePrice <= 0) {
      state = state.copyWith(
        errorMessage: 'Enter a valid coin, quantity and purchase price.',
      );
      return false;
    }

    final holding = PortfolioHolding(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      coinId: normalizedId,
      quantity: quantity,
      purchasePrice: purchasePrice,
      purchaseDate: purchaseDate,
    );

    state = state.copyWith(isSaving: true, clearError: true);

    try {
      await _repository.addHolding(holding);

      state = state.copyWith(
        holdings: [...state.holdings, holding],
        isSaving: false,
      );

      await _loadMarketData();
      return true;
    } catch (error) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: _readableError(error),
      );
      return false;
    }
  }

  Future<bool> updateHolding(PortfolioHolding holding) async {
    if (holding.quantity <= 0 ||
        holding.purchasePrice <= 0 ||
        !holding.quantity.isFinite ||
        !holding.purchasePrice.isFinite) {
      state = state.copyWith(
        errorMessage: 'Enter a valid quantity and purchase price.',
      );
      return false;
    }

    state = state.copyWith(isSaving: true, clearError: true);

    try {
      await _repository.updateHolding(holding);

      state = state.copyWith(
        holdings: [
          for (final item in state.holdings)
            if (item.id == holding.id) holding else item,
        ],
        isSaving: false,
      );

      return true;
    } catch (error) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: _readableError(error),
      );
      return false;
    }
  }

  Future<bool> deleteHolding(String id) async {
    state = state.copyWith(isSaving: true, clearError: true);

    try {
      await _repository.deleteHolding(id);

      state = state.copyWith(
        holdings: state.holdings
            .where((holding) => holding.id != id)
            .toList(),
        isSaving: false,
      );

      await _loadMarketData();
      return true;
    } catch (error) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: _readableError(error),
      );
      return false;
    }
  }

  Future<void> refresh() async {
    await loadPortfolio();
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
