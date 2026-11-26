import 'package:material_ui/material_ui.dart';

import '../../../app/theme/app_spacing.dart';

enum AppIconButtonVariant { standard, filled, outlined }

enum AppIconButtonSize { small, medium, large }

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.onPressed,
    this.variant = AppIconButtonVariant.standard,
    this.size = AppIconButtonSize.medium,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
    this.isEnabled = true,
    this.borderRadius,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final AppIconButtonVariant variant;
  final AppIconButtonSize size;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;
  final bool isEnabled;
  final double? borderRadius;

  double get _buttonSize => switch (size) {
    AppIconButtonSize.small => 36,
    AppIconButtonSize.medium => 44,
    AppIconButtonSize.large => 52,
  };

  double get _iconSize => switch (size) {
    AppIconButtonSize.small => 18,
    AppIconButtonSize.medium => 21,
    AppIconButtonSize.large => 24,
  };

  bool get _isInteractive => isEnabled && !isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveForeground = foregroundColor ?? theme.colorScheme.onSurface;

    final effectiveBackground =
        backgroundColor ??
        (variant == AppIconButtonVariant.filled
            ? theme.colorScheme.primaryContainer
            : Colors.transparent);

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        borderRadius ?? AppSpacing.radiusMedium,
      ),
      side: variant == AppIconButtonVariant.outlined
          ? BorderSide(color: theme.colorScheme.outlineVariant)
          : BorderSide.none,
    );

    final buttonStyle = IconButton.styleFrom(
      fixedSize: Size(_buttonSize, _buttonSize),
      foregroundColor: effectiveForeground,
      backgroundColor: effectiveBackground,
      shape: shape,
      padding: EdgeInsets.zero,
      tapTargetSize: MaterialTapTargetSize.padded,
    );

    final button = IconButton(
      onPressed: _isInteractive ? onPressed : null,
      tooltip: tooltip,
      style: buttonStyle,
      icon: isLoading
          ? SizedBox(
              width: _iconSize,
              height: _iconSize,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: effectiveForeground,
              ),
            )
          : Icon(icon, size: _iconSize),
    );

    return button;
  }
}
