
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/core/storage/token_storage.dart';
import 'package:frontend/domain/entity/auth_user_entity.dart';
import 'package:frontend/domain/usecase/auth/login_usecase.dart';
import 'package:frontend/domain/usecase/auth/restore_session_usecase.dart';
import 'package:frontend/presentation/viewmodels/auth_state.dart';
import 'package:frontend/providers/auth_dependency_providers.dart';
import 'package:frontend/providers/storage_providers.dart';

class AuthViewModel extends Notifier<AuthState> {
  late LoginUseCase _loginUseCase;
  late RestoreSessionUseCase _restoreSessionUseCase;
  late TokenStorage _tokenStorage;

  @override
  AuthState build() {
    _loginUseCase = ref.read(loginUseCaseProvider);
    _restoreSessionUseCase =
        ref.read(restoreSessionUseCaseProvider);
    _tokenStorage = ref.read(tokenStorageProvider);

    Future.microtask(restoreSession);

    return const AuthState(isInitializing: true);
  }

  Future<void> restoreSession() async {
    state = state.copyWith(
      isInitializing: true,
      clearError: true,
    );

    try {
      final user = await _restoreSessionUseCase();

      state = AuthState(
        user: user,
        isInitializing: false,
      );
    } catch (error) {
      state = AuthState(
        isInitializing: false,
        errorMessage: _readableError(error),
      );
    }
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    if (username.trim().isEmpty || password.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isInitializing: false,
        errorMessage: 'Please enter your username and password.',
      );
      return false;
    }

    state = state.copyWith(
      isLoading: true,
      isInitializing: false,
      clearError: true,
    );

    try {
      final user = await _loginUseCase(
        username: username.trim(),
        password: password.trim(),
      );

      state = AuthState(
        user: user,
        isInitializing: false,
      );

      return true;
    } catch (error) {
      state = AuthState(
        isInitializing: false,
        errorMessage: _readableError(error),
      );

      return false;
    }
  }

  Future<void> logout() async {
    await _tokenStorage.deleteToken();

    state = const AuthState(
      isInitializing: false,
    );
  }

  void updateUser(AuthUser user) {
    state = state.copyWith(
      user: user,
      isInitializing: false,
      clearError: true,
    );
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  String _readableError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}
