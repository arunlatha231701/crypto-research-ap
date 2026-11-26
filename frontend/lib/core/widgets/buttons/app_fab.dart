import 'package:material_ui/material_ui.dart';

import '../../../app/theme/app_spacing.dart';

enum AppFABSize { small, regular, large }

class AppFAB extends StatelessWidget {
  const AppFAB({
    required this.onPressed,
    this.icon,
    this.label,
    this.tooltip,
    this.size = AppFABSize.regular,
    this.isExtended = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.foregroundColor,
    super.key,
  }) : assert(
         icon != null || label != null,
         'Provide at least an icon or a label.',
       );

  final VoidCallback? onPressed;
  final IconData? icon;
  final String? label;
  final String? tooltip;
  final AppFABSize size;
  final bool isExtended;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? foregroundColor;

  double get _size => switch (size) {
    AppFABSize.small => 40,
    AppFABSize.regular => 56,
    AppFABSize.large => 96,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveBackground = backgroundColor ?? theme.colorScheme.primary;

    final effectiveForeground = foregroundColor ?? theme.colorScheme.onPrimary;

    final effectiveIcon = icon == null
        ? null
        : Icon(icon, size: size == AppFABSize.small ? 18 : 24);

    final effectiveLabel = label == null
        ? null
        : Text(label!, maxLines: 1, overflow: TextOverflow.ellipsis);

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
    );

    if (isExtended || label != null && icon != null) {
      return FloatingActionButton.extended(
        onPressed: isEnabled ? onPressed : null,
        tooltip: tooltip,
        backgroundColor: effectiveBackground,
        foregroundColor: effectiveForeground,
        shape: shape,
        icon: effectiveIcon,
        label: effectiveLabel!,
      );
    }

    return FloatingActionButton(
      onPressed: isEnabled ? onPressed : null,
      tooltip: tooltip,
      backgroundColor: effectiveBackground,
      foregroundColor: effectiveForeground,
      shape: shape,
      mini: size == AppFABSize.small,
      child: effectiveIcon ?? effectiveLabel,
    );
  }
}
