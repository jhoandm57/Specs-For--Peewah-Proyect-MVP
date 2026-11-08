import '../entities/auth_user.dart';

/// Contrato de repositorio de autenticación (Clean Architecture - Capa de Dominio).
/// Define las operaciones del sistema desacopladas de cualquier SDK o backend externo.
abstract class AuthRepository {
  /// Inicia sesión con correo y contraseña.
  Future<AuthUser> signIn({
    required String email,
    required String password,
  });

  /// Cierra la sesión activa en el dispositivo.
  Future<void> signOut();

  /// Retorna el usuario con sesión activa si existe, o null.
  Future<AuthUser?> getCurrentUser();
}
