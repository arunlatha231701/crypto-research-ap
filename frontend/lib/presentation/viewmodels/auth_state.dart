
import 'package:frontend/domain/entity/auth_user_entity.dart';

class AuthState {
  const AuthState({
    this.isLoading = false,
    this.isInitializing = true,
    this.user,
    this.errorMessage,
  });

  final bool isLoading;
  final bool isInitializing;
  final AuthUser? user;
  final String? errorMessage;

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    bool? isLoading,
    bool? isInitializing,
    AuthUser? user,
    String? errorMessage,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isInitializing: isInitializing ?? this.isInitializing,
      user: clearUser ? null : user ?? this.user,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
