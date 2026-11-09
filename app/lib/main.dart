import 'package:flutter/material.dart';

import 'screens/event_card_preview_screen.dart';
import 'screens/events_screen.dart';
import 'theme/app_theme.dart';

// Punto de entrada del proyecto Flutter.
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peewah',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: '/',
      routes: {
        '/': (_) => EventsScreen(
          canCreate: true,
          // Los avisos permiten comprobar la conexión mientras llegan las rutas del equipo.
          onEventSelected: (context, event) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Evento seleccionado: ${event.name}')),
            );
          },
          onNewEvent: (context) async {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('El asistente está pendiente de integración'),
              ),
            );
            return null;
          },
        ),
        '/vista-previa/tarjeta': (_) => const EventCardPreview(),
      },
    );
  }
}
