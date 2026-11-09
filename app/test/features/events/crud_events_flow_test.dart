import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/data/mock_users.dart';
import 'package:app/data/mock_events.dart';
import 'package:app/models/event.dart';
import 'package:app/screens/events_screen.dart';
import 'package:app/screens/gallery_screen.dart';

void main() {
  setUp(() {
    // Restaura mockEvents para pruebas aisladas
    mockEvents.clear();
    mockEvents.addAll([
      Event(
        id: 'evt-test-1',
        organizationId: mockOrganizationId,
        name: 'Evento Prueba Inicial',
        category: EventCategory.congreso,
        modality: EventModality.presencial,
        estimatedAttendees: 200,
        registrations: 50,
        date: DateTime.now().add(const Duration(days: 30)),
        status: EventStatus.configurado,
        registrationFields: defaultRegistrationFields,
        schedule: defaultSchedule,
        tasks: defaultTasks,
        recommendation: typicalRecommendation(EventCategory.congreso),
      ),
    ]);
  });

  group('Flujo en memoria: Crear, Editar y Eliminar eventos (F-02, F-07)', () {
    testWidgets('EventsScreen almacena la lista en su estado y refleja nuevo evento creado',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: EventsScreen(user: mockAdminUser),
        ),
      );
      await tester.pumpAndSettle();

      // Verifica evento inicial en la lista
      expect(find.text('Evento Prueba Inicial'), findsOneWidget);
      expect(find.text('1 eventos'), findsOneWidget);

      // Toca el botón Crear evento
      await tester.tap(find.byKey(const Key('new_event_button')));
      await tester.pumpAndSettle();

      // Completa Paso 1 (Nombre y Asistentes)
      await tester.enterText(
        find.byKey(const Key('event_name_input')),
        'Seminario Nuevo 2026',
      );
      await tester.enterText(
        find.byKey(const Key('event_attendees_input')),
        '150',
      );
      await tester.pumpAndSettle();

      // Siguiente -> Paso 2
      final saveButton = find.byKey(const Key('save_event_button'));
      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();
      await tester.tap(saveButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Paso 2: Acepta los tres bloques
      final acceptForm = find.byKey(const Key('accept_formulario'));
      await tester.ensureVisible(acceptForm);
      await tester.pumpAndSettle();
      await tester.tap(acceptForm);
      await tester.pumpAndSettle();

      final acceptCron = find.byKey(const Key('accept_cronograma'));
      await tester.ensureVisible(acceptCron);
      await tester.pumpAndSettle();
      await tester.tap(acceptCron);
      await tester.pumpAndSettle();

      final acceptTasks = find.byKey(const Key('accept_tareas'));
      await tester.ensureVisible(acceptTasks);
      await tester.pumpAndSettle();
      await tester.tap(acceptTasks);
      await tester.pumpAndSettle();

      // Siguiente -> Paso 3
      final nextRecButton = find.byKey(const Key('recommendation_next_button'));
      await tester.ensureVisible(nextRecButton);
      await tester.pumpAndSettle();
      await tester.tap(nextRecButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Siguiente -> Confirmación
      final nextTempButton = find.byKey(const Key('temporality_next_button'));
      await tester.ensureVisible(nextTempButton);
      await tester.pumpAndSettle();
      await tester.tap(nextTempButton);
      await tester.pumpAndSettle();

      // Confirmar evento
      final confirmButton = find.byKey(const Key('confirm_event_button'));
      await tester.ensureVisible(confirmButton);
      await tester.pumpAndSettle();
      await tester.tap(confirmButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Se abre el detalle del evento confirmado
      expect(find.text('Seminario Nuevo 2026'), findsOneWidget);

      // Regresa a la lista de eventos
      await tester.pageBack();
      await tester.pumpAndSettle();

      // El nuevo evento debe aparecer inmediatamente en la lista interna de EventsScreen
      expect(find.text('Seminario Nuevo 2026'), findsOneWidget);
      expect(find.text('2 eventos'), findsOneWidget);
    });

    testWidgets('Editar evento: abre formulario precargado y refleja cambios en detalle y lista',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: EventsScreen(user: mockAdminUser),
        ),
      );
      await tester.pumpAndSettle();

      // Abre el detalle del evento existente
      final eventCard = find.byKey(const Key('event_card_evt-test-1'));
      await tester.ensureVisible(eventCard);
      await tester.pumpAndSettle();
      await tester.tap(eventCard);
      await tester.pumpAndSettle();

      expect(find.text('Evento Prueba Inicial'), findsOneWidget);

      // Toca el botón Editar
      final editButton = find.byKey(const Key('edit_event_button'));
      await tester.ensureVisible(editButton);
      await tester.pumpAndSettle();
      expect(editButton, findsOneWidget);
      await tester.tap(editButton);
      await tester.pumpAndSettle();

      // Verifica que abre con los datos precargados
      expect(find.text('Editar evento'), findsWidgets);
      expect(find.text('Evento Prueba Inicial'), findsOneWidget);

      // Modifica el nombre del evento
      final nameInput = find.byKey(const Key('event_name_input'));
      await tester.enterText(
        nameInput,
        'Evento Prueba Modificado 2026',
      );
      await tester.pumpAndSettle();

      // Guarda los cambios
      final saveButton = find.byKey(const Key('save_event_button'));
      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Verifica reflejo inmediato en el detalle del evento
      expect(find.text('Evento Prueba Modificado 2026'), findsOneWidget);
      expect(find.text('Evento actualizado'), findsOneWidget);

      // Vuelve a la lista de eventos
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Verifica reflejo inmediato en la lista de EventsScreen
      expect(find.text('Evento Prueba Modificado 2026'), findsOneWidget);
      expect(find.text('Evento Prueba Inicial'), findsNothing);
    });

    testWidgets('Eliminar evento: diálogo de confirmación y eliminación inmediata de la lista',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: EventsScreen(user: mockAdminUser),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Evento Prueba Inicial'), findsOneWidget);
      expect(find.text('1 eventos'), findsOneWidget);

      // Abre el detalle del evento
      final eventCard = find.byKey(const Key('event_card_evt-test-1'));
      await tester.ensureVisible(eventCard);
      await tester.pumpAndSettle();
      await tester.tap(eventCard);
      await tester.pumpAndSettle();

      // Toca el botón Eliminar
      final deleteButton = find.byKey(const Key('delete_event_button'));
      await tester.ensureVisible(deleteButton);
      await tester.pumpAndSettle();
      expect(deleteButton, findsOneWidget);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // Verifica diálogo de confirmación
      expect(find.text('¿Eliminar este evento?'), findsOneWidget);
      expect(find.byKey(const Key('confirm_delete_event_button')), findsOneWidget);

      // Confirma la eliminación
      await tester.tap(find.byKey(const Key('confirm_delete_event_button')));
      await tester.pumpAndSettle();

      // Vuelve a EventsScreen y el evento desaparece de la lista
      expect(find.text('Evento Prueba Inicial'), findsNothing);
      expect(find.text('0 eventos'), findsOneWidget);
      expect(find.text('Tu organización todavía no tiene eventos'), findsOneWidget);
      expect(find.text('Evento eliminado'), findsOneWidget);
    });

    testWidgets('Galería de componentes (/galeria) renderiza widgets reutilizables',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: GalleryScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Galería de Componentes'), findsWidgets);
      expect(find.text('PrimaryButton'), findsOneWidget);
      expect(find.text('SecondaryButton'), findsOneWidget);
      expect(find.text('AppTextField'), findsOneWidget);
      expect(find.text('ConfirmDialog'), findsOneWidget);
      expect(find.text('StatusBadge & StepIndicator'), findsOneWidget);

      // Prueba interacción con el diálogo estándar de la galería
      final openDialogBtn = find.byKey(const Key('gallery_open_standard_dialog'));
      await tester.ensureVisible(openDialogBtn);
      await tester.pumpAndSettle();
      await tester.tap(openDialogBtn);
      await tester.pumpAndSettle();

      expect(find.text('¿Confirmar operación?'), findsOneWidget);
      await tester.tap(find.byKey(const Key('dialog_cancel_button')));
      await tester.pumpAndSettle();
      expect(find.text('¿Confirmar operación?'), findsNothing);
    });
  });
}
