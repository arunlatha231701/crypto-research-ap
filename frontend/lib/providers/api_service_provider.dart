import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/api_service.dart';
import 'network_providers.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiService(dio);
});
