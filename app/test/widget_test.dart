import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';

Future<void> _pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const PeewahApp());
  await tester.pumpAndSettle();
}

Future<void> _quickLogin(WidgetTester tester, Key key) async {
  final quickAccess = find.byKey(key);
  await tester.ensureVisible(quickAccess);
  await tester.pumpAndSettle();
  await tester.tap(quickAccess);
  await tester.pumpAndSettle();
}

Future<void> _loginAsAdmin(WidgetTester tester) async {
  await _pumpApp(tester);
  await _quickLogin(tester, const Key('quick_login_admin'));
}

Future<void> _loginAsCollaborator(WidgetTester tester) async {
  await _pumpApp(tester);
  await _quickLogin(tester, const Key('quick_login_collaborator'));
}

void main() {
  testWidgets(
    'Flujo de navegación: Login -> Eventos -> Cerrar sesión -> Login',
    (tester) async {
      await _pumpApp(tester);

      expect(find.text('Recomendador de Eventos'), findsOneWidget);
      expect(find.byKey(const Key('email_input')), findsOneWidget);
      expect(find.byKey(const Key('password_input')), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('email_input')),
        'usuario@peewah.co',
      );
      await tester.enterText(
        find.byKey(const Key('password_input')),
        'password123',
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      expect(find.text('Eventos de la organización'), findsOneWidget);
      expect(find.byKey(const Key('logout_button')), findsOneWidget);
      expect(find.byKey(const Key('new_event_button')), findsOneWidget);

      await tester.tap(find.byKey(const Key('logout_button')));
      await tester.pumpAndSettle();

      expect(find.text('¿Cerrar sesión?'), findsOneWidget);
      await tester.tap(find.byKey(const Key('confirm_logout_button')));
      await tester.pumpAndSettle();

      expect(find.text('Recomendador de Eventos'), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsOneWidget);
      expect(find.text('Eventos de la organización'), findsNothing);
    },
  );

  testWidgets('Administrador: detalle del evento y uso como base', (
    tester,
  ) async {
    await _loginAsAdmin(tester);

    expect(find.text('Administrador'), findsOneWidget);
    expect(find.byKey(const Key('new_event_button')), findsOneWidget);
    expect(
      find.byKey(const Key('use_as_base_card_evt-congreso-2025')),
      findsOneWidget,
    );

    final eventCard = find.byKey(const Key('event_card_evt-congreso-2025'));
    await tester.ensureVisible(eventCard);
    await tester.pumpAndSettle();
    await tester.tap(eventCard);
    await tester.pumpAndSettle();

    expect(find.text('Detalle del evento'), findsOneWidget);
    expect(find.text('Configuración operativa'), findsOneWidget);
    expect(find.text('Consulta de recomendaciones'), findsOneWidget);
    expect(find.text('Formulario de inscripción'), findsWidgets);
    expect(find.text('Cronograma del evento'), findsOneWidget);
    expect(find.text('Registro de decisiones'), findsOneWidget);

    final useAsBase = find.byKey(const Key('use_as_base_detail'));
    expect(useAsBase, findsOneWidget);

    await tester.ensureVisible(useAsBase);
    await tester.pumpAndSettle();
    await tester.tap(useAsBase);
    await tester.pumpAndSettle();

    expect(find.text('Nuevo evento'), findsOneWidget);
    expect(find.byKey(const Key('base_event_banner')), findsOneWidget);
    expect(
      find.textContaining(
        'Usando como base: Congreso Internacional de Tecnología 2025',
      ),
      findsOneWidget,
    );

    final cancelButton = find.byKey(const Key('cancel_event_button'));
    await tester.ensureVisible(cancelButton);
    await tester.pumpAndSettle();
    await tester.tap(cancelButton);
    await tester.pumpAndSettle();

    expect(find.text('Detalle del evento'), findsOneWidget);
  });

  testWidgets('Colaborador: consulta sin acciones de administración', (
    tester,
  ) async {
    await _loginAsCollaborator(tester);

    expect(find.text('Colaborador'), findsOneWidget);
    expect(find.byKey(const Key('new_event_button')), findsNothing);
    expect(
      find.byKey(const Key('use_as_base_card_evt-congreso-2025')),
      findsNothing,
    );

    final eventCard = find.byKey(const Key('event_card_evt-congreso-2025'));
    await tester.ensureVisible(eventCard);
    await tester.pumpAndSettle();
    await tester.tap(eventCard);
    await tester.pumpAndSettle();

    expect(find.text('Detalle del evento'), findsOneWidget);
    expect(find.byKey(const Key('use_as_base_detail')), findsNothing);
    expect(find.text('Consulta de recomendaciones'), findsOneWidget);
    expect(find.text('Registro de decisiones'), findsOneWidget);
  });

  testWidgets(
    'Administrador: crear evento, decidir bloques y abrir su detalle',
    (tester) async {
      await _loginAsAdmin(tester);

      await tester.tap(find.byKey(const Key('new_event_button')));
      await tester.pumpAndSettle();

      expect(find.text('Describe el nuevo evento'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('event_name_input')),
        'Seminario de Prueba 2026',
      );
      await tester.enterText(
        find.byKey(const Key('event_attendees_input')),
        '180',
      );

      final categoryDropdown = find.byKey(const ValueKey('category-none'));
      await tester.ensureVisible(categoryDropdown);
      await tester.pumpAndSettle();
      await tester.tap(categoryDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Seminario').last);
      await tester.pumpAndSettle();

      final modalityDropdown = find.byKey(const ValueKey('modality-none'));
      await tester.ensureVisible(modalityDropdown);
      await tester.pumpAndSettle();
      await tester.tap(modalityDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Virtual').last);
      await tester.pumpAndSettle();

      final saveButton = find.byKey(const Key('save_event_button'));
      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('Revisa los bloques sugeridos'), findsOneWidget);
      for (final type in ['formulario', 'cronograma', 'tareas']) {
        final accept = find.byKey(Key('accept_$type'));
        await tester.ensureVisible(accept);
        await tester.pumpAndSettle();
        await tester.tap(accept);
        await tester.pumpAndSettle();
      }

      final nextButton = find.byKey(const Key('recommendation_next_button'));
      await tester.ensureVisible(nextButton);
      await tester.pumpAndSettle();
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // Paso 3: Fechas sugeridas (F-05)
      expect(find.text('Paso 3 de 3 · Fechas sugeridas'), findsOneWidget);
      final acceptOpening = find.byKey(const Key('accept_apertura'));
      await tester.ensureVisible(acceptOpening);
      await tester.pumpAndSettle();
      await tester.tap(acceptOpening);
      await tester.pumpAndSettle();

      final temporalityNext = find.byKey(const Key('temporality_next_button'));
      await tester.ensureVisible(temporalityNext);
      await tester.pumpAndSettle();
      await tester.tap(temporalityNext);
      await tester.pumpAndSettle();

      // Confirmar evento (F-06)
      expect(find.text('Confirmar evento'), findsWidgets);
      final confirmButton = find.byKey(const Key('confirm_event_button'));
      await tester.ensureVisible(confirmButton);
      await tester.pumpAndSettle();
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      expect(find.text('Detalle del evento'), findsOneWidget);
      expect(find.text('Seminario de Prueba 2026'), findsOneWidget);
      expect(find.text('Seminario'), findsWidgets);
      expect(find.text('Virtual'), findsWidgets);
      expect(find.text('180 asistentes'), findsOneWidget);
    },
  );
}
