import '../../models/auth_user.dart';
import '../repository/auth_repository.dart';

/// Caso de uso: Iniciar sesión (F-01).
class SignInUseCase {
  final AuthRepository _repository;

  const SignInUseCase(this._repository);

  Future<AuthUser> call({required String email, required String password}) {
    return _repository.signIn(email: email.trim(), password: password);
  }
}
