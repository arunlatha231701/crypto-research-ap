
import 'dart:ui' show FontFeature;

import 'package:frontend/app/theme/app_spacing.dart';
import 'package:frontend/core/platform/app_icons.dart';
import 'package:frontend/core/widgets/buttons/app_icon_button.dart';
import 'package:frontend/core/widgets/cards/app_card.dart';
import 'package:frontend/core/widgets/indicators/app_change_indicator.dart';
import 'package:frontend/domain/entity/market_coin_entity.dart';
import 'package:material_ui/material_ui.dart';

class MarketCoinListItem extends StatelessWidget {
  const MarketCoinListItem({
    super.key,
    required this.coin,
    required this.currency,
    this.onTap,
    this.isWatchlisted = false,
    this.isBookmarkLoading = false,
    this.onBookmarkPressed,
  });

  final MarketCoin coin;
  final String currency;
  final VoidCallback? onTap;
  final bool isWatchlisted;
  final bool isBookmarkLoading;
  final VoidCallback? onBookmarkPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 520;

        return AppCard(
          onTap: onTap,
          padding: EdgeInsets.all(
            isCompact ? AppSpacing.sm : AppSpacing.md,
          ),
          child: isCompact
              ? _buildMobileLayout(context)
              : _buildWideLayout(context),
        );
      },
    );
  }

  // Mobile: two rows to avoid horizontal overflow.
  Widget _buildMobileLayout(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildCoinImage(theme, size: 42),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coin.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${coin.symbol.toUpperCase()}  •  #${coin.marketCapRank ?? '-'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 2),
            _buildBookmarkButton(theme),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Divider(
          height: 1,
          color: colors.outlineVariant.withValues(alpha: 0.55),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MARKET CAP',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                      letterSpacing: 0.7,
                      fontSize: 9,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _formatCompactValue(coin.marketCap ?? 0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatPrice(coin.currentPrice ?? 0),
                  maxLines: 1,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontFeatures: const [
                      FontFeature.tabularFigures(),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                AppChangeIndicator(
                  changePercent: coin.priceChangePercentage24h ?? 0,
                  isCompact: true,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Tablet and desktop: horizontal presentation.
  Widget _buildWideLayout(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        _buildCoinImage(theme, size: 48),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                coin.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${coin.symbol.toUpperCase()}  •  #${coin.marketCapRank ?? '-'}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'Market cap  ${_formatCompactValue(coin.marketCap ?? 0)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatPrice(coin.currentPrice ?? 0),
              maxLines: 1,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                fontFeatures: const [
                  FontFeature.tabularFigures(),
                ],
              ),
            ),
            const SizedBox(height: 7),
            AppChangeIndicator(
              changePercent: coin.priceChangePercentage24h ?? 0,
              isCompact: true,
            ),
          ],
        ),
        const SizedBox(width: AppSpacing.sm),
        _buildBookmarkButton(theme),
      ],
    );
  }

  Widget _buildCoinImage(
      ThemeData theme, {
        required double size,
      }) {
    final imageUrl = coin.image;
    final colors = theme.colorScheme;

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colors.secondary.withValues(alpha: 0.25),
        ),
      ),
      child: imageUrl != null && imageUrl.isNotEmpty
          ? Image.network(
        imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(
          AppIcons.analyticsOutlined,
          color: colors.primary,
          size: 22,
        ),
      )
          : Icon(
        AppIcons.analyticsOutlined,
        color: colors.primary,
        size: 22,
      ),
    );
  }

  Widget _buildBookmarkButton(ThemeData theme) {
    return AppIconButton(
      icon: isWatchlisted
          ? AppIcons.bookmark
          : AppIcons.bookmarkBorder,
      onPressed: onBookmarkPressed,
      size: AppIconButtonSize.small,
      variant: AppIconButtonVariant.standard,
      foregroundColor: isWatchlisted
          ? theme.colorScheme.secondary
          : theme.colorScheme.onSurfaceVariant,
      isLoading: isBookmarkLoading,
      isEnabled: onBookmarkPressed != null,
      tooltip: isWatchlisted
          ? 'Remove from watchlist'
          : 'Add to watchlist',
    );
  }

  String _formatPrice(double value) {
    final symbol = switch (currency.toLowerCase()) {
      'inr' => '₹',
      'usd' => '\$',
      'eur' => '€',
      'gbp' => '£',
      _ => '${currency.toUpperCase()} ',
    };

    return '$symbol${value.toStringAsFixed(value < 1 ? 4 : 2)}';
  }

  String _formatCompactValue(double value) {
    if (value >= 1e12) {
      return '${(value / 1e12).toStringAsFixed(2)}T';
    }
    if (value >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(2)}B';
    }
    if (value >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(2)}M';
    }
    if (value >= 1e3) {
      return '${(value / 1e3).toStringAsFixed(2)}K';
    }
    return value.toStringAsFixed(2);
  }
}
