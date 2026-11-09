import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/models/event.dart';
import 'package:app/data/mock_users.dart';
import 'package:app/data/mock_events.dart';
import 'package:app/screens/temporality_screen.dart';
import 'package:app/screens/confirm_event_screen.dart';

Widget _wrapWithApp(Widget child) {
  return MaterialApp(
    home: child,
  );
}

void main() {
  final testDraft = Event(
    id: 'evt-test-temporalidad',
    organizationId: mockOrganizationId,
    name: 'Congreso Innovación 2026',
    category: EventCategory.congreso,
    modality: EventModality.hibrida,
    estimatedAttendees: 250,
    date: DateTime(2026, 10, 15),
    status: EventStatus.enConfiguracion,
    registrationFields: defaultRegistrationFields,
    schedule: defaultSchedule,
    tasks: defaultTasks,
    recommendation: const EventRecommendation(
      blocks: [],
      dates: [],
    ),
  );

  group('F-05 · Fechas sugeridas (TemporalityScreen + TemporalityPage)', () {
    testWidgets('CA-1 y CA-2: muestra apertura y recordatorios con días antes y fechas', (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          TemporalityScreen(
            user: mockAdminUser,
            draft: testDraft,
            delay: Duration.zero,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Paso 3 de 3 · Fechas sugeridas'), findsOneWidget);
      expect(find.text('Apertura de inscripciones'), findsWidgets);
      expect(find.textContaining('días antes'), findsWidgets);
      expect(find.textContaining('Recordatorio 1'), findsOneWidget);
    });

    testWidgets('CA-5: sin eventos similares muestra aviso de curva típica', (tester) async {
      final uniqueDraft = testDraft.copyWith(
        category: EventCategory.taller,
        modality: EventModality.virtual,
      );

      await tester.pumpWidget(
        _wrapWithApp(
          TemporalityScreen(
            user: mockAdminUser,
            draft: uniqueDraft,
            delay: Duration.zero,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('typical_curve_banner')), findsOneWidget);
      expect(
        find.textContaining('Fechas basadas en la curva típica de un Taller'),
        findsOneWidget,
      );
    });

    testWidgets('CA-6: apertura anterior a hoy se ajusta a hoy con aviso', (tester) async {
      final nearEvent = testDraft.copyWith(
        date: DateTime.now().add(const Duration(days: 5)),
      );

      await tester.pumpWidget(
        _wrapWithApp(
          TemporalityScreen(
            user: mockAdminUser,
            draft: nearEvent,
            delay: Duration.zero,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('opening_adjusted_banner')), findsOneWidget);
      expect(
        find.textContaining('se sugiere abrir hoy'),
        findsOneWidget,
      );
    });

    testWidgets('CA-4: rechazar un recordatorio lo marca como rechazado', (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          TemporalityScreen(
            user: mockAdminUser,
            draft: testDraft,
            delay: Duration.zero,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final rejectReminder0 = find.byKey(const Key('reject_recordatorio_0'));
      await tester.ensureVisible(rejectReminder0);
      await tester.pumpAndSettle();
      await tester.tap(rejectReminder0);
      await tester.pumpAndSettle();

      expect(
        find.text('Recordatorio rechazado. No se enviará a los inscritos.'),
        findsOneWidget,
      );
    });

    testWidgets('CA-7: rechazar apertura y avanzar sin definir otra muestra error', (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          TemporalityScreen(
            user: mockAdminUser,
            draft: testDraft,
            delay: Duration.zero,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final rejectOpening = find.byKey(const Key('reject_apertura'));
      await tester.ensureVisible(rejectOpening);
      await tester.pumpAndSettle();
      await tester.tap(rejectOpening);
      await tester.pumpAndSettle();

      // En el diálogo de días a mano, cancelamos para no ingresar nada
      final cancelDialog = find.text('Cancelar');
      expect(cancelDialog, findsOneWidget);
      await tester.tap(cancelDialog);
      await tester.pumpAndSettle();

      // Intentamos avanzar
      final nextButton = find.byKey(const Key('temporality_next_button'));
      await tester.ensureVisible(nextButton);
      await tester.pumpAndSettle();
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('opening_error_text')), findsOneWidget);
      expect(find.text('Escribe cuándo abrir las inscripciones'), findsOneWidget);
    });
  });

  group('F-06 · Confirmar evento y salir sin guardar (ConfirmEventScreen)', () {
    testWidgets('CA-4: Salir sin guardar pregunta "¿Salir sin guardar?" y descarta el evento', (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          ConfirmEventScreen(
            user: mockAdminUser,
            draft: testDraft,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final cancelBtn = find.byKey(const Key('cancel_confirmation_button'));
      await tester.ensureVisible(cancelBtn);
      await tester.pumpAndSettle();
      await tester.tap(cancelBtn);
      await tester.pumpAndSettle();

      expect(find.text('¿Salir sin guardar?'), findsOneWidget);
      expect(find.text('Se perderá lo que no confirmaste'), findsOneWidget);
      expect(find.byKey(const Key('continue_editing_button')), findsOneWidget);
      expect(find.byKey(const Key('confirm_exit_without_saving')), findsOneWidget);

      await tester.tap(find.byKey(const Key('confirm_exit_without_saving')));
      await tester.pumpAndSettle();
    });

    testWidgets('CA-1 y CA-2: Confirmar evento muestra SnackBar y guarda el evento', (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          ConfirmEventScreen(
            user: mockAdminUser,
            draft: testDraft,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final confirmBtn = find.byKey(const Key('confirm_event_button'));
      await tester.ensureVisible(confirmBtn);
      await tester.pumpAndSettle();
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      expect(find.text('Evento configurado'), findsOneWidget);
      expect(find.text('Detalle del evento'), findsOneWidget);
      expect(find.text('Congreso Innovación 2026'), findsOneWidget);

      // Verificamos que se reflejó en mockEvents
      expect(
        mockEvents.any((e) => e.id == testDraft.id && e.status == EventStatus.configurado),
        isTrue,
      );
    });
  });
}
