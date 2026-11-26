import 'package:material_ui/material_ui.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import 'app_card.dart';

class AppStatCard extends StatelessWidget {
  const AppStatCard({
    required this.title,
    required this.value,
    this.subtitle,
    this.change,
    this.isPositive,
    this.icon,
    this.valueColor,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.cardPadding),
    super.key,
  });

  final String title;
  final String value;
  final String? subtitle;
  final String? change;
  final bool? isPositive;
  final IconData? icon;
  final Color? valueColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final trendColor = isPositive == null
        ? theme.colorScheme.onSurfaceVariant
        : isPositive!
        ? AppColors.positive
        : AppColors.negative;

    return AppCard(
      padding: padding,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: AppSpacing.xs),
                Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: valueColor ?? theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (change != null || subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xxs,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (change != null)
                  Text(
                    change!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: trendColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
