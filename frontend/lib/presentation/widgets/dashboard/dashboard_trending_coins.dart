import 'package:material_ui/material_ui.dart';

import '../../../core/widgets/cards/app_card.dart';
import '../../../core/widgets/indicators/app_change_indicator.dart';
import '../../../core/widgets/indicators/app_badge.dart';

class DashboardTrendingCoin {
  const DashboardTrendingCoin({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.changePercent,
    this.isTrending = false,
  });

  final String id;
  final String name;
  final String symbol;
  final String price;
  final double changePercent;
  final bool isTrending;
}

class DashboardTrendingCoins extends StatelessWidget {
  const DashboardTrendingCoins({
    required this.coins,
    super.key,
    this.onCoinTap,
    this.onViewAll,
  });

  final List<DashboardTrendingCoin> coins;
  final ValueChanged<String>? onCoinTap;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Trending Coins', style: theme.textTheme.titleLarge),
            ),
            if (onViewAll != null)
              TextButton(onPressed: onViewAll, child: const Text('View all')),
          ],
        ),
        const SizedBox(height: 12),
        if (coins.isEmpty)
          const AppCard(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: Text('No trending coins available')),
            ),
          )
        else
          SizedBox(
            height: 174,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: coins.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final coin = coins[index];

                return SizedBox(
                  width: 190,
                  child: AppCard(
                    onTap: onCoinTap == null ? null : () => onCoinTap!(coin.id),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                coin.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                            if (coin.isTrending)
                              const AppBadge(
                                label: 'HOT',
                                variant: AppBadgeVariant.primary,
                                isCompact: true,
                              ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          coin.symbol.toUpperCase(),
                          style: theme.textTheme.bodySmall,
                        ),
                        const Spacer(),
                        Text(
                          coin.price,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 5),
                        AppChangeIndicator(
                          changePercent: coin.changePercent,
                          isCompact: true,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
