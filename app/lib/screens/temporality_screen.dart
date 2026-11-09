import 'package:flutter/material.dart';

import '../models/auth_user.dart';
import '../data/mock_events.dart';
import '../data/mock_recommendations.dart';
import '../models/event.dart';
import '../pages/temporality_page.dart';
import 'confirm_event_screen.dart';

/// Screen anfitriona del paso 3 del flujo guiado (F-05).
/// Mantiene el estado de las fechas sugeridas, valida aperturas y recordatorios,
/// y orquesta la navegación hacia el resumen (F-06).
class TemporalityScreen extends StatefulWidget {
  final AuthUser user;
  final Event draft;
  final Event? baseEvent;
  final Duration delay;
  final DateTime? simulatedNow;

  const TemporalityScreen({
    super.key,
    required this.user,
    required this.draft,
    this.baseEvent,
    this.delay = const Duration(milliseconds: 500),
    this.simulatedNow,
  });

  @override
  State<TemporalityScreen> createState() => _TemporalityScreenState();
}

class _TemporalityScreenState extends State<TemporalityScreen> {
  var _loading = true;
  var _usesTypicalCurve = false;
  var _openingAdjustedToToday = false;
  SuggestedDate? _openingDate;
  var _reminders = <SuggestedDate>[];
  String? _openingError;
  String? _reminderError;

  @override
  void initState() {
    super.initState();
    _loadDates();
  }

  Future<void> _loadDates() async {
    await Future<void>.delayed(widget.delay);
    if (!mounted) return;

    final suggestions = suggestDates(
      draft: widget.draft,
      history: mockEvents,
      baseEvent: widget.baseEvent,
      now: widget.simulatedNow,
    );

    SuggestedDate? opening;
    final reminders = <SuggestedDate>[];

    for (final date in suggestions.dates) {
      if (date.type == SuggestedDateType.apertura) {
        opening = date;
      } else {
        reminders.add(date);
      }
    }

    setState(() {
      _openingDate = opening;
      _reminders = reminders;
      _usesTypicalCurve = suggestions.usesTypicalCurve;
      _openingAdjustedToToday = suggestions.openingAdjustedToToday;
      _loading = false;
    });
  }

  void _acceptOpening() {
    if (_openingDate == null) return;
    setState(() {
      _openingDate = _openingDate!.accept();
      _openingError = null;
    });
  }

  Future<void> _editOpening() async {
    if (_openingDate == null) return;
    final initialDays = _openingDate!.daysBeforeFinal ?? _openingDate!.daysBeforeSuggested;
    final newDays = await _showEditDaysDialog(
      title: 'Editar apertura de inscripciones',
      initialDays: initialDays,
    );
    if (newDays == null || !mounted) return;

    if (newDays <= 0) {
      setState(() => _openingError = 'La apertura debe ser antes del evento');
      return;
    }

    setState(() {
      _openingDate = _openingDate!.edit(newDays);
      _openingError = null;
    });
  }

  Future<void> _rejectOpening() async {
    if (_openingDate == null) return;
    setState(() {
      _openingDate = _openingDate!.reject();
    });

    final newDays = await _showEditDaysDialog(
      title: 'Definir apertura de inscripciones',
      initialDays: 15,
      instruction: 'Escribe a mano cuántos días antes del evento abrir las inscripciones:',
    );
    if (newDays != null && mounted) {
      setState(() {
        _openingDate = _openingDate!.edit(newDays);
        _openingError = null;
      });
    }
  }

  void _acceptReminder(int index) {
    setState(() {
      _reminders = [
        for (var i = 0; i < _reminders.length; i++)
          i == index ? _reminders[i].accept() : _reminders[i],
      ];
      _reminderError = null;
    });
  }

  Future<void> _editReminder(int index) async {
    final reminder = _reminders[index];
    final initialDays = reminder.daysBeforeFinal ?? reminder.daysBeforeSuggested;
    final newDays = await _showEditDaysDialog(
      title: 'Editar recordatorio ${index + 1}',
      initialDays: initialDays,
    );
    if (newDays == null || !mounted) return;

    if (newDays <= 0) {
      setState(() => _reminderError = 'El recordatorio debe ser antes del evento');
      return;
    }

    setState(() {
      _reminders = [
        for (var i = 0; i < _reminders.length; i++)
          i == index ? _reminders[i].edit(newDays) : _reminders[i],
      ];
      _reminderError = null;
    });
  }

  void _rejectReminder(int index) {
    setState(() {
      _reminders = [
        for (var i = 0; i < _reminders.length; i++)
          i == index ? _reminders[i].reject() : _reminders[i],
      ];
    });
  }

  Future<int?> _showEditDaysDialog({
    required String title,
    required int initialDays,
    String? instruction,
  }) async {
    final controller = TextEditingController(text: initialDays.toString());
    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (instruction != null) ...[
              Text(
                instruction,
                style: const TextStyle(fontSize: 12.5),
              ),
              const SizedBox(height: 12),
            ],
            TextField(
              key: const Key('edit_days_input'),
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Días antes del evento',
                hintText: 'Ej. 30',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            key: const Key('save_days_dialog_button'),
            onPressed: () {
              final parsed = int.tryParse(controller.text.trim());
              Navigator.of(context).pop(parsed);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _next() {
    if (_openingDate == null) return;

    if (_openingDate!.decision == RecommendationDecision.rechazado &&
        _openingDate!.daysBeforeFinal == null) {
      setState(() {
        _openingError = 'Escribe cuándo abrir las inscripciones';
      });
      return;
    }

    for (final reminder in _reminders) {
      if (reminder.decision != RecommendationDecision.rechazado) {
        final days = reminder.daysBeforeFinal ?? reminder.daysBeforeSuggested;
        if (days <= 0) {
          setState(() {
            _reminderError = 'El recordatorio debe ser antes del evento';
          });
          return;
        }
      }
    }

    final dates = <SuggestedDate>[
      _openingDate!,
      ..._reminders,
    ];

    final eventWithDates = widget.draft.copyWith(
      recommendation: widget.draft.recommendation.copyWith(dates: dates),
    );

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ConfirmEventScreen(
          user: widget.user,
          draft: eventWithDates,
          baseEvent: widget.baseEvent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nuevo evento'),
            Text(
              'Paso 3 de 3 · Fechas sugeridas',
              style: TextStyle(
                color: Color(0xFF737373),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: TemporalityPage(
        eventName: widget.draft.name,
        categoryLabel: widget.draft.category.label,
        eventDate: widget.draft.date,
        loading: _loading,
        usesTypicalCurve: _usesTypicalCurve,
        openingAdjustedToToday: _openingAdjustedToToday,
        openingDate: _openingDate,
        reminders: _reminders,
        openingError: _openingError,
        reminderError: _reminderError,
        onAcceptOpening: _acceptOpening,
        onEditOpening: _editOpening,
        onRejectOpening: _rejectOpening,
        onAcceptReminder: _acceptReminder,
        onEditReminder: _editReminder,
        onRejectReminder: _rejectReminder,
        onBack: () => Navigator.of(context).pop(),
        onNext: _next,
      ),
    );
  }
}
