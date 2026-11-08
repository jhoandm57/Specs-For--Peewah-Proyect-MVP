import 'package:flutter/material.dart';

import '../../../auth/domain/entities/auth_user.dart';
import '../../data/mock_events.dart';
import '../../domain/entities/event.dart';
import '../pages/events_page.dart';
import 'event_detail_screen.dart';
import 'new_event_screen.dart';

/// Screen anfitriona del listado de eventos (F-02).
/// Mantiene el filtro activo y coordina la navegación con datos simulados.
class EventsScreen extends StatefulWidget {
  final AuthUser user;

  const EventsScreen({super.key, required this.user});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  EventCategory? _selectedCategory;

  List<Event> get _visibleEvents {
    final events = mockEvents
        .where(
          (event) =>
              event.organizationId == widget.user.organizationId &&
              (_selectedCategory == null ||
                  event.category == _selectedCategory),
        )
        .toList();
    events.sort((a, b) => b.date.compareTo(a.date));
    return events;
  }

  void _openDetail(Event event) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EventDetailScreen(event: event, user: widget.user),
      ),
    );
  }

  void _openNewEvent({Event? baseEvent}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NewEventScreen(
          user: widget.user,
          baseEvent: baseEvent,
        ),
      ),
    );
  }

  Future<void> _confirmLogout() async {
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

    if (shouldLogout == true && mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Eventos'),
            Text(
              widget.user.organizationName,
              style: const TextStyle(
                color: Color(0xFF737373),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: EventsPage(
        user: widget.user,
        events: _visibleEvents,
        selectedCategory: _selectedCategory,
        onCategoryChanged: (category) {
          setState(() => _selectedCategory = category);
        },
        onEventTap: _openDetail,
        onUseAsBase: (event) => _openNewEvent(baseEvent: event),
        onNewEvent: _openNewEvent,
        onLogout: _confirmLogout,
      ),
      floatingActionButton: widget.user.isAdmin
          ? FloatingActionButton.extended(
              key: const Key('new_event_button'),
              onPressed: _openNewEvent,
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'Nuevo evento',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            )
          : null,
    );
  }
}
