
import 'package:frontend/domain/entity/coin_chart_entity.dart';
import 'package:frontend/domain/entity/coin_details_entity.dart';

class CoinDetailsState {
  const CoinDetailsState({
    required this.details,
    required this.currency,
    required this.selectedPeriod,
    this.chart,
    this.isChartLoading = false,
    this.chartError,
  });

  final CoinDetails details;
  final CoinChart? chart;
  final String currency;
  final String selectedPeriod;
  final bool isChartLoading;
  final String? chartError;

  CoinDetailsState copyWith({
    CoinDetails? details,
    CoinChart? chart,
    String? currency,
    String? selectedPeriod,
    bool? isChartLoading,
    String? chartError,
    bool clearChartError = false,
    bool clearChart = false,
  }) {
    return CoinDetailsState(
      details: details ?? this.details,
      chart: clearChart ? null : chart ?? this.chart,
      currency: currency ?? this.currency,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      isChartLoading: isChartLoading ?? this.isChartLoading,
      chartError: clearChartError
          ? null
          : chartError ?? this.chartError,
    );
  }
}
