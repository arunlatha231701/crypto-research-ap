import 'package:material_ui/material_ui.dart';

import '../../../core/widgets/cards/app_card.dart';
import '../../../core/widgets/indicators/app_change_indicator.dart';
import '../../../core/widgets/buttons/app_button.dart';

class DashboardPortfolioOverview extends StatelessWidget {
  const DashboardPortfolioOverview({
    required this.totalValue,
    required this.investedAmount,
    required this.profitLoss,
    required this.profitLossPercent,
    super.key,
    this.onViewPortfolio,
  });

  final String totalValue;
  final String investedAmount;
  final String profitLoss;
  final double profitLossPercent;
  final VoidCallback? onViewPortfolio;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('My Portfolio', style: theme.textTheme.titleLarge),
              ),
              if (onViewPortfolio != null)
                TextButton(
                  onPressed: onViewPortfolio,
                  child: const Text('View all'),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Text('Total portfolio value', style: theme.textTheme.bodySmall),
          const SizedBox(height: 6),
          Text(totalValue, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _PortfolioMetric(
                  label: 'Invested amount',
                  value: investedAmount,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total P/L', style: theme.textTheme.bodySmall),
                    const SizedBox(height: 6),
                    Text(
                      profitLoss,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: profitLossPercent > 0
                            ? const Color(0xFF159B68)
                            : profitLossPercent < 0
                            ? theme.colorScheme.error
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AppChangeIndicator(
                      changePercent: profitLossPercent,
                      isCompact: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (onViewPortfolio != null) ...[
            const SizedBox(height: 18),
            AppButton(
              label: 'View Portfolio',
              onPressed: onViewPortfolio,
              isFullWidth: true,
              size: AppButtonSize.medium,
            ),
          ],
        ],
      ),
    );
  }
}

class _PortfolioMetric extends StatelessWidget {
  const _PortfolioMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodySmall),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
