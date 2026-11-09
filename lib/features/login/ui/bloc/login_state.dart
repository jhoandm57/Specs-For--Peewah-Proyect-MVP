import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/auth_user.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial: formulario listo para escribir.
class LoginInitial extends LoginState {
  const LoginInitial();
}

/// Estado cargando: "Iniciando sesión…" mientras se validan las credenciales.
class LoginLoading extends LoginState {
  const LoginLoading();
}

/// Estado éxito: credenciales validadas, contiene el usuario autenticado.
class LoginSuccess extends LoginState {
  final AuthUser user;

  const LoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

/// Estado de error: fallo de validación o conexión.
class LoginFailure extends LoginState {
  final String errorMessage;

  const LoginFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
