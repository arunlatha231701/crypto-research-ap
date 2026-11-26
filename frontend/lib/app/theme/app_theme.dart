import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme => _buildTheme(brightness: Brightness.light);

  static ThemeData get darkTheme => _buildTheme(brightness: Brightness.dark);

  static ThemeData _buildTheme({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;

    final background = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;

    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    final secondaryTextColor = isDark
        ? AppColors.darkSecondaryText
        : AppColors.lightSecondaryText;

    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: surface,
      error: AppColors.negative,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: AppTypography.textTheme(brightness),
      fontFamily: AppTypography.fontFamily,

      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTypography.textTheme(brightness).titleLarge,
      ),

      dividerColor: borderColor,

      iconTheme: IconThemeData(color: secondaryTextColor),

      cardColor: surface,

      splashColor: AppColors.primary.withValues(alpha: 0.08),
      highlightColor: AppColors.primary.withValues(alpha: 0.04),

      visualDensity: VisualDensity.standard,
    );
  }
}
