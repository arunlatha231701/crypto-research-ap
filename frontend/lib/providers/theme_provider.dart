import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/presentation/viewmodels/theme/theme_state.dart';
import 'package:frontend/presentation/viewmodels/theme/theme_viewmodel.dart';

final themeProvider = AsyncNotifierProvider<ThemeViewModel, AppThemeMode>(
  ThemeViewModel.new,
);
