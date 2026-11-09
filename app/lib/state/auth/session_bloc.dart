import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import 'session_event.dart';
import 'session_state.dart';

/// BloC responsable de la gestión global de la sesión en la app.
class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SignOutUseCase signOutUseCase;

  SessionBloc({
    required this.getCurrentUserUseCase,
    required this.signOutUseCase,
  }) : super(const SessionInitial()) {
    on<SessionCheckRequested>(_onCheckRequested);
    on<SessionUserLoggedIn>(_onUserLoggedIn);
    on<SessionLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckRequested(
    SessionCheckRequested event,
    Emitter<SessionState> emit,
  ) async {
    try {
      final user = await getCurrentUserUseCase();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const Unauthenticated());
      }
    } catch (_) {
      emit(const Unauthenticated());
    }
  }

  void _onUserLoggedIn(SessionUserLoggedIn event, Emitter<SessionState> emit) {
    emit(Authenticated(event.user));
  }

  Future<void> _onLogoutRequested(
    SessionLogoutRequested event,
    Emitter<SessionState> emit,
  ) async {
    try {
      await signOutUseCase();
    } finally {
      // CA-3: al cerrar sesión nadie más ve los datos desde este dispositivo
      emit(const Unauthenticated());
    }
  }
}
