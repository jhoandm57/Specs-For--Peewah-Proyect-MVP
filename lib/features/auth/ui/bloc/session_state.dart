import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_user.dart';

abstract class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial mientras se verifica si hay sesión previa.
class SessionInitial extends SessionState {
  const SessionInitial();
}

/// Usuario sin sesión autenticada (muestra LoginScreen).
class Unauthenticated extends SessionState {
  const Unauthenticated();
}

/// Usuario con sesión activa (muestra EventsScreen con datos del usuario).
class Authenticated extends SessionState {
  final AuthUser user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}
