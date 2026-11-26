import 'package:material_ui/material_ui.dart';

import 'app_shimmer.dart';

class AppShimmerCard extends StatelessWidget {
  const AppShimmerCard({
    super.key,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.showLeading = true,
    this.showTrailing = false,
    this.lineCount = 2,
    this.enabled = true,
  }) : assert(lineCount > 0);

  final double? height;
  final EdgeInsetsGeometry padding;
  final bool showLeading;
  final bool showTrailing;
  final int lineCount;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (showLeading) ...[
                AppShimmer(
                  width: 42,
                  height: 42,
                  borderRadius: 14,
                  enabled: enabled,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmer(width: 110, height: 12, enabled: enabled),
                    const SizedBox(height: 8),
                    AppShimmer(width: 75, height: 10, enabled: enabled),
                  ],
                ),
              ),
              if (showTrailing)
                AppShimmer(
                  width: 54,
                  height: 24,
                  borderRadius: 8,
                  enabled: enabled,
                ),
            ],
          ),
          const SizedBox(height: 20),
          ...List.generate(
            lineCount,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: index == lineCount - 1 ? 0 : 10),
              child: AppShimmer(
                width: index == lineCount - 1 ? 120 : double.infinity,
                height: index == 0 ? 22 : 12,
                enabled: enabled,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
