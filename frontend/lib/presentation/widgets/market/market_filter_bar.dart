
import 'package:frontend/core/platform/app_icons.dart';
import 'package:frontend/core/widgets/buttons/app_button.dart';
import 'package:frontend/core/widgets/buttons/app_icon_button.dart';
import 'package:frontend/presentation/viewmodels/market_state.dart';
import 'package:material_ui/material_ui.dart';

class MarketFilterBar extends StatelessWidget {
  const MarketFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.onSortPressed,
  });

  final MarketChangeFilter selectedFilter;
  final ValueChanged<MarketChangeFilter> onFilterChanged;
  final VoidCallback onSortPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterButton(
                  context,
                  label: 'All',
                  filter: MarketChangeFilter.all,
                ),
                const SizedBox(width: 8),
                _buildFilterButton(
                  context,
                  label: 'Gainers',
                  filter: MarketChangeFilter.gainers,
                ),
                const SizedBox(width: 8),
                _buildFilterButton(
                  context,
                  label: 'Losers',
                  filter: MarketChangeFilter.losers,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: theme.colorScheme.secondary.withValues(alpha: 0.45),
            ),
          ),
          child: AppIconButton(
            icon: AppIcons.sortRounded,
            tooltip: 'Sort coins',
            variant: AppIconButtonVariant.standard,
            size: AppIconButtonSize.medium,
            foregroundColor: theme.colorScheme.primary,
            onPressed: onSortPressed,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton(
      BuildContext context, {
        required String label,
        required MarketChangeFilter filter,
      }) {
    final isSelected = selectedFilter == filter;

    return AppButton(
      label: label,
      size: AppButtonSize.small,
      variant: isSelected
          ? AppButtonVariant.primary
          : AppButtonVariant.outlined,
      onPressed: () => onFilterChanged(filter),
    );
  }
}
