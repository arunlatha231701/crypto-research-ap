import 'package:material_ui/material_ui.dart';

import '../../../app/theme/app_spacing.dart';

enum AppLoaderSize { small, medium, large }

class AppLoader extends StatelessWidget {
  const AppLoader({
    this.message,
    this.size = AppLoaderSize.medium,
    this.color,
    this.strokeWidth = 3,
    this.centered = true,
    super.key,
  });

  final String? message;
  final AppLoaderSize size;
  final Color? color;
  final double strokeWidth;
  final bool centered;

  double get _indicatorSize => switch (size) {
    AppLoaderSize.small => 20,
    AppLoaderSize.medium => 32,
    AppLoaderSize.large => 44,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: _indicatorSize,
          height: _indicatorSize,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            color: color ?? theme.colorScheme.primary,
            semanticsLabel: message ?? 'Loading',
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            message!,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );

    if (centered) {
      return Center(child: content);
    }

    return content;
  }
}
