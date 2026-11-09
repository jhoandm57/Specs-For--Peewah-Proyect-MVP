import '../../models/auth_user.dart';

/// Excepción base para errores de autenticación.
abstract class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

/// CA-2: "Correo o contraseña incorrectos"
class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException([
    super.message = 'Correo o contraseña incorrectos',
  ]);
}

/// CA-5: "No se pudo conectar. Revisa tu conexión"
class NetworkException extends AuthException {
  const NetworkException([
    super.message = 'No se pudo conectar. Revisa tu conexión',
  ]);
}

/// Interfaz para la fuente de datos de autenticación.
/// Puede ser implementada por [SimulatedAuthDataSource] o a futuro por [SupabaseAuthDataSource].
abstract class AuthDataSource {
  Future<AuthUser> signIn({required String email, required String password});

  Future<void> signOut();

  Future<AuthUser?> getCurrentUser();
}
