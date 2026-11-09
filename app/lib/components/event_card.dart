import 'package:flutter/material.dart';

/// Tarjeta reutilizable para mostrar un evento en la lista de Mis eventos.
/// La pantalla anfitriona le pasa los datos y decide cómo abrir el detalle.
class EventCard extends StatelessWidget {
  // El total estimado debe ser positivo para calcular el progreso.
  const EventCard({
    super.key,
    required this.name,
    required this.category,
    required this.modality,
    required this.dateLabel,
    required this.registrations,
    required this.estimatedAttendance,
    required this.onTap,
    this.status = 'Configurado',
  }) : assert(registrations >= 0),
       assert(estimatedAttendance > 0);

  // Datos de presentación que recibe la tarjeta para un evento.
  final String name;
  final String category;
  final String modality;
  final String dateLabel;
  final int registrations;
  final int estimatedAttendance;
  // Avisa a la pantalla anfitriona cuando se toca la tarjeta.
  final VoidCallback onTap;
  final String status;

  @override
  Widget build(BuildContext context) {
    // Colores de texto
    const ink = Color(0xFF161616);
    const muted = Color(0xFF696969);
    // La barra recibe un valor de 0 a 1. Si se supera el estimado,
    // la barra queda llena y el texto sigue mostrando el conteo real.
    final progress = (registrations / estimatedAttendance).clamp(0.0, 1.0);
    final attendanceLabel = '$registrations de $estimatedAttendance inscritos';

    // Superficie blanca con borde y esquinas redondeadas.
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(0xFFE4E4E4)),
      ),
      // Toda la tarjeta responde al toque y muestra una reacción visual.
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // El nombre usa el espacio disponible junto a la etiqueta de estado.
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(color: ink, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      child: Text(status, style: const TextStyle(color: muted)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '$category · $modality · $dateLabel',
                style: const TextStyle(color: muted),
              ),
              const SizedBox(height: 14),
              // El lector de pantalla obtiene el conteo del texto de abajo.
              ExcludeSemantics(
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  color: ink,
                  backgroundColor: const Color(0xFFE4E4E4),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 6),
              Text(attendanceLabel, style: const TextStyle(color: muted)),
            ],
          ),
        ),
      ),
    );
  }
}
