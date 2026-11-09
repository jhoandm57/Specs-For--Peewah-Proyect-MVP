import 'package:flutter/material.dart';

import '../models/auth_user.dart';
import '../data/mock_events.dart';
import '../models/event.dart';
import '../pages/new_event_page.dart';
import 'recommendation_screen.dart';

/// Screen anfitriona del formulario de nuevo evento (F-03).
/// El estado del formulario vive aquí; la página solo dibuja y reporta.
class NewEventScreen extends StatefulWidget {
  final AuthUser user;
  final Event? baseEvent;

  const NewEventScreen({super.key, required this.user, this.baseEvent});

  @override
  State<NewEventScreen> createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  late Event? _baseEvent;
  String _name = '';
  String _attendees = '';
  EventCategory? _category;
  EventModality? _modality;
  DateTime? _date;

  List<Event> get _availableEvents {
    return mockEvents
        .where((event) => event.organizationId == widget.user.organizationId)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _applyBaseEvent(widget.baseEvent);
  }

  void _applyBaseEvent(Event? event) {
    _baseEvent = event;
    if (event != null) {
      _category = event.category;
      _modality = event.modality;
      _attendees = event.estimatedAttendees.toString();
    }
  }

  void _onBaseEventChanged(String? eventId) {
    Event? selected;
    for (final event in _availableEvents) {
      if (event.id == eventId) {
        selected = event;
        break;
      }
    }

    setState(() {
      if (selected == null) {
        _baseEvent = null;
        return;
      }
      _applyBaseEvent(selected);
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now.add(const Duration(days: 30)),
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 5, 12, 31),
      helpText: 'Selecciona la fecha del evento',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );

    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  void _save() {
    final draft = buildMockEventFromForm(
      name: _name,
      category: _category,
      modality: _modality,
      attendees: _attendees,
      date: _date,
      baseEvent: _baseEvent,
    );

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RecommendationScreen(
          user: widget.user,
          draft: draft,
          baseEvent: _baseEvent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.user.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Nuevo evento')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Solo un administrador puede crear eventos.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nuevo evento'),
            Text(
              'Paso 1 de 3 · Características',
              style: TextStyle(
                color: Color(0xFF737373),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: NewEventPage(
        name: _name,
        attendees: _attendees,
        category: _category,
        modality: _modality,
        date: _date,
        baseEvent: _baseEvent,
        availableEvents: _availableEvents,
        onNameChanged: (value) => setState(() => _name = value),
        onAttendeesChanged: (value) => setState(() => _attendees = value),
        onCategoryChanged: (value) => setState(() => _category = value),
        onModalityChanged: (value) => setState(() => _modality = value),
        onDateTap: _pickDate,
        onBaseEventChanged: _onBaseEventChanged,
        onClearBase: () => setState(() => _baseEvent = null),
        onCancel: () => Navigator.of(context).pop(),
        onSave: _save,
      ),
    );
  }
}
