import 'package:flutter/material.dart';

import '../models/auth_user.dart';
import '../data/mock_events.dart';
import '../models/event.dart';
import '../pages/new_event_page.dart';
import 'recommendation_screen.dart';

/// Screen anfitriona del formulario de evento (F-03).
/// Soporta tanto la creación de un nuevo evento en el paso 1 del asistente
/// como la edición de un evento ya existente.
class NewEventScreen extends StatefulWidget {
  final AuthUser user;
  final Event? baseEvent;
  final Event? eventToEdit;
  final ValueChanged<Event>? onEventCreated;
  final ValueChanged<Event>? onEventUpdated;

  const NewEventScreen({
    super.key,
    required this.user,
    this.baseEvent,
    this.eventToEdit,
    this.onEventCreated,
    this.onEventUpdated,
  });

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
    if (widget.eventToEdit != null) {
      final ev = widget.eventToEdit!;
      _name = ev.name;
      _attendees = ev.estimatedAttendees.toString();
      _category = ev.category;
      _modality = ev.modality;
      _date = ev.date;
      _baseEvent = null;
    } else {
      _applyBaseEvent(widget.baseEvent);
    }
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
    if (widget.eventToEdit != null) {
      final updated = widget.eventToEdit!.copyWith(
        name: _name.trim().isEmpty ? 'Nuevo evento sin título' : _name.trim(),
        category: _category,
        modality: _modality,
        estimatedAttendees: int.tryParse(_attendees) ?? widget.eventToEdit!.estimatedAttendees,
        date: _date,
      );
      widget.onEventUpdated?.call(updated);
      Navigator.of(context).pop(updated);
      return;
    }

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
          onEventCreated: widget.onEventCreated,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.eventToEdit != null;

    if (!widget.user.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: Text(isEditing ? 'Editar evento' : 'Nuevo evento')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Solo un administrador puede configurar eventos.',
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isEditing ? 'Editar evento' : 'Nuevo evento'),
            Text(
              isEditing
                  ? 'Modificar características'
                  : 'Paso 1 de 3 · Características',
              style: const TextStyle(
                color: Color(0xFF737373),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: NewEventPage(
        isEditing: isEditing,
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
