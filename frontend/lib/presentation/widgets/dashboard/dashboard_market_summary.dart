
import 'package:frontend/domain/entity/global_market_stats_entity.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import 'dashboard_formatters.dart';

class DashboardMarketSummary extends StatelessWidget {
  const DashboardMarketSummary({
    required this.stats,
    required this.currency,
    super.key,
  });

  final GlobalMarketStats stats;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final marketCap = stats.marketCapFor(currency);
    final marketChange = stats.marketCapChangePercentage24h;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF073E30),
                Color(0xFF0B5B45),
                Color(0xFF126B50),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.secondary.withValues(alpha: 0.45),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.16),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -35,
                top: -55,
                child: Container(
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.goldLight.withValues(alpha: 0.12),
                      width: 24,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.public_rounded,
                            color: AppColors.goldLight,
                            size: 19,
                          ),
                        ),
                        const SizedBox(width: 11),
                        const Text(
                          'GLOBAL MARKET OVERVIEW',
                          style: TextStyle(
                            color: AppColors.goldLight,
                            fontSize: 11,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    const Text(
                      'Total Market Capitalization',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DashboardFormatters.compactCurrency(
                        marketCap,
                        currency,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.1,
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (marketChange != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.11),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: AppColors.goldLight.withValues(
                              alpha: 0.25,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              marketChange >= 0
                                  ? Icons.trending_up_rounded
                                  : Icons.trending_down_rounded,
                              color: AppColors.goldLight,
                              size: 17,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              DashboardFormatters.percentage(marketChange),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              '24h change',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    Divider(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      children: [
                        Icon(
                          Icons.insights_rounded,
                          size: 15,
                          color: AppColors.goldLight,
                        ),
                        SizedBox(width: 7),
                        Text(
                          'Global cryptocurrency market',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 700 ? 4 : 2;
            const spacing = AppSpacing.sm;
            final itemWidth =
                (constraints.maxWidth - spacing * (columns - 1)) /
                    columns;

            final metrics = [
              _MetricData(
                title: '24h Volume',
                value: DashboardFormatters.compactCurrency(
                  stats.volumeFor(currency),
                  currency,
                ),
                icon: Icons.swap_vert_rounded,
              ),
              _MetricData(
                title: 'BTC Dominance',
                value:
                '${(stats.dominanceFor('btc') ?? 0).toStringAsFixed(2)}%',
                icon: Icons.pie_chart_outline_rounded,
              ),
              _MetricData(
                title: 'Active Coins',
                value: DashboardFormatters.compactNumber(
                  stats.activeCryptocurrencies,
                ),
                icon: Icons.currency_bitcoin_rounded,
              ),
              _MetricData(
                title: 'Markets',
                value: DashboardFormatters.compactNumber(stats.markets),
                icon: Icons.public_rounded,
              ),
            ];

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: metrics.map((metric) {
                return SizedBox(
                  width: itemWidth,
                  child: _MetricCard(
                    metric: metric,
                    isDark: isDark,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _MetricData {
  const _MetricData({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.metric,
    required this.isDark,
  });

  final _MetricData metric;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.secondary.withValues(
          alpha: isDark ? 0.22 : 0.28,
        )),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.08 : 0.025,
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              metric.icon,
              color: AppColors.secondary,
              size: 19,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            metric.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            metric.title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
