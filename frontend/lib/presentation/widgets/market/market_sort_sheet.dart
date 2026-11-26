
import 'package:frontend/app/theme/app_spacing.dart';
import 'package:frontend/core/platform/app_icons.dart';
import 'package:frontend/presentation/viewmodels/market_state.dart';
import 'package:material_ui/material_ui.dart';

class MarketSortSheet extends StatelessWidget {
  const MarketSortSheet({
    super.key,
    required this.selectedSort,
    required this.onSortChanged,
  });

  final MarketSortOption selectedSort;
  final ValueChanged<MarketSortOption> onSortChanged;

  static Future<void> show({
    required BuildContext context,
    required MarketSortOption selectedSort,
    required ValueChanged<MarketSortOption> onSortChanged,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MarketSortSheet(
        selectedSort: selectedSort,
        onSortChanged: onSortChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final options = MarketSortOption.values;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusExtraLarge),
        ),
        border: Border.all(
          color: theme.colorScheme.secondary.withValues(alpha: 0.25),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sort market',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Choose how cryptocurrencies are arranged',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Close sort options',
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  AppIcons.closeRounded,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...options.map(
                (option) => _SortOptionTile(
              title: _labelFor(option),
              isSelected: selectedSort == option,
              onTap: () {
                onSortChanged(option);
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  String _labelFor(MarketSortOption option) {
    return switch (option) {
      MarketSortOption.marketCap => 'Market capitalisation',
      MarketSortOption.priceAscending => 'Price: low to high',
      MarketSortOption.priceDescending => 'Price: high to low',
      MarketSortOption.changeAscending => '24H change: lowest first',
      MarketSortOption.changeDescending => '24H change: highest first',
      MarketSortOption.name => 'Name: A to Z',
    };
  }
}

class _SortOptionTile extends StatelessWidget {
  const _SortOptionTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: isSelected
            ? colors.primary.withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
                          ? colors.primary
                          : colors.onSurface,
                    ),
                  ),
                ),
                Icon(
                  isSelected
                      ? AppIcons.radioButtonChecked
                      : AppIcons.radioButtonOff,
                  color: isSelected
                      ? colors.secondary
                      : colors.onSurfaceVariant,
                  size: 21,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
