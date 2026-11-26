enum AppThemeMode { system, light, dark }

extension AppThemeModeExtension on AppThemeMode {
  String get storageValue => name;

  static AppThemeMode fromStorage(String? value) {
    return AppThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => AppThemeMode.system,
    );
  }
}
