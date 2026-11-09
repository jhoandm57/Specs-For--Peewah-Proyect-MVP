import 'package:flutter/material.dart';

import '../components/event_card.dart';

/// Pantalla temporal que muestra una tarjeta con datos simulados.
class EventCardPreview extends StatelessWidget {
  const EventCardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold da a la vista su barra superior y permite mostrar el aviso al tocar.
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      appBar: AppBar(title: const Text('Peewah')),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          // Limita la vista al ancho móvil del prototipo.
          constraints: const BoxConstraints(maxWidth: 390),
          // La lista permite desplazarse si la ventana tiene poca altura.
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Mis eventos',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              //Datos de ejemplo.
              EventCard(
                name: 'Congreso de Salud 2025',
                category: 'Congreso',
                modality: 'Presencial',
                dateLabel: '14 mar 2025',
                registrations: 412,
                estimatedAttendance: 450,
                status: 'Finalizado',
                // Hace visible que el toque llegó al callback de la vista.
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Evento seleccionado')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
