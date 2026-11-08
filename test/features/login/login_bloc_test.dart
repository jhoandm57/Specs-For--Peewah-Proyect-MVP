import 'package:flutter_test/flutter_test.dart';
import 'package:peewah_event_recommender/features/auth/data/repository/auth_repository_impl.dart';
import 'package:peewah_event_recommender/features/auth/data/source/simulated_auth_data_source.dart';
import 'package:peewah_event_recommender/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:peewah_event_recommender/features/login/ui/bloc/login_bloc.dart';
import 'package:peewah_event_recommender/features/login/ui/bloc/login_event.dart';
import 'package:peewah_event_recommender/features/login/ui/bloc/login_state.dart';

void main() {
  late SimulatedAuthDataSource dataSource;
  late AuthRepositoryImpl repository;
  late SignInUseCase signInUseCase;
  late LoginBloc loginBloc;

  setUp(() {
    dataSource = SimulatedAuthDataSource(delayMs: 0);
    repository = AuthRepositoryImpl(dataSource);
    signInUseCase = SignInUseCase(repository);
    loginBloc = LoginBloc(signInUseCase);
  });

  tearDown(() {
    loginBloc.close();
  });

  group('LoginBloc', () {
    test('Estado inicial es LoginInitial', () {
      expect(loginBloc.state, equals(const LoginInitial()));
    });

    test('Emite [LoginLoading, LoginSuccess] con credenciales válidas (CA-1)', () async {
      expectLater(
        loginBloc.stream,
        emitsInOrder([
          const LoginLoading(),
          isA<LoginSuccess>().having(
            (s) => s.user.email,
            'email',
            'admin@peewah.co',
          ),
        ]),
      );

      loginBloc.add(
        const LoginSubmitted(
          email: 'admin@peewah.co',
          password: 'admin123',
        ),
      );
    });

    test('Emite [LoginLoading, LoginFailure] cuando las credenciales no coinciden (CA-2)', () async {
      expectLater(
        loginBloc.stream,
        emitsInOrder([
          const LoginLoading(),
          const LoginFailure('Correo o contraseña incorrectos'),
        ]),
      );

      loginBloc.add(
        const LoginSubmitted(
          email: 'admin@peewah.co',
          password: 'password_invalida',
        ),
      );
    });

    test('Emite [LoginLoading, LoginFailure] cuando no hay conexión (CA-5)', () async {
      dataSource.simulateNetworkError = true;

      expectLater(
        loginBloc.stream,
        emitsInOrder([
          const LoginLoading(),
          const LoginFailure('No se pudo conectar. Revisa tu conexión'),
        ]),
      );

      loginBloc.add(
        const LoginSubmitted(
          email: 'admin@peewah.co',
          password: 'admin123',
        ),
      );
    });
  });
}
