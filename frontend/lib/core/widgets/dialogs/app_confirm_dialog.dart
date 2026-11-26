import 'package:material_ui/material_ui.dart';

import '../buttons/app_button.dart';
import '../../platform/app_icons.dart';

class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    required this.title,
    required this.message,
    required this.onConfirm,
    super.key,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.isDestructive = false,
    this.icon,
    this.onCancel,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDestructive;
  final IconData? icon;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
    IconData? icon,
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        return AppConfirmDialog(
          title: title,
          message: message,
          confirmLabel: confirmLabel,
          cancelLabel: cancelLabel,
          isDestructive: isDestructive,
          icon: icon,
          onCancel: () {
            Navigator.of(dialogContext).pop(false);
          },
          onConfirm: () {
            Navigator.of(dialogContext).pop(true);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      icon: icon == null
          ? null
          : Icon(
              icon,
              size: 30,
              color: isDestructive ? colorScheme.error : colorScheme.primary,
            ),
      title: Text(title),
      content: Text(message, style: theme.textTheme.bodyMedium),
      actions: [
        TextButton(
          onPressed: () {
            onCancel?.call();
            if (onCancel == null) {
              Navigator.of(context).pop(false);
            }
          },
          child: Text(cancelLabel),
        ),
        AppButton(
          label: confirmLabel,
          variant: isDestructive
              ? AppButtonVariant.danger
              : AppButtonVariant.primary,
          onPressed: onConfirm,
          isFullWidth: false,
          size: AppButtonSize.small,
        ),
      ],
    );
  }
}
