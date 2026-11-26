
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/storage/token_storage.dart';
import 'package:frontend/data/data%20sources/auth_remote_data_source.dart';
import 'package:frontend/domain/entity/auth_user_entity.dart';
import 'package:frontend/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
      this._remoteDataSource,
      this._tokenStorage,
      );

  final AuthRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;

  @override
  Future<AuthUser> login({
    required String username,
    required String password,
  }) async {
    final session = await _remoteDataSource.login(
      username: username,
      password: password,
    );

    await _tokenStorage.saveToken(session.token);

    return session.user;
  }
  @override
  Future<AuthUser?> restoreSession() async {
    final hasToken = await _tokenStorage.hasToken();

    if (!hasToken) {
      return null;
    }

    try {
      return await _remoteDataSource.getProfile();
    } on ApiException catch (error) {
      if (error.type == ApiErrorType.unauthorized) {
        await _tokenStorage.deleteToken();
      }

      rethrow;
    }
  }
}
