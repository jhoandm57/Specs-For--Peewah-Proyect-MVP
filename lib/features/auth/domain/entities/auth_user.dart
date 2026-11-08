import 'package:equatable/equatable.dart';

/// Rol del usuario en la organización según la spec F-01 y modelo.md.
enum UserRole {
  administrador,
  colaborador,
}

/// Entidad pura de negocio para el usuario autenticado.
class AuthUser extends Equatable {
  final String id;
  final String email;
  final String name;
  final String organizationId;
  final String organizationName;
  final UserRole role;

  const AuthUser({
    required this.id,
    required this.email,
    required this.name,
    required this.organizationId,
    required this.organizationName,
    required this.role,
  });

  bool get isAdmin => role == UserRole.administrador;
  bool get isCollaborator => role == UserRole.colaborador;

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        organizationId,
        organizationName,
        role,
      ];
}
