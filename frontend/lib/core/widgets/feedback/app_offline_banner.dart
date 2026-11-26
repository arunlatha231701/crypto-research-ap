import 'package:material_ui/material_ui.dart';

import '../../../app/theme/app_spacing.dart';
import '../../platform/app_icons.dart';

class AppOfflineBanner extends StatelessWidget {
  const AppOfflineBanner({
    super.key,
    this.message = 'You are offline. Showing saved data.',
    this.onRetry,
    this.isVisible = true,
    this.retryLabel = 'Retry',
  });

  final String message;
  final VoidCallback? onRetry;
  final bool isVisible;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: isVisible
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              ),
              child: Row(
                children: [
                  Icon(
                    AppIcons.wifiOffRounded,
                    size: 20,
                    color: colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      message,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                  if (onRetry != null) ...[
                    const SizedBox(width: AppSpacing.xs),
                    TextButton(
                      onPressed: onRetry,
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.onErrorContainer,
                        minimumSize: const Size(48, 40),
                      ),
                      child: Text(retryLabel),
                    ),
                  ],
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
