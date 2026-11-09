import 'package:flutter/material.dart';

import '../components/confirm_dialog.dart';
import '../components/primary_button.dart';
import '../models/auth_user.dart';
import '../data/mock_events.dart';
import '../models/event.dart';
import '../pages/events_page.dart';
import 'event_detail_screen.dart';
import 'new_event_screen.dart';

/// Screen anfitriona del listado de eventos (F-02).
/// Guarda la lista de eventos en su estado interno, gestiona los filtros
/// y recibe los eventos nuevos con el callback onEventCreated.
class EventsScreen extends StatefulWidget {
  final AuthUser user;

  const EventsScreen({super.key, required this.user});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  EventCategory? _selectedCategory;
  late List<Event> _events;

  @override
  void initState() {
    super.initState();
    // Guarda la lista de eventos en el estado interno de la Screen
    _events = List<Event>.from(
      mockEvents.where((e) => e.organizationId == widget.user.organizationId),
    );
  }

  List<Event> get _visibleEvents {
    final events = _events
        .where(
          (event) =>
              _selectedCategory == null || event.category == _selectedCategory,
        )
        .toList();
    events.sort((a, b) => b.date.compareTo(a.date));
    return events;
  }

  void _onEventCreated(Event newEvent) {
    setState(() {
      _events.removeWhere((e) => e.id == newEvent.id);
      _events.insert(0, newEvent);

      // Sincroniza la persistencia en memoria durante la sesión
      mockEvents.removeWhere((e) => e.id == newEvent.id);
      mockEvents.insert(0, newEvent);
    });
  }

  void _onEventUpdated(Event updatedEvent) {
    setState(() {
      final index = _events.indexWhere((e) => e.id == updatedEvent.id);
      if (index != -1) {
        _events[index] = updatedEvent;
      } else {
        _events.insert(0, updatedEvent);
      }

      final mockIndex = mockEvents.indexWhere((e) => e.id == updatedEvent.id);
      if (mockIndex != -1) {
        mockEvents[mockIndex] = updatedEvent;
      } else {
        mockEvents.insert(0, updatedEvent);
      }
    });
  }

  void _onEventDeleted(String eventId) {
    setState(() {
      _events.removeWhere((e) => e.id == eventId);
      mockEvents.removeWhere((e) => e.id == eventId);
    });
  }

  void _openDetail(Event event) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EventDetailScreen(
          event: event,
          user: widget.user,
          onEventCreated: _onEventCreated,
          onEventUpdated: _onEventUpdated,
          onEventDeleted: _onEventDeleted,
        ),
      ),
    );
  }

  void _openNewEvent({Event? baseEvent}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NewEventScreen(
          user: widget.user,
          baseEvent: baseEvent,
          onEventCreated: _onEventCreated,
        ),
      ),
    );
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await ConfirmDialog.show(
      context: context,
      title: '¿Cerrar sesión?',
      message: 'Al salir, nadie más podrá ver los datos de tu organización desde este dispositivo.',
      confirmLabel: 'Cerrar sesión',
      cancelLabel: 'Cancelar',
      confirmKey: const Key('confirm_logout_button'),
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
        actions: [
          IconButton(
            key: const Key('open_gallery_button'),
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Galería de componentes',
            onPressed: () => Navigator.of(context).pushNamed('/galeria'),
          ),
          const SizedBox(width: 8),
        ],
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
        onOpenGallery: () => Navigator.of(context).pushNamed('/galeria'),
      ),
      bottomNavigationBar: widget.user.isAdmin
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: PrimaryButton(
                  buttonKey: const Key('new_event_button'),
                  onPressed: _openNewEvent,
                  icon: Icons.add_rounded,
                  label: 'Crear evento',
                  isFullWidth: true,
                ),
              ),
            )
          : null,
    );
  }
}
