import 'package:material_ui/material_ui.dart';

import '../../../app/theme/app_spacing.dart';

class AppScreenContainer extends StatelessWidget {
  const AppScreenContainer({
    required this.child,
    super.key,
    this.padding,
    this.maxWidth = 1200,
    this.useSafeArea = true,
    this.alignment = Alignment.topCenter,
    this.backgroundColor,
    this.scrollable = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? maxWidth;
  final bool useSafeArea;
  final AlignmentGeometry alignment;
  final Color? backgroundColor;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final content = Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding:
                padding ??
                const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                  vertical: AppSpacing.md,
                ),
            child: child,
          ),
        ),
      ),
    );

    final screenContent = scrollable
        ? SingleChildScrollView(child: content)
        : content;

    return ColoredBox(
      color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: useSafeArea ? SafeArea(child: screenContent) : screenContent,
    );
  }
}
