
import 'package:frontend/domain/entity/auth_user_entity.dart';
import 'package:frontend/domain/repository/auth_repository.dart';

class RestoreSessionUseCase {
  const RestoreSessionUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthUser?> call() {
    return _repository.restoreSession();
  }
}
