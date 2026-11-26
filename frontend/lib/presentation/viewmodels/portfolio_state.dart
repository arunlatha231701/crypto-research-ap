
import 'package:frontend/domain/entity/market_coin_entity.dart';
import 'package:frontend/domain/entity/portfolio_holding_entity.dart';

class PortfolioState {
  const PortfolioState({
    this.holdings = const [],
    this.marketCoinsById = const {},
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.marketDataError,
  });

  final List<PortfolioHolding> holdings;
  final Map<String, MarketCoin> marketCoinsById;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final String? marketDataError;

  double get totalInvested {
    return holdings.fold(
      0,
          (total, holding) => total + holding.investedAmount,
    );
  }

  double get currentValue {
    return holdings.fold(0, (total, holding) {
      final price = marketCoinsById[holding.coinId]?.currentPrice;
      return total + (price == null ? holding.investedAmount : holding.quantity * price);
    });
  }

  double get totalProfitLoss => currentValue - totalInvested;

  double get totalProfitLossPercentage {
    if (totalInvested <= 0) return 0;
    return (totalProfitLoss / totalInvested) * 100;
  }

  PortfolioState copyWith({
    List<PortfolioHolding>? holdings,
    Map<String, MarketCoin>? marketCoinsById,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    String? marketDataError,
    bool clearError = false,
    bool clearMarketDataError = false,
  }) {
    return PortfolioState(
      holdings: holdings ?? this.holdings,
      marketCoinsById: marketCoinsById ?? this.marketCoinsById,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      marketDataError: clearMarketDataError
          ? null
          : marketDataError ?? this.marketDataError,
    );
  }
}
