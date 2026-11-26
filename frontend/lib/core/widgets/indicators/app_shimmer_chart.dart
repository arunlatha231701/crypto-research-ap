import 'package:material_ui/material_ui.dart';

import 'app_shimmer.dart';

class AppShimmerChart extends StatelessWidget {
  const AppShimmerChart({
    super.key,
    this.height = 220,
    this.showHeader = true,
    this.showPeriodSelector = true,
    this.enabled = true,
    this.padding = const EdgeInsets.all(16),
  });

  final double height;
  final bool showHeader;
  final bool showPeriodSelector;
  final bool enabled;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHeader) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppShimmer(width: 110, height: 16, enabled: enabled),
                AppShimmer(width: 65, height: 16, enabled: enabled),
              ],
            ),
            const SizedBox(height: 20),
          ],
          SizedBox(
            height: height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                4,
                (index) => AppShimmer(
                  width: double.infinity,
                  height: 1,
                  borderRadius: 1,
                  enabled: enabled,
                ),
              ),
            ),
          ),
          if (showPeriodSelector) ...[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                4,
                (index) => AppShimmer(
                  width: 38,
                  height: 24,
                  borderRadius: 8,
                  enabled: enabled,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
