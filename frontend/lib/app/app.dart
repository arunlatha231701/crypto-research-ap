import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'routes/app_router.dart';
import 'theme/app_theme.dart';
import '../presentation/viewmodels/theme/theme_state.dart';
import '../providers/theme_provider.dart';

class CryptoResearchApp extends ConsumerWidget {
  const CryptoResearchApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    final selectedTheme = themeState.value ?? AppThemeMode.system;

    final themeMode = switch (selectedTheme) {
      AppThemeMode.system => ThemeMode.system,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.light => ThemeMode.light,
    };

    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Crypto Research',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      localizationsDelegates: GlobalMaterialLocalizations.delegates,

      supportedLocales: const [Locale('en', 'US')],

      routerConfig: router,
    );
  }
}
