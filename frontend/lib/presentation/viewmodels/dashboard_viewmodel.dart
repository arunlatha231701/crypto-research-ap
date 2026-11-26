
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/domain/entity/global_market_stats_entity.dart';
import 'package:frontend/domain/entity/market_coin_entity.dart';
import 'package:frontend/domain/usecase/market/get_global_market_stats_usecase.dart';
import 'package:frontend/domain/usecase/market/get_market_coins_usecase.dart';
import 'package:frontend/presentation/viewmodels/dashboard_state.dart';
import 'package:frontend/providers/providers.dart';

import '../../core/constants/market_config.dart';

class DashboardViewModel extends AsyncNotifier<DashboardData> {
  @override
  Future<DashboardData> build() async {
    final currency = ref.watch(marketCurrencyProvider);

    final getGlobalMarketStats =
    ref.watch(getGlobalMarketStatsUseCaseProvider);

    final getMarketCoins =
    ref.watch(getMarketCoinsUseCaseProvider);

    return _fetchDashboardData(
      getGlobalMarketStats: getGlobalMarketStats,
      getMarketCoins: getMarketCoins,
      currency: currency,
    );
  }

  Future<DashboardData> _fetchDashboardData({
    required GetGlobalMarketStatsUseCase getGlobalMarketStats,
    required GetMarketCoinsUseCase getMarketCoins,
    required String currency,
  }) async {
    final results = await Future.wait<Object>([
      getGlobalMarketStats.call(),
      getMarketCoins.call(
        currency: currency,
        perPage: MarketConfig.dashboardPageSize,
        page: MarketConfig.initialPage,
      ),
    ]);

    final globalStats = results[0] as GlobalMarketStats;
    final marketCoins = results[1] as List<MarketCoin>;

    return DashboardData(
      globalStats: globalStats,
      marketCoins: marketCoins,
      currency: currency,
    );
  }

  Future<void> refresh() async {
    // Keep the existing dashboard visible during refresh.
    try {
      final getGlobalMarketStats =
      ref.read(getGlobalMarketStatsUseCaseProvider);

      final getMarketCoins =
      ref.read(getMarketCoinsUseCaseProvider);

      final currency = ref.read(marketCurrencyProvider);

      final refreshedData = await _fetchDashboardData(
        getGlobalMarketStats: getGlobalMarketStats,
        getMarketCoins: getMarketCoins,
        currency: currency,
      );

      state = AsyncData(refreshedData);
    } catch (error, stackTrace) {
      // Retain the previous dashboard data if refresh fails.
      // Initial loading errors are still handled by build().
      if (state.asData == null) {
        state = AsyncError(error, stackTrace);
      }
    }
  }
}
