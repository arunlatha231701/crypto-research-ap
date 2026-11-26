import 'package:frontend/domain/entity/coin_chart_entity.dart';

class DashboardMarketTrendState {
  const DashboardMarketTrendState({
    required this.currency,
    required this.selectedPeriod,
    this.chart,
    this.isLoading = false,
    this.errorMessage,
  });

  final CoinChart? chart;
  final String currency;
  final String selectedPeriod;
  final bool isLoading;
  final String? errorMessage;

  DashboardMarketTrendState copyWith({
    CoinChart? chart,
    String? currency,
    String? selectedPeriod,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DashboardMarketTrendState(
      chart: chart ?? this.chart,
      currency: currency ?? this.currency,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}