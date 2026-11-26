import 'package:material_ui/material_ui.dart';

import '../../../app/theme/app_colors.dart';
import '../../platform/app_icons.dart';

class AppChangeIndicator extends StatelessWidget {
  const AppChangeIndicator({
    required this.changePercent,
    super.key,
    this.showIcon = true,
    this.showSign = true,
    this.isCompact = false,
    this.decimalPlaces = 2,
    this.fontSize,
  }) : assert(decimalPlaces >= 0 && decimalPlaces <= 6);

  final double changePercent;
  final bool showIcon;
  final bool showSign;
  final bool isCompact;
  final int decimalPlaces;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final isPositive = changePercent > 0;
    final isNegative = changePercent < 0;
    final isNeutral = !isPositive && !isNegative;

    final color = isPositive
        ? AppColors.positive
        : isNegative
        ? AppColors.negative
        : Theme.of(context).colorScheme.onSurfaceVariant;

    final icon = isPositive
        ? AppIcons.trendingUpRounded
        : isNegative
        ? AppIcons.trendingDownRounded
        : AppIcons.removeRounded;

    final formattedValue = changePercent.abs().toStringAsFixed(decimalPlaces);

    final sign = showSign
        ? isPositive
              ? '+'
              : isNegative
              ? '-'
              : ''
        : '';

    final text = '$sign$formattedValue%';

    return Semantics(
      label: isPositive
          ? 'Positive change of $text'
          : isNegative
          ? 'Negative change of $text'
          : 'No change, $text',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Icon(icon, size: isCompact ? 13 : 16, color: color),
              const SizedBox(width: 3),
            ],
            Text(
              text,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontSize: fontSize ?? (isCompact ? 11 : 13),
                fontWeight: FontWeight.w600,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
