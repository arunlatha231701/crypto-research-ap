import 'package:material_ui/material_ui.dart';

import 'app_shimmer.dart';

class AppShimmerListTile extends StatelessWidget {
  const AppShimmerListTile({
    super.key,
    this.showLeading = true,
    this.showTrailing = true,
    this.enabled = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  final bool showLeading;
  final bool showTrailing;
  final bool enabled;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          if (showLeading) ...[
            AppShimmer(
              width: 44,
              height: 44,
              borderRadius: 22,
              enabled: enabled,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmer(width: 115, height: 14, enabled: enabled),
                const SizedBox(height: 8),
                AppShimmer(width: 75, height: 11, enabled: enabled),
              ],
            ),
          ),
          if (showTrailing) ...[
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppShimmer(width: 75, height: 14, enabled: enabled),
                const SizedBox(height: 8),
                AppShimmer(width: 48, height: 11, enabled: enabled),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
