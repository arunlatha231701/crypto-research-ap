
import 'package:frontend/domain/entity/auth_user_entity.dart';

abstract interface class AuthRepository {
  Future<AuthUser> login({
    required String username,
    required String password,
  });

  Future<AuthUser?> restoreSession();
}
