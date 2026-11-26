
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:frontend/app/routes/route_names.dart';
import 'package:frontend/app/theme/app_spacing.dart';
import 'package:frontend/core/platform/app_icons.dart';
import 'package:frontend/core/widgets/inputs/app_search_field.dart';
import 'package:frontend/domain/entity/watchlist_item_entity.dart';
import 'package:frontend/presentation/viewmodels/market_state.dart';
import 'package:frontend/presentation/viewmodels/watchlist_state.dart';
import 'package:frontend/presentation/widgets/market/market_coin_list_item.dart';
import 'package:frontend/presentation/widgets/market/market_filter_bar.dart';
import 'package:frontend/presentation/widgets/market/market_sort_sheet.dart';
import 'package:frontend/providers/providers.dart';

class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({super.key});

  @override
  ConsumerState<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends ConsumerState<MarketScreen> {
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _scrollController = ScrollController()
      ..addListener(_handleScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();

    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 300) {
      final marketAsync = ref.read(marketExplorerProvider);
      final marketState = marketAsync.asData?.value;

      if (marketState == null ||
          !marketState.hasMore ||
          marketState.isLoadingMore ||
          marketState.loadMoreError != null) {
        return;
      }

      unawaited(
        ref.read(marketExplorerProvider.notifier).loadMore(),
      );
    }
  }

  void _openSortSheet(MarketState marketState) {
    MarketSortSheet.show(
      context: context,
      selectedSort: marketState.sortOption,
      onSortChanged: (sort) {
        ref.read(marketExplorerProvider.notifier).updateSort(sort);
      },
    );
  }

  Future<void> _refresh() {
    return ref.read(marketExplorerProvider.notifier).refresh();
  }

  WatchlistItem? _findWatchlistItem(
      List<WatchlistItem> items,
      String coinId,
      ) {
    for (final item in items) {
      if (item.coinId.toLowerCase() == coinId.toLowerCase()) {
        return item;
      }
    }

    return null;
  }

  Future<void> _toggleWatchlist(
      String coinId,
      WatchlistItem? savedItem,
      ) async {
    final notifier = ref.read(watchlistViewModelProvider.notifier);

    final success = savedItem != null
        ? await notifier.removeCoin(savedItem.id)
        : await notifier.addCoin(coinId);

    if (!mounted) return;

    final message = success
        ? savedItem != null
        ? 'Removed from your watchlist'
        : 'Added to your watchlist'
        : ref.read(watchlistViewModelProvider).errorMessage ??
        'Unable to update your watchlist. Please try again.';

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final marketAsync = ref.watch(marketExplorerProvider);
    final watchlistState = ref.watch(watchlistViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Market Explorer',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
            Text(
              'Explore the global crypto market',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1100,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
              ),

              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isShortHeight = constraints.maxHeight < 360;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: isShortHeight
                            ? AppSpacing.xs
                            : AppSpacing.sm,
                      ),

                      AppSearchField(
                        controller: _searchController,
                        hint: 'Search coins by name or symbol',
                        onChanged: (value) {
                          ref
                              .read(marketExplorerProvider.notifier)
                              .updateSearch(value);
                        },
                        onClear: () {
                          ref
                              .read(marketExplorerProvider.notifier)
                              .updateSearch('');
                        },
                      ),

                      if (!isShortHeight) ...[
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Discover assets',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Track prices, compare performance and build your watchlist.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ],

                      SizedBox(
                        height: isShortHeight
                            ? AppSpacing.xs
                            : AppSpacing.md,
                      ),

                      marketAsync.when(
                        data: (marketState) {
                          return MarketFilterBar(
                            selectedFilter: marketState.changeFilter,
                            onFilterChanged: (filter) {
                              ref
                                  .read(marketExplorerProvider.notifier)
                                  .updateFilter(filter);
                            },
                            onSortPressed: () {
                              _openSortSheet(marketState);
                            },
                          );
                        },
                        loading: () => const SizedBox(height: 40),
                        error: (_, __) => const SizedBox.shrink(),
                      ),

                      SizedBox(
                        height: isShortHeight
                            ? AppSpacing.xs
                            : AppSpacing.md,
                      ),

                      Expanded(
                        child: marketAsync.when(
                          loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          error: (error, stackTrace) => _buildErrorView(),
                          data: (marketState) {
                            return _buildMarketList(
                              marketState,
                              watchlistState,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),

            ),
          ),
        ),
      ),

    );
  }

  Widget _buildMarketList(
      MarketState marketState,
      WatchlistState watchlistState,
      ) {
    final coins = marketState.visibleCoins;

    if (coins.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: 240,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      AppIcons.searchOffRounded,
                      size: 42,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      marketState.searchQuery.isNotEmpty
                          ? 'No matching cryptocurrencies'
                          : 'No cryptocurrencies available',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      marketState.searchQuery.isNotEmpty
                          ? 'Try another coin name or symbol.'
                          : 'Pull down to refresh the market.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
          top: AppSpacing.xs,
          bottom: AppSpacing.xl,
        ),
        itemCount: coins.length + _footerItemCount(marketState),
        separatorBuilder: (_, __) =>
        const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          if (index < coins.length) {
            final coin = coins[index];

            final savedItem = _findWatchlistItem(
              watchlistState.items,
              coin.id,
            );

            final isRemoving = savedItem != null &&
                watchlistState.removingItemIds.contains(savedItem.id);

            final isAdding = watchlistState.addingCoinIds.contains(
              coin.id.toLowerCase(),
            );


            final isBookmarkBusy = isRemoving || isAdding;

            return MarketCoinListItem(
              coin: coin,
              currency: marketState.currency,
              isWatchlisted: savedItem != null,
              isBookmarkLoading: isBookmarkBusy,
              onBookmarkPressed: watchlistState.isLoading || isBookmarkBusy
                  ? null
                  : () {
                unawaited(
                  _toggleWatchlist(coin.id, savedItem),
                );
              },
              onTap: () {
                context.pushNamed(
                  RouteNames.coinDetails,
                  pathParameters: {
                    'coinId': coin.id,
                  },
                );
              },
            );
          }

          return _buildPaginationFooter(marketState);
        },
      ),
    );
  }

  int _footerItemCount(MarketState marketState) {
    if (marketState.isLoadingMore ||
        marketState.loadMoreError != null) {
      return 1;
    }

    return 0;
  }

  Widget _buildPaginationFooter(MarketState marketState) {
    if (marketState.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (marketState.loadMoreError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Center(
          child: Column(
            children: [
              Text(
                'Could not load more coins.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              TextButton(
                onPressed: () {
                  ref
                      .read(marketExplorerProvider.notifier)
                      .retryLoadMore();
                },
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildErrorView() {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.errorOutline,
              size: 44,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Unable to load market data',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Check your internet connection and try again.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: () {
                ref.invalidate(marketExplorerProvider);
              },
              icon: Icon(AppIcons.refreshRounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
