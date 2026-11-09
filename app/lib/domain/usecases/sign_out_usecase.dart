import '../repository/auth_repository.dart';

/// Caso de uso: Cerrar sesión (F-01).
class SignOutUseCase {
  final AuthRepository _repository;

  const SignOutUseCase(this._repository);

  Future<void> call() {
    return _repository.signOut();
  }
}
