
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/domain/entity/coin_chart_entity.dart';
import 'package:frontend/domain/usecase/coin/get_coin_chart_usecase.dart';
import 'package:frontend/domain/usecase/coin/get_coin_details_usecase.dart';

import 'package:frontend/presentation/viewmodels/coin_details_state.dart';
import 'package:frontend/providers/providers.dart';

import 'package:frontend/core/constants/market_config.dart';

class CoinDetailsViewModel extends AsyncNotifier<CoinDetailsState> {
  CoinDetailsViewModel(this.coinId);

  final String coinId;

  static const String defaultPeriod = '1w';

  static const List<String> supportedPeriods = [
    '1d',
    '1w',
    '1m',
    '1y',
  ];

  late GetCoinDetailsUseCase _getCoinDetailsUseCase;
  late GetCoinChartUseCase _getCoinChartUseCase;

  int _chartRequestId = 0;

  @override
  Future<CoinDetailsState> build() async {
    _getCoinDetailsUseCase =
        ref.read(getCoinDetailsUseCaseProvider);

    _getCoinChartUseCase =
        ref.read(getCoinChartUseCaseProvider);

    final currency = ref.read(marketCurrencyProvider);

    final details = await _getCoinDetailsUseCase(coinId);

    CoinChart? initialChart;
    String? chartError;

    try {
      initialChart = await _getCoinChartUseCase(
        coinId: coinId,
        currency: currency,
        period: defaultPeriod,
      );
    } catch (error) {
      chartError = _readableError(error);
    }

    return CoinDetailsState(
      details: details,
      chart: initialChart,
      currency: currency,
      selectedPeriod: defaultPeriod,
      chartError: chartError,
    );
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

  Future<void> changeCurrency(String currency) async {
    final currentState = state.asData?.value;
    if (currentState == null) return;

    final normalizedCurrency = currency.toLowerCase();

    if (!MarketConfig.supportedCurrencies
        .contains(normalizedCurrency)) {
      return;
    }

    if (currentState.currency == normalizedCurrency) return;

    ref
        .read(marketCurrencyProvider.notifier)
        .changeCurrency(normalizedCurrency);

    await _loadChart(
      currency: normalizedCurrency,
      period: currentState.selectedPeriod,
    );
  }

  Future<void> refresh() async {
    final currentState = state.asData?.value;
    if (currentState == null) return;

    final requestId = ++_chartRequestId;

    state = AsyncData(
      currentState.copyWith(
        isChartLoading: true,
        clearChartError: true,
      ),
    );

    try {
      final details = await _getCoinDetailsUseCase(coinId);

      if (requestId != _chartRequestId) return;

      final latestState = state.asData?.value;
      if (latestState == null) return;

      state = AsyncData(
        latestState.copyWith(details: details),
      );

      await _loadChart(
        currency: latestState.currency,
        period: latestState.selectedPeriod,
      );
    } catch (error, stackTrace) {
      if (requestId != _chartRequestId) return;
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> retryChart() async {
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

    final requestId = ++_chartRequestId;

    state = AsyncData(
      currentState.copyWith(
        currency: currency,
        selectedPeriod: period,
        isChartLoading: true,
        clearChartError: true,
      ),
    );

    try {
      final chart = await _getCoinChartUseCase(
        coinId: coinId,
        currency: currency,
        period: period,
      );

      if (requestId != _chartRequestId) return;

      final latestState = state.asData?.value;
      if (latestState == null) return;

      state = AsyncData(
        latestState.copyWith(
          chart: chart,
          currency: currency,
          selectedPeriod: period,
          isChartLoading: false,
          clearChartError: true,
        ),
      );
    } catch (error) {
      if (requestId != _chartRequestId) return;

      final latestState = state.asData?.value;
      if (latestState == null) return;

      state = AsyncData(
        latestState.copyWith(
          isChartLoading: false,
          chartError: _readableError(error),
        ),
      );
    }
  }

  String _readableError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}
