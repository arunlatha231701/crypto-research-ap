

import 'package:frontend/domain/entity/auth_user_entity.dart';

class AuthSessionModel {
  const AuthSessionModel({
    required this.token,
    required this.user,
  });

  final String token;
  final AuthUser user;

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];

    if (userJson is! Map) {
      throw const FormatException('Invalid user information.');
    }

    final userData = Map<String, dynamic>.from(userJson);

    return AuthSessionModel(
      token: json['token'] as String,
      user: AuthUser(
        id: (userData['id'] as num).toInt(),
        username: userData['username'] as String,
        email: userData['email'] as String,
      ),
    );
  }
}
