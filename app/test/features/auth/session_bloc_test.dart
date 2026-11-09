import 'package:flutter_test/flutter_test.dart';
import 'package:app/data/repository/auth_repository_impl.dart';
import 'package:app/data/source/simulated_auth_data_source.dart';
import 'package:app/models/auth_user.dart';
import 'package:app/domain/usecases/get_current_user_usecase.dart';
import 'package:app/domain/usecases/sign_out_usecase.dart';
import 'package:app/state/auth/session_bloc.dart';
import 'package:app/state/auth/session_event.dart';
import 'package:app/state/auth/session_state.dart';

void main() {
  late SimulatedAuthDataSource dataSource;
  late AuthRepositoryImpl repository;
  late GetCurrentUserUseCase getCurrentUserUseCase;
  late SignOutUseCase signOutUseCase;
  late SessionBloc sessionBloc;

  setUp(() {
    dataSource = SimulatedAuthDataSource(delayMs: 0);
    repository = AuthRepositoryImpl(dataSource);
    getCurrentUserUseCase = GetCurrentUserUseCase(repository);
    signOutUseCase = SignOutUseCase(repository);
    sessionBloc = SessionBloc(
      getCurrentUserUseCase: getCurrentUserUseCase,
      signOutUseCase: signOutUseCase,
    );
  });

  tearDown(() {
    sessionBloc.close();
  });

  group('SessionBloc', () {
    test('Estado inicial es SessionInitial', () {
      expect(sessionBloc.state, equals(const SessionInitial()));
    });

    test(
      'SessionCheckRequested emite Unauthenticated cuando no hay usuario',
      () async {
        expectLater(
          sessionBloc.stream,
          emitsInOrder([const Unauthenticated()]),
        );

        sessionBloc.add(const SessionCheckRequested());
      },
    );

    test('SessionUserLoggedIn emite Authenticated con el usuario', () async {
      const user = AuthUser(
        id: 'usr-1',
        email: 'test@peewah.co',
        name: 'Test',
        organizationId: 'org-1',
        organizationName: 'Org 1',
        role: UserRole.administrador,
      );

      expectLater(
        sessionBloc.stream,
        emitsInOrder([const Authenticated(user)]),
      );

      sessionBloc.add(const SessionUserLoggedIn(user));
    });

    test(
      'SessionLogoutRequested emite Unauthenticated y limpia la sesión (CA-3)',
      () async {
        const user = AuthUser(
          id: 'usr-1',
          email: 'test@peewah.co',
          name: 'Test',
          organizationId: 'org-1',
          organizationName: 'Org 1',
          role: UserRole.administrador,
        );

        sessionBloc.add(const SessionUserLoggedIn(user));
        await Future<void>.delayed(Duration.zero);

        expectLater(
          sessionBloc.stream,
          emitsInOrder([const Unauthenticated()]),
        );

        sessionBloc.add(const SessionLogoutRequested());
      },
    );
  });
}
