import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/app/theme/app_spacing.dart';
import 'package:material_ui/material_ui.dart';

enum AppButtonVariant { primary, secondary, outlined, text, danger }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.isEnabled = true,
    this.borderRadius,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  final AppButtonVariant variant;
  final AppButtonSize size;

  final IconData? leadingIcon;
  final IconData? trailingIcon;

  final bool isLoading;
  final bool isFullWidth;
  final bool isEnabled;

  final double? borderRadius;

  double get _height {
    return switch (size) {
      AppButtonSize.small => 40,
      AppButtonSize.medium => 48,
      AppButtonSize.large => 54,
    };
  }

  double get _horizontalPadding {
    return switch (size) {
      AppButtonSize.small => 12,
      AppButtonSize.medium => 20,
      AppButtonSize.large => 24,
    };
  }

  double get _iconSize {
    return switch (size) {
      AppButtonSize.small => 16,
      AppButtonSize.medium => 18,
      AppButtonSize.large => 20,
    };
  }

  bool get _isInteractive => isEnabled && !isLoading;

  Widget _buildContent(BuildContext context) {
    final foregroundColor = switch (variant) {
      AppButtonVariant.primary => Colors.white,
      AppButtonVariant.secondary => Theme.of(
        context,
      ).colorScheme.onSecondaryContainer,
      AppButtonVariant.danger => Colors.white,
      AppButtonVariant.outlined ||
      AppButtonVariant.text => Theme.of(context).colorScheme.primary,
    };

    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: _iconSize,
            height: _iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: foregroundColor,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(label),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: _iconSize),
          const SizedBox(width: AppSpacing.xs),
        ],
        Flexible(
          child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: AppSpacing.xs),
          Icon(trailingIcon, size: _iconSize),
        ],
      ],
    );
  }

  ButtonStyle _buttonStyle() {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        borderRadius ?? AppSpacing.radiusMedium,
      ),
    );

    final size = WidgetStatePropertyAll(Size(0, _height));

    final padding = WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: _horizontalPadding),
    );

    return switch (variant) {
      AppButtonVariant.primary => FilledButton.styleFrom(
        minimumSize: size.value,
        padding: padding.value,
        shape: shape,
      ),
      AppButtonVariant.secondary => FilledButton.styleFrom(
        minimumSize: size.value,
        padding: padding.value,
        shape: shape,
      ),
      AppButtonVariant.outlined => OutlinedButton.styleFrom(
        minimumSize: size.value,
        padding: padding.value,
        shape: shape,
      ),
      AppButtonVariant.text => TextButton.styleFrom(
        minimumSize: size.value,
        padding: padding.value,
        shape: shape,
      ),
      AppButtonVariant.danger => FilledButton.styleFrom(
        minimumSize: size.value,
        padding: padding.value,
        shape: shape,
        backgroundColor: AppColors.negative,
        foregroundColor: Colors.white,
      ),
    };
  }

  Widget _buildButton(BuildContext context) {
    final content = _buildContent(context);
    final style = _buttonStyle();

    return switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: _isInteractive ? onPressed : null,
        style: style,
        child: content,
      ),
      AppButtonVariant.secondary => FilledButton.tonal(
        onPressed: _isInteractive ? onPressed : null,
        style: style,
        child: content,
      ),
      AppButtonVariant.outlined => OutlinedButton(
        onPressed: _isInteractive ? onPressed : null,
        style: style,
        child: content,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: _isInteractive ? onPressed : null,
        style: style,
        child: content,
      ),
      AppButtonVariant.danger => FilledButton(
        onPressed: _isInteractive ? onPressed : null,
        style: style,
        child: content,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final button = _buildButton(context);

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
