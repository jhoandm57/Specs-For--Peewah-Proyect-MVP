import 'package:flutter/material.dart';

import '../models/event.dart';
import '../pages/events_page.dart';

/// Conserva el filtro y el historial durante la sesión de demostración.
class EventsScreen extends StatefulWidget {
  const EventsScreen({
    super.key,
    required this.canCreate,
    required this.onEventSelected,
    this.onNewEvent,
  });

  final bool canCreate;
  final void Function(BuildContext context, Event event) onEventSelected;
  final Future<Event?> Function(BuildContext context)? onNewEvent;

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final _events = [...demoEvents];
  EventCategory? _category;

  Future<void> _createEvent() async {
    // El asistente devuelve el evento confirmado. Si se cancela, devuelve null.
    final event = await widget.onNewEvent?.call(context);
    if (!mounted || event == null) return;
    setState(() => _events.add(event));
  }

  @override
  Widget build(BuildContext context) {
    // La lista visible se deriva del historial sin cambiar el orden del original.
    final visibleEvents =
        _events
            .where((event) => _category == null || event.category == _category)
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(title: const Text('Peewah')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: EventsPage(
            events: visibleEvents,
            selectedCategory: _category,
            onFilterChanged: (category) => setState(() => _category = category),
            onEventSelected: (event) => widget.onEventSelected(context, event),
          ),
        ),
      ),
      bottomNavigationBar: widget.canCreate && widget.onNewEvent != null
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _createEvent,
                  icon: const Icon(Icons.add),
                  label: const Text('Nuevo evento'),
                ),
              ),
            )
          : null,
    );
  }
}
