import 'package:material_ui/material_ui.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/platform/app_icons.dart';

class AppDropdownItem<T> {
  const AppDropdownItem({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  final T value;
  final String label;
  final bool enabled;
}

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    required this.options,
    required this.onChanged,
    this.value,
    this.label,
    this.hint = 'Select an option',
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.validator,
    this.autovalidateMode,
    this.isRequired = false,
    this.enabled = true,
    this.menuMaxHeight = 320,
    this.borderRadius,
    super.key,
  });

  final List<AppDropdownItem<T>> options;
  final ValueChanged<T?>? onChanged;

  final T? value;
  final String? label;
  final String hint;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;

  final FormFieldValidator<T>? validator;
  final AutovalidateMode? autovalidateMode;

  final bool isRequired;
  final bool enabled;
  final double menuMaxHeight;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final radius = BorderRadius.circular(
      borderRadius ?? AppSpacing.radiusMedium,
    );

    final border = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: colorScheme.outlineVariant),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Row(
            children: [
              Text(label!, style: theme.textTheme.labelLarge),
              if (isRequired) ...[
                const SizedBox(width: 3),
                Text(
                  '*',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        DropdownButtonFormField<T>(
          initialValue: value,
          isExpanded: true,
          menuMaxHeight: menuMaxHeight,
          borderRadius: radius,
          icon: Icon(
            AppIcons.keyboardArrowDownRounded,
            color: colorScheme.onSurfaceVariant,
          ),
          items: options.map((option) {
            return DropdownMenuItem<T>(
              value: option.value,
              enabled: option.enabled,
              child: Text(
                option.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: enabled ? onChanged : null,
          validator: validator,
          autovalidateMode: autovalidateMode,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            helperText: helperText,
            errorText: errorText,
            prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
            filled: true,
            fillColor: colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            border: border,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
            ),
            errorBorder: border.copyWith(
              borderSide: BorderSide(color: colorScheme.error),
            ),
            focusedErrorBorder: border.copyWith(
              borderSide: BorderSide(color: colorScheme.error, width: 1.5),
            ),
            disabledBorder: border,
          ),
        ),
      ],
    );
  }
}
