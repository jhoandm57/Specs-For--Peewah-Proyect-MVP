import 'package:equatable/equatable.dart';

import '../../models/auth_user.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => [];
}

/// Evento disparado al arrancar la app para comprobar si hay sesión guardada (A3).
class SessionCheckRequested extends SessionEvent {
  const SessionCheckRequested();
}

/// Notifica que el usuario inició sesión exitosamente.
class SessionUserLoggedIn extends SessionEvent {
  final AuthUser user;
  const SessionUserLoggedIn(this.user);

  @override
  List<Object?> get props => [user];
}

/// Disparado cuando el usuario elige "Cerrar sesión" (A2 y CA-3).
class SessionLogoutRequested extends SessionEvent {
  const SessionLogoutRequested();
}
