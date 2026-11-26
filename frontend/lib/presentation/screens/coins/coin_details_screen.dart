
import 'dart:async';
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/core/platform/app_icons.dart';
import 'package:frontend/core/widgets/buttons/app_icon_button.dart';
import 'package:frontend/domain/entity/watchlist_item_entity.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/app/theme/app_spacing.dart';
import 'package:frontend/presentation/viewmodels/coin_details_state.dart';
import 'package:frontend/providers/providers.dart';

class CoinDetailsScreen extends ConsumerWidget {
  const CoinDetailsScreen({
    required this.coinId,
    super.key,
  });

  final String coinId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(
      coinDetailsViewModelProvider(coinId),
    );
    final watchlistState = ref.watch(watchlistViewModelProvider);

    WatchlistItem? savedItem;

    for (final item in watchlistState.items) {
      if (item.coinId.toLowerCase() == coinId.toLowerCase()) {
        savedItem = item;
        break;
      }
    }

    final isWatchlisted = savedItem != null;

    final isBookmarkLoading = isWatchlisted
        ? watchlistState.removingItemIds.contains(savedItem!.id)
        : watchlistState.addingCoinIds.contains(coinId.toLowerCase());

    Future<void> toggleWatchlist() async {
      final notifier = ref.read(watchlistViewModelProvider.notifier);

      final success = savedItem != null
          ? await notifier.removeCoin(savedItem!.id)
          : await notifier.addCoin(coinId);

      if (!context.mounted) return;

      final message = success
          ? savedItem != null
          ? 'Removed from your watchlist'
          : 'Added to your watchlist'
          : ref.read(watchlistViewModelProvider).errorMessage ??
          'Unable to update your watchlist.';

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Coin Details'),
        actions: [
          AppIconButton(
            icon: isWatchlisted
                ? AppIcons.bookmark
                : AppIcons.bookmarkBorder,
            tooltip: isWatchlisted
                ? 'Remove from watchlist'
                : 'Add to watchlist',
            isLoading: isBookmarkLoading,
            isEnabled: !watchlistState.isLoading && !isBookmarkLoading,
            foregroundColor: isWatchlisted
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
            onPressed: watchlistState.isLoading || isBookmarkLoading
                ? null
                : () {
              unawaited(toggleWatchlist());
            },
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              ref
                  .read(coinDetailsViewModelProvider(coinId).notifier)
                  .refresh();
            },
            icon: Icon(AppIcons.refreshRounded),
          ),
        ],
      ),
      body: detailsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => _ErrorContent(
          message: error.toString().replaceFirst('Exception: ', ''),
          onRetry: () {
            ref.invalidate(
              coinDetailsViewModelProvider(coinId),
            );
          },
        ),
        data: (detailsState) {
          return RefreshIndicator(
            onRefresh: () {
              return ref
                  .read(coinDetailsViewModelProvider(coinId).notifier)
                  .refresh();
            },
            child: _CoinDetailsContent(
              state: detailsState,
              onPeriodChanged: (period) {
                ref
                    .read(coinDetailsViewModelProvider(coinId).notifier)
                    .changePeriod(period);
              },
              onCurrencyChanged: (currency) {
                ref
                    .read(coinDetailsViewModelProvider(coinId).notifier)
                    .changeCurrency(currency);
              },
              onRetryChart: () {
                ref
                    .read(coinDetailsViewModelProvider(coinId).notifier)
                    .retryChart();
              },
            ),
          );
        },
      ),
    );
  }
}

class _CoinDetailsContent extends StatelessWidget {
  const _CoinDetailsContent({
    required this.state,
    required this.onPeriodChanged,
    required this.onCurrencyChanged,
    required this.onRetryChart,
  });

  final CoinDetailsState state;
  final ValueChanged<String> onPeriodChanged;
  final ValueChanged<String> onCurrencyChanged;
  final VoidCallback onRetryChart;

  @override
  Widget build(BuildContext context) {
    final details = state.details;
    final currency = state.currency;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      children: [
        _CoinIdentitySection(
          name: details.name,
          symbol: details.symbol,
          imageUrl: details.image,
          rank: details.marketCapRank,
        ),
        const SizedBox(height: AppSpacing.xl),

        _PriceSection(
          price: details.price(currency),
          change: details.priceChange24h(),
          currency: currency,
        ),
        const SizedBox(height: AppSpacing.xl),

        _SectionHeading(
          title: 'Price Performance',
          subtitle: 'Historical price movement',
        ),
        const SizedBox(height: AppSpacing.md),

        _CurrencySelector(
          selectedCurrency: currency,
          onChanged: onCurrencyChanged,
        ),
        const SizedBox(height: AppSpacing.md),

        _ChartPeriodSelector(
          selectedPeriod: state.selectedPeriod,
          onChanged: onPeriodChanged,
        ),
        const SizedBox(height: AppSpacing.md),

        _PriceChartSection(
          state: state,
          onRetry: onRetryChart,
        ),
        const SizedBox(height: AppSpacing.xl),

        _SectionHeading(
          title: 'Market Statistics',
          subtitle: 'Key market indicators',
        ),
        const SizedBox(height: AppSpacing.md),

        _MarketStatisticsSection(
          details: details,
          currency: currency,
        ),
        const SizedBox(height: AppSpacing.xl),

        _SectionHeading(
          title: 'Supply Information',
          subtitle: 'Available coin supply',
        ),
        const SizedBox(height: AppSpacing.md),

        _SupplySection(details: details),
        const SizedBox(height: AppSpacing.xl),

        if (details.description != null &&
            details.description!.trim().isNotEmpty) ...[
          _SectionHeading(
            title: 'About ${details.name}',
            subtitle: 'Project overview',
          ),
          const SizedBox(height: AppSpacing.md),
          _DescriptionSection(
            description: details.description!,
          ),
          const SizedBox(height: AppSpacing.xl),
        ],

        if (details.genesisDate != null)
          _InformationRow(
            label: 'Genesis Date',
            value: DateFormat('dd MMM yyyy')
                .format(details.genesisDate!),
          ),

        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _CoinIdentitySection extends StatelessWidget {
  const _CoinIdentitySection({
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.rank,
  });

  final String name;
  final String symbol;
  final String? imageUrl;
  final int? rank;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        _CoinImage(imageUrl: imageUrl),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                symbol.toUpperCase(),
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.lightSecondaryText,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        if (rank != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(
                AppSpacing.radiusSmall,
              ),
            ),
            child: Text(
              '#$rank',
              style: textTheme.labelLarge?.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

class _CoinImage extends StatelessWidget {
  const _CoinImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: SizedBox(
        width: 56,
        height: 56,
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallback(),
        )
            : _fallback(),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.10),
      alignment: Alignment.center,
      child: Icon(
        AppIcons.analyticsOutlined,
        color: AppColors.primary,
        size: 28,
      ),
    );
  }
}

class _PriceSection extends StatelessWidget {
  const _PriceSection({
    required this.price,
    required this.change,
    required this.currency,
  });

  final double? price;
  final double? change;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final positive = (change ?? 0) >= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Price',
          style: textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          price == null
              ? 'Unavailable'
              : _formatCurrency(price!, currency),
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (change != null)
          Row(
            children: [
              Icon(
                positive
                    ? AppIcons.trendingUpRounded
                    : AppIcons.trendingDownRounded,
                size: 18,
                color: positive
                    ? AppColors.positive
                    : AppColors.negative,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '${change! >= 0 ? '+' : ''}${change!.toStringAsFixed(2)}% (24h)',
                style: textTheme.bodyMedium?.copyWith(
                  color: positive
                      ? AppColors.positive
                      : AppColors.negative,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _CurrencySelector extends StatelessWidget {
  const _CurrencySelector({
    required this.selectedCurrency,
    required this.onChanged,
  });

  final String selectedCurrency;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: DropdownButton<String>(
        value: selectedCurrency,
        underline: const SizedBox.shrink(),
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusMedium,
        ),
        items: const [
          DropdownMenuItem(value: 'inr', child: Text('INR')),
          DropdownMenuItem(value: 'usd', child: Text('USD')),
          DropdownMenuItem(value: 'eur', child: Text('EUR')),
          DropdownMenuItem(value: 'gbp', child: Text('GBP')),
        ],
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
      ),
    );
  }
}

class _ChartPeriodSelector extends StatelessWidget {
  const _ChartPeriodSelector({
    required this.selectedPeriod,
    required this.onChanged,
  });

  final String selectedPeriod;
  final ValueChanged<String> onChanged;

  static const periods = ['1d', '1w', '1m', '1y'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: periods.map((period) {
        final selected = selectedPeriod == period;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: ChoiceChip(
              label: Center(
                child: Text(period.toUpperCase()),
              ),
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
                borderRadius: BorderRadius.circular(
                  AppSpacing.radiusSmall,
                ),
              ),
              side: BorderSide(
                color: selected
                    ? AppColors.primary
                    : Theme.of(context).dividerColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _PriceChartSection extends StatelessWidget {
  const _PriceChartSection({
    required this.state,
    required this.onRetry,
  });

  final CoinDetailsState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final chart = state.chart;

    if (state.isChartLoading && chart == null) {
      return const SizedBox(
        height: 240,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.chartError != null && chart == null) {
      return SizedBox(
        height: 240,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.chartError!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: onRetry,
                child: const Text('Retry chart'),
              ),
            ],
          ),
        ),
      );
    }

    final points = chart?.prices
        .where((point) => point.value != null)
        .toList() ??
        [];

    if (points.length < 2) {
      return const SizedBox(
        height: 240,
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
    }).toList();

    final values = spots.map((spot) => spot.y).toList();
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final range = maxValue - minValue;
    final padding = range == 0 ? maxValue.abs() * 0.02 + 1 : range * 0.12;

    return Stack(
      children: [
        SizedBox(
          height: 240,
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
                        _formatCurrency(
                          spot.y,
                          state.currency,
                        ),
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
                  color: AppColors.primary,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.primary.withValues(alpha: 0.10),
                  ),
                ),
              ],
            ),
            duration: const Duration(milliseconds: 250),
          ),
        ),
        if (state.isChartLoading)
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
  }
}

class _MarketStatisticsSection extends StatelessWidget {
  const _MarketStatisticsSection({
    required this.details,
    required this.currency,
  });

  final dynamic details;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StatRow(
          label: 'Market Cap',
          value: _formatOptionalCurrency(
            details.marketCap(currency),
            currency,
          ),
        ),
        _StatRow(
          label: '24h Trading Volume',
          value: _formatOptionalCurrency(
            details.totalVolume(currency),
            currency,
          ),
        ),
        _StatRow(
          label: '24h High',
          value: _formatOptionalCurrency(
            details.high24h(currency),
            currency,
          ),
        ),
        _StatRow(
          label: '24h Low',
          value: _formatOptionalCurrency(
            details.low24h(currency),
            currency,
          ),
        ),
      ],
    );
  }
}

class _SupplySection extends StatelessWidget {
  const _SupplySection({required this.details});

  final dynamic details;

  @override
  Widget build(BuildContext context) {
    final circulating = details.circulatingSupply() as double?;
    final total = details.totalSupply() as double?;
    final maximum = details.maxSupply() as double?;

    final denominator = maximum ?? total;
    final progress = circulating != null &&
        denominator != null &&
        denominator > 0
        ? (circulating / denominator).clamp(0.0, 1.0)
        : null;

    return Column(
      children: [
        _StatRow(
          label: 'Circulating Supply',
          value: _formatOptionalNumber(circulating),
        ),
        _StatRow(
          label: 'Total Supply',
          value: _formatOptionalNumber(total),
        ),
        _StatRow(
          label: 'Maximum Supply',
          value: maximum == null
              ? 'Unlimited / unavailable'
              : _formatOptionalNumber(maximum),
        ),
        if (progress != null) ...[
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              valueColor: const AlwaysStoppedAnimation(
                AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${(progress * 100).toStringAsFixed(1)}% of maximum supply',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ],
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        height: 1.6,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InformationRow extends StatelessWidget {
  const _InformationRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return _StatRow(label: label, value: value);
  }
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.errorOutline,
              size: 42,
              color: AppColors.negative,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Unable to load coin details',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatCurrency(double value, String currency) {
  final symbols = {
    'inr': '₹',
    'usd': '\$',
    'eur': '€',
    'gbp': '£',
  };

  final symbol = symbols[currency.toLowerCase()] ?? currency.toUpperCase();

  return NumberFormat.currency(
    locale: 'en_IN',
    symbol: '$symbol ',
    decimalDigits: value.abs() < 1 ? 6 : 2,
  ).format(value);
}
String _formatOptionalCurrency(double? value, String currency) {
  if (value == null) return 'Unavailable';

  final symbols = {
    'inr': '₹',
    'usd': '\$',
    'eur': '€',
    'gbp': '£',
  };

  final symbol = symbols[currency.toLowerCase()] ??
      currency.toUpperCase();

  return '$symbol ${NumberFormat.compact(
    locale: 'en_IN',
  ).format(value)}';
}

String _formatOptionalNumber(double? value) {
  if (value == null) return 'Unavailable';

  return NumberFormat.compact(
    locale: 'en_IN',
  ).format(value);
}
