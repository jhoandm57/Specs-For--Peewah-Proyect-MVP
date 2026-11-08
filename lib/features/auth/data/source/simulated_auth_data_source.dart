import '../../domain/entities/auth_user.dart';
import 'auth_data_source.dart';

/// Implementación simulada de la fuente de datos de autenticación.
/// Cumple todos los requisitos de F-01 sin necesidad de backend externo activo.
class SimulatedAuthDataSource implements AuthDataSource {
  /// Tiempo de espera simulado para reflejar el estado de carga (en milisegundos).
  final int delayMs;

  /// Bandera para simular problemas de conectividad de red (CA-5).
  bool simulateNetworkError;

  /// Usuario actualmente autenticado en memoria en este dispositivo.
  AuthUser? _currentUser;

  SimulatedAuthDataSource({
    this.delayMs = 400,
    this.simulateNetworkError = false,
  });

  /// Base de datos de credenciales y cuentas de prueba para el MVP.
  static final Map<String, _MockAccount> _accounts = {
    'admin@peewah.co': _MockAccount(
      password: 'admin123',
      user: const AuthUser(
        id: 'usr-admin-01',
        email: 'admin@peewah.co',
        name: 'Sofía Gómez',
        organizationId: 'org-peewah-01',
        organizationName: 'Tech Events Corp',
        role: UserRole.administrador,
      ),
    ),
    'colab@peewah.co': _MockAccount(
      password: 'colab123',
      user: const AuthUser(
        id: 'usr-colab-02',
        email: 'colab@peewah.co',
        name: 'Carlos Pérez',
        organizationId: 'org-peewah-01',
        organizationName: 'Tech Events Corp',
        role: UserRole.colaborador,
      ),
    ),
  };

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    if (delayMs > 0) {
      await Future<void>.delayed(Duration(milliseconds: delayMs));
    }

    if (simulateNetworkError) {
      throw const NetworkException();
    }

    final normalizedEmail = email.trim().toLowerCase();
    final account = _accounts[normalizedEmail];

    // CA-2: Credenciales incorrectas
    if (account == null || account.password != password) {
      throw const InvalidCredentialsException();
    }

    // CA-1: Inicio de sesión exitoso
    _currentUser = account.user;
    return account.user;
  }

  @override
  Future<void> signOut() async {
    if (delayMs > 0) {
      await Future<void>.delayed(Duration(milliseconds: delayMs ~/ 2));
    }

    // CA-3: Cerrar sesión limpia la sesión
    _currentUser = null;
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    return _currentUser;
  }
}

class _MockAccount {
  final String password;
  final AuthUser user;

  const _MockAccount({
    required this.password,
    required this.user,
  });
}
