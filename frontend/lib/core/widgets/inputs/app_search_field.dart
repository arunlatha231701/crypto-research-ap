import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/platform/app_icons.dart';
import '../buttons/app_icon_button.dart';
import 'app_text_field.dart';

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    required this.controller,
    this.hint = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.enabled = true,
    this.focusNode,
    this.borderRadius,
    this.showClearButton = true,
    super.key,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;
  final bool enabled;
  final FocusNode? focusNode;
  final double? borderRadius;
  final bool showClearButton;

  void _clearSearch() {
    controller.clear();
    onChanged?.call('');
    onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final showClear = showClearButton && value.text.isNotEmpty && enabled;

        return AppTextField(
          controller: controller,
          hint: hint,
          autofocus: autofocus,
          enabled: enabled,
          focusNode: focusNode,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          textCapitalization: TextCapitalization.none,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          borderRadius: borderRadius ?? AppSpacing.radiusLarge,
          prefixIcon: AppIcons.searchRounded,
          suffixIcon: showClear
              ? Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: AppIconButton(
                    icon: AppIcons.closeRounded,
                    size: AppIconButtonSize.small,
                    tooltip: 'Clear search',
                    onPressed: _clearSearch,
                  ),
                )
              : null,
        );
      },
    );
  }
}
