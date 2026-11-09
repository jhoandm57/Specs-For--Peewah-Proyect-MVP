import 'package:flutter/material.dart';

import '../components/confirm_dialog.dart';
import '../models/auth_user.dart';
import '../data/mock_events.dart';
import '../models/event.dart';
import '../pages/confirm_event_page.dart';
import 'event_detail_screen.dart';

/// Screen anfitriona de la confirmación final del evento (F-06).
/// Maneja la confirmación, la persistencia en memoria y la confirmación de salida.
class ConfirmEventScreen extends StatefulWidget {
  final AuthUser user;
  final Event draft;
  final Event? baseEvent;
  final ValueChanged<Event>? onEventCreated;

  const ConfirmEventScreen({
    super.key,
    required this.user,
    required this.draft,
    this.baseEvent,
    this.onEventCreated,
  });

  @override
  State<ConfirmEventScreen> createState() => _ConfirmEventScreenState();
}

class _ConfirmEventScreenState extends State<ConfirmEventScreen> {
  var _isSaving = false;

  Future<bool> _promptExitWithoutSaving() async {
    final exit = await ConfirmDialog.show(
      context: context,
      title: '¿Salir sin guardar?',
      message: 'Se perderá lo que no confirmaste',
      confirmLabel: 'Salir sin guardar',
      cancelLabel: 'Continuar editando',
      isDestructive: true,
      confirmKey: const Key('confirm_exit_without_saving'),
      cancelKey: const Key('continue_editing_button'),
    );

    if (exit == true && mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return true;
    }
    return false;
  }

  Future<void> _confirmEvent() async {
    setState(() => _isSaving = true);
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    final configuredEvent = Event(
      id: widget.draft.id,
      organizationId: widget.draft.organizationId,
      name: widget.draft.name,
      category: widget.draft.category,
      modality: widget.draft.modality,
      estimatedAttendees: widget.draft.estimatedAttendees,
      registrations: widget.draft.registrations,
      date: widget.draft.date,
      status: EventStatus.configurado,
      baseEventName: widget.draft.baseEventName,
      registrationFields: widget.draft.registrationFields,
      schedule: widget.draft.schedule,
      tasks: widget.draft.tasks,
      recommendation: widget.draft.recommendation,
    );

    // Persistencia en memoria
    mockEvents.removeWhere((e) => e.id == configuredEvent.id);
    mockEvents.insert(0, configuredEvent);

    // Notifica a EventsScreen
    widget.onEventCreated?.call(configuredEvent);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Evento configurado'),
        duration: Duration(seconds: 3),
      ),
    );

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => EventDetailScreen(
          event: configuredEvent,
          user: widget.user,
          onEventUpdated: (updated) {
            mockEvents.removeWhere((e) => e.id == updated.id);
            mockEvents.insert(0, updated);
          },
          onEventDeleted: (deletedId) {
            mockEvents.removeWhere((e) => e.id == deletedId);
          },
        ),
      ),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _promptExitWithoutSaving();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Confirmar evento'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: _promptExitWithoutSaving,
          ),
        ),
        body: ConfirmEventPage(
          event: widget.draft,
          isSaving: _isSaving,
          onConfirm: _confirmEvent,
          onCancel: _promptExitWithoutSaving,
        ),
      ),
    );
  }
}
