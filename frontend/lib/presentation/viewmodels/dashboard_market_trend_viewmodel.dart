import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/domain/usecase/coin/get_coin_chart_usecase.dart';
import 'package:frontend/presentation/viewmodels/dashboard_market_trend_state.dart';
import 'package:frontend/providers/providers.dart';

class DashboardMarketTrendViewModel
    extends AsyncNotifier<DashboardMarketTrendState> {
  static const String defaultCoinId = 'bitcoin';
  static const String defaultPeriod = '1w';

  static const List<String> supportedPeriods = [
    '1d',
    '1w',
    '1m',
    '1y',
  ];

  int _requestId = 0;

  @override
  Future<DashboardMarketTrendState> build() async {
    final currency = ref.watch(marketCurrencyProvider);
    final getChart = ref.watch(getCoinChartUseCaseProvider);

    final previousPeriod =
        state.asData?.value.selectedPeriod ?? defaultPeriod;

    try {
      final chart = await getChart(
        coinId: defaultCoinId,
        currency: currency,
        period: previousPeriod,
      );

      return DashboardMarketTrendState(
        chart: chart,
        currency: currency,
        selectedPeriod: previousPeriod,
      );
    } catch (error) {
      return DashboardMarketTrendState(
        currency: currency,
        selectedPeriod: previousPeriod,
        errorMessage: _readableError(error),
      );
    }
  }

  Future<void> changePeriod(String period) async {
    if (!supportedPeriods.contains(period)) return;

    final currentState = state.asData?.value;
    if (currentState == null) return;

    if (currentState.selectedPeriod == period &&
        currentState.chart != null) {
      return;
    }

    await _loadChart(
      currency: currentState.currency,
      period: period,
    );
  }

  Future<void> refresh() async {
    final currentState = state.asData?.value;
    if (currentState == null) return;

    await _loadChart(
      currency: currentState.currency,
      period: currentState.selectedPeriod,
    );
  }

  Future<void> _loadChart({
    required String currency,
    required String period,
  }) async {
    final currentState = state.asData?.value;
    if (currentState == null) return;

    final requestId = ++_requestId;

    state = AsyncData(
      currentState.copyWith(
        currency: currency,
        selectedPeriod: period,
        isLoading: true,
        clearError: true,
      ),
    );

    try {
      final getChart = ref.read(getCoinChartUseCaseProvider);

      final chart = await getChart(
        coinId: defaultCoinId,
        currency: currency,
        period: period,
      );

      if (requestId != _requestId) return;

      final latestState = state.asData?.value;
      if (latestState == null) return;

      state = AsyncData(
        latestState.copyWith(
          chart: chart,
          currency: currency,
          selectedPeriod: period,
          isLoading: false,
          clearError: true,
        ),
      );
    } catch (error) {
      if (requestId != _requestId) return;

      final latestState = state.asData?.value;
      if (latestState == null) return;

      state = AsyncData(
        latestState.copyWith(
          isLoading: false,
          errorMessage: _readableError(error),
        ),
      );
    }
  }

  String _readableError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}

final dashboardMarketTrendViewModelProvider =
AsyncNotifierProvider<
    DashboardMarketTrendViewModel,
    DashboardMarketTrendState
>(DashboardMarketTrendViewModel.new);