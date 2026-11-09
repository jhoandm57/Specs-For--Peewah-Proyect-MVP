import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/source/auth_data_source.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

/// BloC responsable del flujo de inicio de sesión (F-01).
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SignInUseCase _signInUseCase;

  LoginBloc(this._signInUseCase) : super(const LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginReset>(_onLoginReset);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    // Estado cargando: "Iniciando sesión…"
    emit(const LoginLoading());

    try {
      final user = await _signInUseCase(
        email: event.email,
        password: event.password,
      );
      emit(LoginSuccess(user));
    } on InvalidCredentialsException {
      // CA-2: Correo o contraseña incorrectos
      emit(const LoginFailure('Correo o contraseña incorrectos'));
    } on NetworkException {
      // CA-5: Sin conexión
      emit(const LoginFailure('No se pudo conectar. Revisa tu conexión'));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  void _onLoginReset(LoginReset event, Emitter<LoginState> emit) {
    emit(const LoginInitial());
  }
}
