
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local database.
  await Hive.initFlutter();

  await Hive.openBox<String>('portfolio_holdings');

  runApp(
    const ProviderScope(
      child: CryptoResearchApp(),
    ),
  );
}
