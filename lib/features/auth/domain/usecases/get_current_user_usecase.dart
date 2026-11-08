import '../entities/auth_user.dart';
import '../repository/auth_repository.dart';

/// Caso de uso: Consultar usuario en sesión (A3 · Sesión guardada).
class GetCurrentUserUseCase {
  final AuthRepository _repository;

  const GetCurrentUserUseCase(this._repository);

  Future<AuthUser?> call() {
    return _repository.getCurrentUser();
  }
}
