
class ProfileState {
  const ProfileState({
    this.isChangingUsername = false,
    this.isChangingPassword = false,
    this.errorMessage,
    this.successMessage,
  });

  final bool isChangingUsername;
  final bool isChangingPassword;
  final String? errorMessage;
  final String? successMessage;

  ProfileState copyWith({
    bool? isChangingUsername,
    bool? isChangingPassword,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return ProfileState(
      isChangingUsername:
      isChangingUsername ?? this.isChangingUsername,
      isChangingPassword:
      isChangingPassword ?? this.isChangingPassword,
      errorMessage:
      clearError ? null : errorMessage ?? this.errorMessage,
      successMessage:
      clearSuccess ? null : successMessage ?? this.successMessage,
    );
  }
}
