import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peewah_event_recommender/main.dart';

void main() {
  testWidgets('Flujo de navegación: Login -> Eventos -> Cerrar sesión -> Login',
      (tester) async {
    await tester.pumpWidget(const PeewahApp());
    await tester.pumpAndSettle();

    // 1. Verifica que la pantalla de inicio de sesión esté visible
    expect(find.text('Recomendador de Eventos'), findsOneWidget);
    expect(find.byKey(const Key('email_input')), findsOneWidget);
    expect(find.byKey(const Key('password_input')), findsOneWidget);
    expect(find.byKey(const Key('login_button')), findsOneWidget);

    // Escribe datos simulados
    await tester.enterText(
      find.byKey(const Key('email_input')),
      'usuario@peewah.co',
    );
    await tester.enterText(
      find.byKey(const Key('password_input')),
      'password123',
    );
    await tester.pump();

    // 2. Pulsa "Iniciar sesión" y navega a la siguiente pantalla (/eventos)
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle();

    expect(find.text('Eventos Anteriores'), findsOneWidget);
    expect(find.byKey(const Key('logout_button')), findsOneWidget);

    // 3. Pulsa "Cerrar sesión" y confirma
    await tester.tap(find.byKey(const Key('logout_button')));
    await tester.pumpAndSettle();

    expect(find.text('¿Cerrar sesión?'), findsOneWidget);
    await tester.tap(find.byKey(const Key('confirm_logout_button')));
    await tester.pumpAndSettle();

    // 4. Verifica que retornó a la pantalla de Login
    expect(find.text('Recomendador de Eventos'), findsOneWidget);
    expect(find.byKey(const Key('login_button')), findsOneWidget);
    expect(find.text('Eventos Anteriores'), findsNothing);
  });
}
