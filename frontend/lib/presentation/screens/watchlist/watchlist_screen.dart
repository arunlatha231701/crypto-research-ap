
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/app/theme/app_spacing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:frontend/app/routes/route_names.dart';
import 'package:frontend/core/platform/app_icons.dart';
import 'package:frontend/core/widgets/cards/app_card.dart';
import 'package:frontend/core/widgets/feedback/app_empty_view.dart';
import 'package:frontend/core/widgets/feedback/app_error_view.dart';
import 'package:frontend/core/widgets/indicators/app_change_indicator.dart';
import 'package:frontend/core/widgets/buttons/app_icon_button.dart';
import 'package:frontend/presentation/viewmodels/watchlist_state.dart';
import 'package:frontend/providers/providers.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(watchlistViewModelProvider);
    final currency = ref.watch(marketCurrencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Watchlist'),
        actions: [
          AppIconButton(
            icon: AppIcons.refreshRounded,
            tooltip: 'Refresh watchlist',
            onPressed: state.isRefreshing || state.isLoading
                ? null
                : () => ref
                .read(watchlistViewModelProvider.notifier)
                .loadWatchlist(),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref
            .read(watchlistViewModelProvider.notifier)
            .loadWatchlist(),
        child: _buildContent(
          context,
          ref,
          state,
          currency,
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      WidgetRef ref,
      WatchlistState state,
      String currency,
      ) {
    if (state.isLoading && state.items.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.errorMessage != null && state.items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          SizedBox(
            height: 300,
            child: AppErrorView(
              message: state.errorMessage!,
              onRetry: () => ref
                  .read(watchlistViewModelProvider.notifier)
                  .loadWatchlist(),
            ),
          ),
        ],
      );
    }

    if (state.items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          const SizedBox(height: 80),
          AppEmptyView(
            title: 'Your watchlist is empty',
            message:
            'Explore the market and bookmark cryptocurrencies '
                'you want to follow. They will appear here.',
            icon: AppIcons.bookmarkBorder,
          ),
        ],
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        AppSpacing.lg,
        AppSpacing.screenHorizontal,
        AppSpacing.xxxl,
      ),
      children: [
        _buildHeader(state),
        const SizedBox(height: AppSpacing.lg),

        if (state.errorMessage != null) ...[
          _buildMessageBanner(
            state.errorMessage!,
            isError: true,
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        if (state.marketDataError != null) ...[
          _buildMessageBanner(
            'Market prices could not be updated. '
                'Your saved coins are still available.',
            isError: false,
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        if (state.isRefreshing)
          const LinearProgressIndicator(),

        ...state.items.map((item) {
          final coin = state.marketCoinFor(item.coinId);
          final isRemoving =
          state.removingItemIds.contains(item.id);

          return Padding(
            padding: const EdgeInsets.only(
              bottom: AppSpacing.md,
            ),
            child: _WatchlistCoinCard(
              coinId: item.coinId,
              name: coin?.name,
              symbol: coin?.symbol,
              imageUrl: coin?.image,
              price: coin?.currentPrice,
              change24h: coin?.priceChangePercentage24h,
              currency: currency,
              isRemoving: isRemoving,
              onTap: () {
                context.pushNamed(
                  RouteNames.coinDetails,
                  pathParameters: {
                    'coinId': item.coinId,
                  },
                );
              },
              onRemove: isRemoving
                  ? null
                  : () => _removeCoin(
                context,
                ref,
                item.id,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildHeader(WatchlistState state) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saved cryptocurrencies',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.lightText,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Keep track of the assets that matter to you.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.lightSecondaryText,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${state.items.length} saved',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBanner(
      String message, {
        required bool isError,
      }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isError
            ? AppColors.negative.withValues(alpha: 0.08)
            : AppColors.warning.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusMedium,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isError
                ? AppIcons.errorOutline
                : AppIcons.warningAmberRounded,
            size: 18,
            color: isError
                ? AppColors.negative
                : AppColors.warning,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12,
                color: isError
                    ? AppColors.negative
                    : AppColors.lightText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _removeCoin(
      BuildContext context,
      WidgetRef ref,
      int itemId,
      ) async {
    final success = await ref
        .read(watchlistViewModelProvider.notifier)
        .removeCoin(itemId);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Removed from your watchlist'
              : 'Could not remove this cryptocurrency',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _WatchlistCoinCard extends StatelessWidget {
  const _WatchlistCoinCard({
    required this.coinId,
    required this.currency,
    required this.isRemoving,
    required this.onTap,
    required this.onRemove,
    this.name,
    this.symbol,
    this.imageUrl,
    this.price,
    this.change24h,
  });

  final String coinId;
  final String currency;
  final String? name;
  final String? symbol;
  final String? imageUrl;
  final double? price;
  final double? change24h;
  final bool isRemoving;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  String _formatPrice(double value) {
    final decimalDigits = value >= 1 ? 2 : 6;

    return NumberFormat.currency(
      name: currency.toUpperCase(),
      decimalDigits: decimalDigits,
    ).format(value);
  }

  @override
  Widget build(BuildContext context) {
    final displayName = name ?? _fallbackName(coinId);
    final displaySymbol = symbol?.toUpperCase() ?? '--';

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          _buildCoinLogo(displayName),
          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  displaySymbol,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.lightSecondaryText,
                  ),
                ),
                if (price != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  AppChangeIndicator(
                    changePercent: change24h ?? 0,
                    isCompact: true,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.sm),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price == null ? '--' : _formatPrice(price!),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.lightText,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppIconButton(
                icon: isRemoving
                    ? AppIcons.circle
                    : AppIcons.bookmark,
                tooltip: 'Remove from watchlist',
                variant: AppIconButtonVariant.standard,
                size: AppIconButtonSize.small,
                onPressed: onRemove,
                isLoading: isRemoving,
                foregroundColor: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoinLogo(String displayName) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.network(
          imageUrl!,
          width: 44,
          height: 44,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallbackLogo(displayName),
        ),
      );
    }

    return _fallbackLogo(displayName);
  }

  Widget _fallbackLogo(String displayName) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.09),
        shape: BoxShape.circle,
      ),
      child: Text(
        displayName.isNotEmpty
            ? displayName.substring(0, 1).toUpperCase()
            : '?',
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
          fontSize: 17,
        ),
      ),
    );
  }

  String _fallbackName(String id) {
    return id
        .split('-')
        .map(
          (part) => part.isEmpty
          ? part
          : '${part[0].toUpperCase()}${part.substring(1)}',
    )
        .join(' ');
  }
}
