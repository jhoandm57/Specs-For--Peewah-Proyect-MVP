import 'package:flutter/material.dart';

import '../components/confirm_dialog.dart';
import '../models/auth_user.dart';
import '../models/event.dart';
import '../pages/event_detail_page.dart';
import 'new_event_screen.dart';

/// Screen anfitriona del detalle de un evento (F-07).
/// Mantiene el evento en su estado interno, permite editarlo y eliminarlo
/// con reflejo inmediato en el detalle y en la lista de eventos.
class EventDetailScreen extends StatefulWidget {
  final Event event;
  final AuthUser user;
  final ValueChanged<Event>? onEventUpdated;
  final ValueChanged<String>? onEventDeleted;

  const EventDetailScreen({
    super.key,
    required this.event,
    required this.user,
    this.onEventUpdated,
    this.onEventDeleted,
  });

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late Event _currentEvent;

  @override
  void initState() {
    super.initState();
    _currentEvent = widget.event;
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await ConfirmDialog.show(
      context: context,
      title: '¿Cerrar sesión?',
      message:
          'Al salir, nadie más podrá ver los datos de tu organización desde este dispositivo.',
      confirmLabel: 'Cerrar sesión',
      cancelLabel: 'Cancelar',
      confirmKey: const Key('confirm_logout_button'),
    );

    if (shouldLogout == true && mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  void _useAsBase() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NewEventScreen(user: widget.user, baseEvent: _currentEvent),
      ),
    );
  }

  Future<void> _openEdit() async {
    final updated = await Navigator.of(context).push<Event>(
      MaterialPageRoute(
        builder: (_) => NewEventScreen(
          user: widget.user,
          eventToEdit: _currentEvent,
        ),
      ),
    );

    if (updated != null && mounted) {
      setState(() {
        _currentEvent = updated;
      });
      widget.onEventUpdated?.call(updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Evento actualizado'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: '¿Eliminar este evento?',
      message:
          '¿Estás seguro de que deseas eliminar "${_currentEvent.name}"? Esta acción no se puede deshacer y el evento desaparecerá de la lista.',
      confirmLabel: 'Eliminar',
      cancelLabel: 'Cancelar',
      isDestructive: true,
      confirmKey: const Key('confirm_delete_event_button'),
      cancelKey: const Key('cancel_delete_event_button'),
    );

    if (confirmed == true && mounted) {
      widget.onEventDeleted?.call(_currentEvent.id);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Evento eliminado'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasAccess = _currentEvent.organizationId == widget.user.organizationId;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Detalle del evento'),
            Text(
              _currentEvent.category.label,
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
            onPressed: _confirmLogout,
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout_rounded, size: 20),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: hasAccess
          ? EventDetailPage(
              event: _currentEvent,
              user: widget.user,
              onUseAsBase: _useAsBase,
              onEdit: _openEdit,
              onDelete: _confirmDelete,
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
