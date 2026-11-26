
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/presentation/viewmodels/dashboard_state.dart';
import 'package:frontend/presentation/widgets/dashboard/dashboard_market_trend.dart';
import 'package:frontend/providers/providers.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/network/api_exception.dart';

import '../../widgets/dashboard/dashboard_market_movers.dart';
import '../../widgets/dashboard/dashboard_market_summary.dart';
import '../../widgets/dashboard/dashboard_personal_preview.dart';
import '../../widgets/dashboard/dashboard_section_header.dart';
import '../../widgets/dashboard/dashboard_top_coins.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardViewModelProvider);
    final currency = ref.watch(marketCurrencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Pulse'),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Select currency',
            initialValue: currency,
            onSelected: (value) {
              ref
                  .read(marketCurrencyProvider.notifier)
                  .changeCurrency(value);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'inr',
                child: Text('INR · Indian Rupee'),
              ),
              PopupMenuItem(
                value: 'usd',
                child: Text('USD · US Dollar'),
              ),
              PopupMenuItem(
                value: 'eur',
                child: Text('EUR · Euro'),
              ),
              PopupMenuItem(
                value: 'gbp',
                child: Text('GBP · British Pound'),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currency.toUpperCase(),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded),
                ],
              ),
            ),
          ),
        ],
      ),
      body: dashboardState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) {
          final message = error is ApiException
              ? error.message
              : 'Unable to load market data. Please try again.';

          return _DashboardError(
            message: message,
            onRetry: () {
              ref.read(dashboardViewModelProvider.notifier).refresh();
            },
          );
        },
        data: (data) {
          return _DashboardBody(
            data: data,
            onRefresh: () {
              return ref
                  .read(dashboardViewModelProvider.notifier)
                  .refresh();
            },
          );
        },
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({
    required this.data,
    required this.onRefresh,
  });

  final DashboardData data;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surface,
      displacement: 48,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding =
          constraints.maxWidth >= 900 ? 32.0 : 20.0;

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              AppSpacing.lg,
              horizontalPadding,
              AppSpacing.xxxl,
            ),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explore the crypto market',
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Market insights and price movements, '
                            'all in one place.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      DashboardMarketSummary(
                        stats: data.globalStats,
                        currency: data.currency,
                      ),

                      const SizedBox(height: AppSpacing.lg),
                      const DashboardMarketTrend(),
                      const SizedBox(height: AppSpacing.lg),
                      DashboardMarketMovers(
                        gainers: data.topGainers,
                        losers: data.topLosers,
                        currency: data.currency,
                      ),

                      const SizedBox(height: AppSpacing.xxl),

                      DashboardTopCoins(
                        coins: data.marketOverview,
                        currency: data.currency,
                        onCoinTap: (coin) {
                          context.push('/coin/${coin.id}');
                        },
                        onViewAll: () {
                          context.go('/market');
                        },
                      ),

                      const SizedBox(height: AppSpacing.xxl),

                      DashboardPersonalPreview(
                        onOpenWatchlist: () {
                          context.go('/watchlist');
                        },
                        onOpenPortfolio: () {
                          context.go('/portfolio');
                        },
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      DashboardSectionHeader(
                        title: 'Market data',
                        subtitle: 'Refresh to retrieve the latest values',
                        actionLabel: 'Refresh',
                        onAction: () {
                          onRefresh();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DashboardError extends StatelessWidget {
  const _DashboardError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off_outlined,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Market data unavailable',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
