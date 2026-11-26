import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/presentation/viewmodels/theme/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeViewModel extends AsyncNotifier<AppThemeMode> {
  static const String _themeKey = 'app_theme_mode';

  @override
  Future<AppThemeMode> build() async {
    final preferences = await SharedPreferences.getInstance();

    final savedTheme = preferences.getString(_themeKey);

    return AppThemeModeExtension.fromStorage(savedTheme);
  }

  Future<void> changeTheme(AppThemeMode themeMode) async {
    final previousState = state;

    state = AsyncData(themeMode);

    try {
      final preferences = await SharedPreferences.getInstance();

      await preferences.setString(_themeKey, themeMode.storageValue);
    } catch (error, stackTrace) {
      state = previousState;

      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  ThemeMode get materialThemeMode {
    final selectedTheme = state.value ?? AppThemeMode.system;

    return switch (selectedTheme) {
      AppThemeMode.system => ThemeMode.system,
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
    };
  }
}
