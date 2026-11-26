
import 'package:frontend/domain/entity/market_coin_entity.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import 'dashboard_formatters.dart';
import 'dashboard_section_header.dart';

class DashboardMarketMovers extends StatelessWidget {
  const DashboardMarketMovers({
    required this.gainers,
    required this.losers,
    required this.currency,
    super.key,
  });

  final List<MarketCoin> gainers;
  final List<MarketCoin> losers;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DashboardSectionHeader(
          title: 'Market Movers',
          subtitle: 'Top performing cryptocurrencies over 24 hours',
        ),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 650;

            final gainersPanel = _MoverPanel(
              title: 'Top Gainers',
              subtitle: 'Leading performers',
              coins: gainers,
              currency: currency,
              positive: true,
            );

            final losersPanel = _MoverPanel(
              title: 'Top Losers',
              subtitle: 'Biggest declines',
              coins: losers,
              currency: currency,
              positive: false,
            );

            if (wide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: gainersPanel),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: losersPanel),
                ],
              );
            }

            return Column(
              children: [
                gainersPanel,
                const SizedBox(height: AppSpacing.md),
                losersPanel,
              ],
            );
          },
        ),
      ],
    );
  }
}

class _MoverPanel extends StatelessWidget {
  const _MoverPanel({
    required this.title,
    required this.subtitle,
    required this.coins,
    required this.currency,
    required this.positive,
  });

  final String title;
  final String subtitle;
  final List<MarketCoin> coins;
  final String currency;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final movementColor =
    positive ? AppColors.positive : AppColors.negative;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: movementColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  positive
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  color: movementColor,
                  size: 21,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: movementColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: theme.dividerColor),
          if (coins.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No movement data available.',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            )
          else
            ...List.generate(coins.length, (index) {
              final coin = coins[index];

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 27,
                          height: 27,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(
                              alpha: 0.12,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                coin.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                coin.symbol.toUpperCase(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              DashboardFormatters.price(
                                coin.currentPrice,
                                currency,
                              ),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: movementColor.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Text(
                                DashboardFormatters.percentage(
                                  coin.priceChangePercentage24h,
                                ),
                                style: TextStyle(
                                  color: movementColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (index != coins.length - 1)
                    Divider(
                      height: 1,
                      color: theme.dividerColor.withValues(alpha: 0.65),
                    ),
                ],
              );
            }),
        ],
      ),
    );
  }
}
