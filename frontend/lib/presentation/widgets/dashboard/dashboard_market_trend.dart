
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/app/theme/app_spacing.dart';
import 'package:frontend/domain/entity/coin_chart_entity.dart';
import 'package:frontend/presentation/viewmodels/dashboard_market_trend_state.dart';
import 'package:frontend/presentation/viewmodels/dashboard_market_trend_viewmodel.dart';

class DashboardMarketTrend extends ConsumerWidget {
  const DashboardMarketTrend({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendAsync = ref.watch(dashboardMarketTrendViewModelProvider);

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: trendAsync.when(
          loading: () => const SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) => _ChartError(
            message: error.toString().replaceFirst('Exception: ', ''),
            onRetry: () => ref.invalidate(
              dashboardMarketTrendViewModelProvider,
            ),
          ),
          data: (state) => _DashboardMarketTrendContent(
            state: state,
            onPeriodChanged: (period) {
              ref
                  .read(dashboardMarketTrendViewModelProvider.notifier)
                  .changePeriod(period);
            },
            onRetry: () {
              ref
                  .read(dashboardMarketTrendViewModelProvider.notifier)
                  .refresh();
            },
          ),
        ),
      ),
    );
  }
}

class _DashboardMarketTrendContent extends StatelessWidget {
  const _DashboardMarketTrendContent({
    required this.state,
    required this.onPeriodChanged,
    required this.onRetry,
  });

  final DashboardMarketTrendState state;
  final ValueChanged<String> onPeriodChanged;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final chart = state.chart;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Market Trend',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    'Bitcoin price performance',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            _CurrencyLabel(currency: state.currency),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (chart != null) _PriceSummary(chart: chart, currency: state.currency),
        const SizedBox(height: AppSpacing.md),
        _PeriodSelector(
          selectedPeriod: state.selectedPeriod,
          onChanged: onPeriodChanged,
        ),
        const SizedBox(height: AppSpacing.md),
        if (state.isLoading && chart == null)
          const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (state.errorMessage != null && chart == null)
          _ChartError(
            message: state.errorMessage!,
            onRetry: onRetry,
          )
        else if (chart == null)
            const SizedBox(
              height: 220,
              child: Center(child: Text('No chart data available.')),
            )
          else
            _PriceChart(
              chart: chart,
              currency: state.currency,
              isLoading: state.isLoading,
            ),
        if (state.errorMessage != null && chart != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Unable to refresh chart. Showing the previous data.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.warning,
            ),
          ),
        ],
      ],
    );
  }
}

class _CurrencyLabel extends StatelessWidget {
  const _CurrencyLabel({required this.currency});

  final String currency;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      child: Text(
        currency.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PriceSummary extends StatelessWidget {
  const _PriceSummary({
    required this.chart,
    required this.currency,
  });

  final CoinChart chart;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final latestPrice = chart.summary.latestPrice;
    final percentageChange = chart.summary.percentageChange;
    final isPositive = (percentageChange ?? 0) >= 0;
    final changeColor =
    isPositive ? AppColors.positive : AppColors.negative;

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (latestPrice != null)
          Text(
            _formatCurrency(latestPrice, currency),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
          )
        else
          Text(
            'Price unavailable',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        if (percentageChange != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: changeColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
            child: Text(
              '${percentageChange >= 0 ? '+' : ''}'
                  '${percentageChange.toStringAsFixed(2)}%',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: changeColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({
    required this.selectedPeriod,
    required this.onChanged,
  });

  final String selectedPeriod;
  final ValueChanged<String> onChanged;

  static const periods = ['1d', '1w', '1m', '1y'];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: periods.map((period) {
        final selected = selectedPeriod == period;

        return ChoiceChip(
          label: Text(period.toUpperCase()),
          selected: selected,
          showCheckmark: false,
          onSelected: (_) => onChanged(period),
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: selected
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          ),
          side: BorderSide(
            color: selected
                ? AppColors.primary
                : Theme.of(context).dividerColor,
          ),
        );
      }).toList(),
    );
  }
}

class _PriceChart extends StatelessWidget {
  const _PriceChart({
    required this.chart,
    required this.currency,
    required this.isLoading,
  });

  final CoinChart chart;
  final String currency;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final points = chart.prices
        .where((point) => point.value != null)
        .toList(growable: false);

    if (points.length < 2) {
      return const SizedBox(
        height: 220,
        child: Center(
          child: Text('Not enough price history to display a chart.'),
        ),
      );
    }

    final spots = points.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.value!,
      );
    }).toList(growable: false);

    final values = spots.map((spot) => spot.y).toList();
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final range = maxValue - minValue;
    final padding =
    range == 0 ? maxValue.abs() * 0.02 + 1 : range * 0.12;

    final isPositive = (chart.summary.percentageChange ?? 0) >= 0;
    final lineColor =
    isPositive ? AppColors.positive : AppColors.negative;

    return LayoutBuilder(
      builder: (context, constraints) {
        final chartHeight = constraints.maxWidth < 420 ? 210.0 : 250.0;

        return Stack(
          children: [
            SizedBox(
              height: chartHeight,
              width: double.infinity,
              child: LineChart(
                LineChartData(
                  minY: minValue - padding,
                  maxY: maxValue + padding,
                  minX: 0,
                  maxX: (spots.length - 1).toDouble(),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: range > 0 ? range / 3 : null,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Theme.of(context)
                            .dividerColor
                            .withValues(alpha: 0.5),
                        strokeWidth: 0.7,
                      );
                    },
                  ),
                  titlesData: const FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            _formatCurrency(spot.y, currency),
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.18,
                      barWidth: 2.5,
                      color: lineColor,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: lineColor.withValues(alpha: 0.10),
                      ),
                    ),
                  ],
                ),
                duration: const Duration(milliseconds: 250),
              ),
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withValues(alpha: 0.45),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ChartError extends StatelessWidget {
  const _ChartError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: onRetry,
                child: const Text('Retry chart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatCurrency(double value, String currency) {
  const symbols = {
    'inr': '₹',
    'usd': '\$',
    'eur': '€',
    'gbp': '£',
  };

  final symbol = symbols[currency.toLowerCase()] ??
      currency.toUpperCase();

  return NumberFormat.currency(
    locale: 'en_IN',
    symbol: '$symbol ',
    decimalDigits: value.abs() < 1 ? 6 : 2,
  ).format(value);
}
