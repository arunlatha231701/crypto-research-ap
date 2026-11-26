import 'package:material_ui/material_ui.dart';

enum AppBadgeVariant { primary, success, danger, warning, neutral }

class AppBadge extends StatelessWidget {
  const AppBadge({
    required this.label,
    super.key,
    this.variant = AppBadgeVariant.neutral,
    this.icon,
    this.isOutlined = false,
    this.isCompact = false,
  });

  final String label;
  final AppBadgeVariant variant;
  final IconData? icon;
  final bool isOutlined;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color foreground;
    final Color background;

    switch (variant) {
      case AppBadgeVariant.primary:
        foreground = theme.colorScheme.primary;
        background = theme.colorScheme.primaryContainer;
      case AppBadgeVariant.success:
        foreground = const Color(0xFF16865B);
        background = const Color(0xFF16865B).withValues(alpha: 0.10);
      case AppBadgeVariant.danger:
        foreground = theme.colorScheme.error;
        background = theme.colorScheme.errorContainer;
      case AppBadgeVariant.warning:
        foreground = const Color(0xFFB7791F);
        background = const Color(0xFFB7791F).withValues(alpha: 0.10);
      case AppBadgeVariant.neutral:
        foreground = theme.colorScheme.onSurfaceVariant;
        background = theme.colorScheme.surfaceContainerHighest;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 10,
        vertical: isCompact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : background,
        borderRadius: BorderRadius.circular(8),
        border: isOutlined
            ? Border.all(color: foreground.withValues(alpha: 0.5))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: isCompact ? 12 : 14, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
