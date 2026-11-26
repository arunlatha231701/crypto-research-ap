import 'package:frontend/presentation/viewmodels/theme/theme_state.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeSelector extends ConsumerWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    if (themeState.isLoading && !themeState.hasValue) {
      return const Center(child: CircularProgressIndicator());
    }

    if (themeState.hasError && !themeState.hasValue) {
      return TextButton(
        onPressed: () => ref.invalidate(themeProvider),
        child: const Text('Retry loading theme preferences'),
      );
    }

    final selectedTheme = themeState.value ?? AppThemeMode.system;

    return SegmentedButton<AppThemeMode>(
      segments: const [
        ButtonSegment(
          value: AppThemeMode.system,
          label: Text('System'),
          icon: Icon(Icons.settings_suggest_outlined),
        ),
        ButtonSegment(
          value: AppThemeMode.light,
          label: Text('Light'),
          icon: Icon(Icons.light_mode_outlined),
        ),
        ButtonSegment(
          value: AppThemeMode.dark,
          label: Text('Dark'),
          icon: Icon(Icons.dark_mode_outlined),
        ),
      ],
      selected: {selectedTheme},
      onSelectionChanged: (selection) {
        ref.read(themeProvider.notifier).changeTheme(selection.first);
      },
    );
  }
}
