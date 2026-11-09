import '../../domain/entities/auth_user.dart';
import '../../domain/repository/auth_repository.dart';
import '../source/auth_data_source.dart';

/// Implementación del repositorio de autenticación (Capa de Datos).
/// Conecta el contrato de dominio con la fuente de datos correspondiente.
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;

  const AuthRepositoryImpl(this._dataSource);

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) {
    return _dataSource.signIn(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() {
    return _dataSource.signOut();
  }

  @override
  Future<AuthUser?> getCurrentUser() {
    return _dataSource.getCurrentUser();
  }
}
