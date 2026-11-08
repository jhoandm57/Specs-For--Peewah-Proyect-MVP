import 'package:app/components/event_card.dart';
import 'package:app/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('La lista filtra eventos y reporta la selección', (tester) async {
    await tester.pumpWidget(const MyApp());

    // Los eventos más recientes aparecen primero.
    expect(
      tester.widgetList<EventCard>(find.byType(EventCard)).first.name,
      'Seminario de Innovación 2025',
    );

    await tester.tap(find.text('Congreso'));
    await tester.pumpAndSettle();

    // El filtro conserva las dos ediciones de la categoría seleccionada.
    expect(find.byType(EventCard), findsNWidgets(2));
    expect(find.text('Feria Empresarial 2025'), findsNothing);

    await tester.tap(find.text('Congreso de Salud 2025'));
    await tester.pumpAndSettle();
    expect(
      find.text('Evento seleccionado: Congreso de Salud 2025'),
      findsOneWidget,
    );
  });
}
