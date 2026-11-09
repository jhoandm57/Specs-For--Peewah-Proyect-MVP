import 'package:flutter/material.dart';

import '../models/auth_user.dart';
import '../models/event.dart';
import '../pages/event_detail_page.dart';
import 'new_event_screen.dart';

/// Screen anfitriona del detalle de un evento (F-07).
/// Coordina la navegación y expone la acción de reutilizar como base.
class EventDetailScreen extends StatelessWidget {
  final Event event;
  final AuthUser user;

  const EventDetailScreen({super.key, required this.event, required this.user});

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¿Cerrar sesión?'),
        content: const Text(
          'Al salir, nadie más podrá ver los datos de tu organización desde este dispositivo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            key: const Key('confirm_logout_button'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  void _useAsBase(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NewEventScreen(user: user, baseEvent: event),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasAccess = event.organizationId == user.organizationId;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Detalle del evento'),
            Text(
              event.category.label,
              style: const TextStyle(
                color: Color(0xFF737373),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            key: const Key('logout_button'),
            onPressed: () => _confirmLogout(context),
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout_rounded, size: 20),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: hasAccess
          ? EventDetailPage(
              event: event,
              user: user,
              onUseAsBase: () => _useAsBase(context),
            )
          : const _AccessDenied(),
    );
  }
}

class _AccessDenied extends StatelessWidget {
  const _AccessDenied();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline_rounded,
              size: 42,
              color: Color(0xFF737373),
            ),
            SizedBox(height: 12),
            Text(
              'No tienes acceso a este evento',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'El evento pertenece a otra organización.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF737373), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
