import 'package:flutter_test/flutter_test.dart';
import 'package:app/data/repository/auth_repository_impl.dart';
import 'package:app/data/source/auth_data_source.dart';
import 'package:app/data/source/simulated_auth_data_source.dart';
import 'package:app/models/auth_user.dart';
import 'package:app/domain/usecases/get_current_user_usecase.dart';
import 'package:app/domain/usecases/sign_in_usecase.dart';
import 'package:app/domain/usecases/sign_out_usecase.dart';

void main() {
  late SimulatedAuthDataSource dataSource;
  late AuthRepositoryImpl repository;
  late SignInUseCase signInUseCase;
  late SignOutUseCase signOutUseCase;
  late GetCurrentUserUseCase getCurrentUserUseCase;

  setUp(() {
    dataSource = SimulatedAuthDataSource(delayMs: 0);
    repository = AuthRepositoryImpl(dataSource);
    signInUseCase = SignInUseCase(repository);
    signOutUseCase = SignOutUseCase(repository);
    getCurrentUserUseCase = GetCurrentUserUseCase(repository);
  });

  group('SimulatedAuthDataSource & UseCases', () {
    test(
      'CA-1: Inicio de sesión exitoso con cuenta de administrador',
      () async {
        final user = await signInUseCase(
          email: 'admin@peewah.co',
          password: 'admin123',
        );

        expect(user.email, 'admin@peewah.co');
        expect(user.isAdmin, isTrue);
        expect(user.role, UserRole.administrador);
        expect(user.organizationName, 'Tech Events Corp');

        final currentUser = await getCurrentUserUseCase();
        expect(currentUser, equals(user));
      },
    );

    test('CA-4: Inicio de sesión exitoso con cuenta de colaborador', () async {
      final user = await signInUseCase(
        email: 'colab@peewah.co',
        password: 'colab123',
      );

      expect(user.email, 'colab@peewah.co');
      expect(user.isCollaborator, isTrue);
      expect(user.role, UserRole.colaborador);
      expect(user.organizationName, 'Tech Events Corp');
    });

    test(
      'CA-2: Credenciales incorrectas lanzan InvalidCredentialsException',
      () async {
        expect(
          () => signInUseCase(
            email: 'admin@peewah.co',
            password: 'contrasena_erronea',
          ),
          throwsA(isA<InvalidCredentialsException>()),
        );
      },
    );

    test('CA-5: Simulación de error de red lanza NetworkException', () async {
      dataSource.simulateNetworkError = true;

      expect(
        () => signInUseCase(email: 'admin@peewah.co', password: 'admin123'),
        throwsA(isA<NetworkException>()),
      );
    });

    test('CA-3: Cerrar sesión limpia el usuario actual', () async {
      await signInUseCase(email: 'admin@peewah.co', password: 'admin123');
      expect(await getCurrentUserUseCase(), isNotNull);

      await signOutUseCase();
      expect(await getCurrentUserUseCase(), isNull);
    });
  });
}
