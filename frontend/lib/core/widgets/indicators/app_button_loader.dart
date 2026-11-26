import 'package:material_ui/material_ui.dart';

class AppButtonLoader extends StatelessWidget {
  const AppButtonLoader({
    super.key,
    this.size = 18,
    this.color,
    this.strokeWidth = 2,
    this.message,
  });

  final double size;
  final Color? color;
  final double strokeWidth;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.onPrimary;

    return Semantics(
      label: message ?? 'Loading',
      liveRegion: true,
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          color: effectiveColor,
        ),
      ),
    );
  }
}
