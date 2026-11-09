import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peewah_event_recommender/features/auth/data/mock_users.dart';
import 'package:peewah_event_recommender/features/events/data/mock_events.dart';
import 'package:peewah_event_recommender/features/events/data/mock_recommendations.dart';
import 'package:peewah_event_recommender/features/events/domain/entities/event.dart';
import 'package:peewah_event_recommender/features/events/ui/screens/recommendation_screen.dart';

Event _draft(EventCategory category, EventModality modality) {
  return buildMockEventFromForm(
    name: 'Evento de prueba',
    category: category,
    modality: modality,
    attendees: '150',
    date: DateTime(2027, 3, 1),
  );
}

Future<void> _tapKey(WidgetTester tester, String key) async {
  final target = find.byKey(Key(key));
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

String _decisionOf(WidgetTester tester, String type) {
  final badge = find.byKey(ValueKey('decision_$type'));
  return tester
      .widget<Text>(find.descendant(of: badge, matching: find.byType(Text)))
      .data!;
}

void main() {
  group('suggestBlocks', () {
    test('CA-1: usa los eventos similares de la organización', () {
      final result = suggestBlocks(
        draft: _draft(EventCategory.congreso, EventModality.hibrida),
        history: mockEvents,
      );

      expect(result.usesTypicalConfiguration, isFalse);
      expect(result.blocks, hasLength(3));
      for (final block in result.blocks) {
        expect(block.decision, RecommendationDecision.pendiente);
        expect(
          block.originEvents,
          contains('Congreso Internacional de Tecnología 2025'),
        );
      }
    });

    test('CA-2: sin eventos similares usa la configuración típica', () {
      final result = suggestBlocks(
        draft: _draft(EventCategory.taller, EventModality.presencial),
        history: mockEvents,
      );

      expect(result.usesTypicalConfiguration, isTrue);
      expect(result.blocks, hasLength(3));
      expect(
        result.blocks.every(
          (block) => block.decision == RecommendationDecision.pendiente,
        ),
        isTrue,
      );
    });
  });

  group('RecommendationBlock', () {
    const block = RecommendationBlock(
      type: RecommendationBlockType.formulario,
      decision: RecommendationDecision.pendiente,
      suggestedItems: ['Nombre', 'Correo'],
    );

    test('editar conserva lo sugerido aparte', () {
      final edited = block.edit(['Nombre', 'Correo', 'Teléfono']);
      expect(edited.decision, RecommendationDecision.editado);
      expect(edited.suggestedItems, ['Nombre', 'Correo']);
      expect(edited.currentItems, ['Nombre', 'Correo', 'Teléfono']);
    });

    test('CA-3: rechazar deja el bloque vacío', () {
      final rejected = block.reject();
      expect(rejected.decision, RecommendationDecision.rechazado);
      expect(rejected.currentItems, isEmpty);
    });

    test('A4: vale la última decisión', () {
      final changed = block.reject().accept();
      expect(changed.decision, RecommendationDecision.aceptado);
      expect(changed.currentItems, ['Nombre', 'Correo']);
    });
  });

  testWidgets('Paso 2: decidir los tres bloques y ver las decisiones',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RecommendationScreen(
          user: mockAdminUser,
          draft: _draft(EventCategory.taller, EventModality.presencial),
          searchDelay: Duration.zero,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // CA-2: aviso de configuración típica.
    expect(find.byKey(const Key('typical_configuration_notice')), findsOneWidget);

    // CA-5: no avanza sin decidir los tres bloques.
    await _tapKey(tester, 'recommendation_next_button');
    expect(find.text('Decide qué haces con los tres bloques'), findsOneWidget);
    expect(find.text('Revisa los bloques sugeridos'), findsOneWidget);

    // CA-3: rechazar el cronograma.
    await _tapKey(tester, 'reject_cronograma');
    expect(_decisionOf(tester, 'cronograma'), 'Rechazado');

    // CA-4: agregar un campo al formulario y guardar.
    await _tapKey(tester, 'edit_formulario');
    await _tapKey(tester, 'add_item_button');
    final lastInput = find.byType(TextFormField).last;
    await tester.enterText(lastInput, 'Teléfono (opcional)');
    await _tapKey(tester, 'save_block_button');
    expect(_decisionOf(tester, 'formulario'), 'Editado');
    expect(find.text('Teléfono (opcional)'), findsOneWidget);

    await _tapKey(tester, 'accept_tareas');
    expect(_decisionOf(tester, 'tareas'), 'Aceptado');

    // CA-6: el detalle muestra las tres decisiones.
    await _tapKey(tester, 'recommendation_next_button');
    expect(find.text('Detalle del evento'), findsOneWidget);
    expect(find.text('Rechazado'), findsWidgets);
    expect(find.text('Editado'), findsWidgets);
    expect(find.text('Aceptado'), findsWidgets);
    expect(find.text('Teléfono (opcional)'), findsOneWidget);
  });
}
