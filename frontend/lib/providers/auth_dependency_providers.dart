import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/data/data%20sources/auth_remote_data_source.dart';
import 'package:frontend/data/data%20sources/profile_remote_data_source.dart';
import 'package:frontend/data/repository_impl/auth_repository_impl.dart';
import 'package:frontend/domain/repository/auth_repository.dart';
import 'package:frontend/domain/usecase/auth/login_usecase.dart';
import 'package:frontend/domain/usecase/auth/restore_session_usecase.dart';

import 'api_service_provider.dart';
import 'storage_providers.dart';

final authRemoteDataSourceProvider =
Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(
    ref.watch(apiServiceProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(tokenStorageProvider),
  );
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(
    ref.watch(authRepositoryProvider),
  );
});

final profileRemoteDataSourceProvider =
Provider<ProfileRemoteDataSource>((ref) {
  return ProfileRemoteDataSource(
    ref.watch(apiServiceProvider),
  );
});

final restoreSessionUseCaseProvider =
Provider<RestoreSessionUseCase>((ref) {
  return RestoreSessionUseCase(
    ref.watch(authRepositoryProvider),
  );
});