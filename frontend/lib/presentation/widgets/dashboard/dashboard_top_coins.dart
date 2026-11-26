import 'package:frontend/domain/entity/market_coin_entity.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/theme/app_spacing.dart';
import 'dashboard_formatters.dart';
import 'dashboard_section_header.dart';

class DashboardTopCoins extends StatelessWidget {
  const DashboardTopCoins({
    required this.coins,
    required this.currency,
    this.onCoinTap,
    this.onViewAll,
    super.key,
  });

  final List<MarketCoin> coins;
  final String currency;
  final ValueChanged<MarketCoin>? onCoinTap;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionHeader(
          title: 'Top Market Coins',
          subtitle: 'Ranked by market capitalization',
          actionLabel: 'View all',
          onAction: onViewAll,
        ),
        const SizedBox(height: AppSpacing.sm),
        if (coins.isEmpty)
          const _EmptyCoins()
        else
          Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
              side: BorderSide(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              children: [
                for (var index = 0; index < coins.length; index++) ...[
                  _CoinTile(
                    coin: coins[index],
                    currency: currency,
                    onTap: onCoinTap == null
                        ? null
                        : () => onCoinTap!(coins[index]),
                  ),
                  if (index != coins.length - 1)
                    const Divider(height: 1, indent: 72),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _CoinTile extends StatelessWidget {
  const _CoinTile({required this.coin, required this.currency, this.onTap});

  final MarketCoin coin;
  final String currency;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final change = coin.priceChangePercentage24h;
    final positive = (change ?? 0) >= 0;

    return ListTile(
      onTap: onTap,
      minVerticalPadding: AppSpacing.sm,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      leading: _CoinAvatar(imageUrl: coin.image, symbol: coin.symbol),
      title: Text(
        coin.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleSmall,
      ),
      subtitle: Text(
        '#${coin.marketCapRank ?? '—'} · ${coin.symbol.toUpperCase()}',
        style: theme.textTheme.bodySmall,
      ),
      trailing: SizedBox(
        width: 125,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              DashboardFormatters.price(coin.currentPrice, currency),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 3),
            Text(
              DashboardFormatters.percentage(change),
              style: theme.textTheme.bodySmall?.copyWith(
                color: positive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoinAvatar extends StatelessWidget {
  const _CoinAvatar({required this.imageUrl, required this.symbol});

  final String? imageUrl;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CircleAvatar(
      radius: 21,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      child: imageUrl == null
          ? Text(
              symbol.isEmpty ? '?' : symbol.substring(0, 1).toUpperCase(),
              style: theme.textTheme.titleSmall,
            )
          : ClipOval(
              child: Image.network(
                imageUrl!,
                width: 42,
                height: 42,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Text(
                  symbol.isEmpty ? '?' : symbol.substring(0, 1).toUpperCase(),
                ),
              ),
            ),
    );
  }
}

class _EmptyCoins extends StatelessWidget {
  const _EmptyCoins();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Center(child: Text('No market coins available right now.')),
    );
  }
}
