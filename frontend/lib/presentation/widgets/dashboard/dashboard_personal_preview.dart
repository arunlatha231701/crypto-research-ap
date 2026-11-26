
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../providers/providers.dart';
import '../../viewmodels/portfolio_state.dart';
import 'dashboard_section_header.dart';

class DashboardPersonalPreview extends ConsumerWidget {
  const DashboardPersonalPreview({
    required this.onOpenWatchlist,
    required this.onOpenPortfolio,
    super.key,
  });

  final VoidCallback onOpenWatchlist;
  final VoidCallback onOpenPortfolio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchlistState = ref.watch(watchlistViewModelProvider);
    final portfolioState = ref.watch(portfolioViewModelProvider);
    final currency = ref.watch(marketCurrencyProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionHeader(
          title: 'Your Watchlist',
          subtitle: 'Keep your favourite coins close',
          actionLabel: 'Open',
          onAction: onOpenWatchlist,
        ),
        const SizedBox(height: AppSpacing.sm),

        _WatchlistPreviewCard(
          itemCount: watchlistState.items.length,
          isLoading: watchlistState.isLoading,
          hasError: watchlistState.errorMessage != null,
          onPressed: onOpenWatchlist,
        ),

        const SizedBox(height: AppSpacing.xl),

        const DashboardSectionHeader(
          title: 'Portfolio',
          subtitle: 'Track your crypto holdings',
        ),
        const SizedBox(height: AppSpacing.sm),

        _PortfolioPreviewCard(
          state: portfolioState,
          currency: currency,
          onPressed: onOpenPortfolio,
        ),
      ],
    );
  }
}

class _WatchlistPreviewCard extends StatelessWidget {
  const _WatchlistPreviewCard({
    required this.itemCount,
    required this.isLoading,
    required this.hasError,
    required this.onPressed,
  });

  final int itemCount;
  final bool isLoading;
  final bool hasError;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final description = isLoading
        ? 'Loading your saved cryptocurrencies...'
        : hasError && itemCount == 0
        ? 'Unable to load your watchlist. Open it to retry.'
        : itemCount == 0
        ? 'Save cryptocurrencies from the Market screen '
        'to follow them here.'
        : 'You are currently following $itemCount '
        '${itemCount == 1 ? 'cryptocurrency' : 'cryptocurrencies'}.';

    return _PreviewCard(
      icon: Icons.bookmark_border_rounded,
      title: itemCount == 0
          ? 'Your saved coins'
          : '$itemCount saved coins',
      description: description,
      onPressed: onPressed,
      actionLabel: 'Open watchlist',
      trailing: itemCount > 0
          ? _CountBadge(count: itemCount)
          : null,
      accentColor: theme.colorScheme.primary,
    );
  }
}

class _PortfolioPreviewCard extends StatelessWidget {
  const _PortfolioPreviewCard({
    required this.state,
    required this.currency,
    required this.onPressed,
  });

  final PortfolioState state;
  final String currency;
  final VoidCallback onPressed;

  String _formatCurrency(double value) {
    return NumberFormat.currency(
      name: currency.toUpperCase(),
      decimalDigits: 2,
    ).format(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasHoldings = state.holdings.isNotEmpty;
    final profit = state.totalProfitLoss;
    final isPositive = profit >= 0;

    if (state.isLoading && !hasHoldings) {
      return _PreviewCard(
        icon: Icons.account_balance_wallet_outlined,
        title: 'Portfolio',
        description: 'Loading your investments...',
        onPressed: onPressed,
        actionLabel: 'View portfolio',
        accentColor: theme.colorScheme.primary,
        isLoading: true,
      );
    }

    if (!hasHoldings) {
      return _PreviewCard(
        icon: Icons.account_balance_wallet_outlined,
        title: 'Your portfolio is empty',
        description: 'Add your cryptocurrency investments '
            'to track their value and performance.',
        onPressed: onPressed,
        actionLabel: 'Add your first holding',
        accentColor: theme.colorScheme.primary,
      );
    }

    return _PreviewCard(
      icon: Icons.account_balance_wallet_outlined,
      title: 'Total portfolio value',
      description: _formatCurrency(state.currentValue),
      onPressed: onPressed,
      actionLabel: 'View portfolio',
      accentColor: theme.colorScheme.primary,
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${isPositive ? '+' : ''}'
                '${profit.toStringAsFixed(2)} $currency',
            style: theme.textTheme.labelMedium?.copyWith(
              color: isPositive
                  ? Colors.green.shade700
                  : theme.colorScheme.error,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${isPositive ? '+' : ''}'
                '${state.totalProfitLossPercentage.toStringAsFixed(2)}%',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isPositive
                  ? Colors.green.shade700
                  : theme.colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      footer: Row(
        children: [
          Expanded(
            child: _PortfolioMetric(
              label: 'Invested',
              value: _formatCurrency(state.totalInvested),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _PortfolioMetric(
              label: 'Holdings',
              value: '${state.holdings.length}',
            ),
          ),
        ],
      ),
      message: state.marketDataError,
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onPressed,
    required this.actionLabel,
    required this.accentColor,
    this.trailing,
    this.footer,
    this.message,
    this.isLoading = false,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onPressed;
  final String actionLabel;
  final Color accentColor;
  final Widget? trailing;
  final Widget? footer;
  final String? message;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusLarge,
        ),
        side: BorderSide(color: theme.dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(
                      AppSpacing.radiusMedium,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: accentColor,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(child: trailing!),
                ],
              ],
            ),

            if (isLoading) ...[
              const SizedBox(height: AppSpacing.md),
              const LinearProgressIndicator(),
            ],

            if (footer != null) ...[
              const SizedBox(height: AppSpacing.lg),
              const Divider(),
              const SizedBox(height: AppSpacing.sm),
              footer!,
            ],

            if (message != null && message!.trim().isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Market prices may be temporarily unavailable.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.sm),

            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.arrow_forward_rounded, size: 17),
                label: Text(actionLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PortfolioMetric extends StatelessWidget {
  const _PortfolioMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        '$count',
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
