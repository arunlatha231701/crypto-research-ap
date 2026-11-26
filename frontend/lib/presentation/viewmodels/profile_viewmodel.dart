
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/domain/entity/auth_user_entity.dart';
import 'package:frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:frontend/presentation/viewmodels/profile_state.dart';
import 'package:frontend/providers/providers.dart';

class ProfileViewModel extends Notifier<ProfileState> {
  @override
  ProfileState build() => const ProfileState();

  Future<bool> changeUsername({required String username}) async {
    final normalizedUsername = username.trim();

    if (normalizedUsername.isEmpty) {
      _setError('Username cannot be empty.');
      return false;
    }

    final authState = ref.read(authViewModelProvider);
    final currentUser = authState.user;

    if (currentUser == null) {
      _setError('Please log in again.');
      return false;
    }

    if (normalizedUsername == currentUser.username) {
      _setError('This is already your username.');
      return false;
    }

    state = state.copyWith(
      isChangingUsername: true,
      clearError: true,
      clearSuccess: true,
    );

    try {
      final userData = await ref
          .read(profileRemoteDataSourceProvider)
          .changeUsername(normalizedUsername);

      final updatedUser = AuthUser(
        id: (userData['id'] as num).toInt(),
        username: userData['username'] as String,
        email: userData['email'] as String,
      );

      ref.read(authViewModelProvider.notifier).updateUser(updatedUser);

      state = state.copyWith(
        isChangingUsername: false,
        successMessage: 'Username updated successfully.',
      );

      return true;
    } catch (error) {
      state = state.copyWith(
        isChangingUsername: false,
        errorMessage: _readableError(error),
      );

      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      _setError('Please complete all password fields.');
      return false;
    }

    if (newPassword.length < 8) {
      _setError('New password must contain at least 8 characters.');
      return false;
    }

    if (newPassword != confirmPassword) {
      _setError('New passwords do not match.');
      return false;
    }

    state = state.copyWith(
      isChangingPassword: true,
      clearError: true,
      clearSuccess: true,
    );

    try {
      await ref.read(profileRemoteDataSourceProvider).changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      state = state.copyWith(
        isChangingPassword: false,
        successMessage: 'Password changed successfully.',
      );

      return true;
    } catch (error) {
      state = state.copyWith(
        isChangingPassword: false,
        errorMessage: _readableError(error),
      );

      return false;
    }
  }

  void clearMessages() {
    state = state.copyWith(
      clearError: true,
      clearSuccess: true,
    );
  }

  void _setError(String message) {
    state = state.copyWith(
      errorMessage: message,
      clearSuccess: true,
    );
  }

  String _readableError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}
