import 'package:material_ui/material_ui.dart';

import '../../../core/widgets/cards/app_card.dart';
import '../../../core/widgets/indicators/app_change_indicator.dart';
import '../../../core/widgets/indicators/app_badge.dart';

class DashboardWatchlistCoin {
  const DashboardWatchlistCoin({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.changePercent,
  });

  final String id;
  final String name;
  final String symbol;
  final String price;
  final double changePercent;
}

class DashboardWatchlistPreview extends StatelessWidget {
  const DashboardWatchlistPreview({
    required this.coins,
    super.key,
    this.onCoinTap,
    this.onViewAll,
    this.onExplore,
  });

  final List<DashboardWatchlistCoin> coins;
  final ValueChanged<String>? onCoinTap;
  final VoidCallback? onViewAll;
  final VoidCallback? onExplore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('My Watchlist', style: theme.textTheme.titleLarge),
              ),
              if (coins.isNotEmpty && onViewAll != null)
                TextButton(onPressed: onViewAll, child: const Text('View all')),
            ],
          ),
          const SizedBox(height: 12),
          if (coins.isEmpty)
            _buildEmptyState(context)
          else
            ...coins.take(4).map((coin) => _buildCoinRow(context, coin)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const AppBadge(
            label: 'PERSONALIZE YOUR MARKET',
            variant: AppBadgeVariant.primary,
            isCompact: true,
          ),
          const SizedBox(height: 12),
          Text(
            'Your watchlist is waiting',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Save cryptocurrencies to follow their prices and daily movements.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
          if (onExplore != null) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: onExplore,
              child: const Text('Explore markets'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCoinRow(BuildContext context, DashboardWatchlistCoin coin) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onCoinTap == null ? null : () => onCoinTap!(coin.id),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coin.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    coin.symbol.toUpperCase(),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(coin.price, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                AppChangeIndicator(
                  changePercent: coin.changePercent,
                  isCompact: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
