import 'package:material_ui/material_ui.dart';

import '../../../app/theme/app_spacing.dart';

abstract final class AppBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = false,
    EdgeInsetsGeometry? padding,
    double? maxHeight,
  }) {
    final theme = Theme.of(context);

    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      useSafeArea: true,
      backgroundColor: theme.colorScheme.surface,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusExtraLarge),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (sheetContext) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight:
                maxHeight ?? MediaQuery.sizeOf(sheetContext).height * 0.85,
          ),
          child: Padding(
            padding:
                padding ??
                const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.md,
                  AppSpacing.xl,
                  AppSpacing.xl,
                ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.35,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                if (title != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(title, style: theme.textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.md),
                ] else
                  const SizedBox(height: AppSpacing.md),
                Flexible(child: child),
              ],
            ),
          ),
        );
      },
    );
  }
}
