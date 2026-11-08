enum EventCategory {
  congress('Congreso'),
  fair('Feria'),
  seminar('Seminario');

  const EventCategory(this.label);
  final String label;
}

enum EventModality {
  onsite('Presencial'),
  hybrid('Híbrida'),
  online('Virtual');

  const EventModality(this.label);
  final String label;
}

/// Datos de un evento configurado que necesita el listado.
class Event {
  Event({
    required this.id,
    required this.name,
    required this.category,
    required this.modality,
    required this.date,
    required this.estimatedAttendance,
    required this.registrations,
  });

  final int id;
  final String name;
  final EventCategory category;
  final EventModality modality;
  final DateTime date;
  final int estimatedAttendance;
  final int registrations;

  String get dateLabel {
    const months = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

/// Historial simulado de una organización con dos ediciones por evento.
final demoEvents = List<Event>.unmodifiable([
  Event(
    id: 1,
    name: 'Congreso de Salud 2025',
    category: EventCategory.congress,
    modality: EventModality.onsite,
    date: DateTime(2025, 3, 14),
    estimatedAttendance: 450,
    registrations: 412,
  ),
  Event(
    id: 2,
    name: 'Congreso de Salud 2024',
    category: EventCategory.congress,
    modality: EventModality.onsite,
    date: DateTime(2024, 3, 22),
    estimatedAttendance: 400,
    registrations: 371,
  ),
  Event(
    id: 3,
    name: 'Feria Empresarial 2025',
    category: EventCategory.fair,
    modality: EventModality.hybrid,
    date: DateTime(2025, 9, 5),
    estimatedAttendance: 600,
    registrations: 574,
  ),
  Event(
    id: 4,
    name: 'Feria Empresarial 2024',
    category: EventCategory.fair,
    modality: EventModality.hybrid,
    date: DateTime(2024, 9, 6),
    estimatedAttendance: 550,
    registrations: 510,
  ),
  Event(
    id: 5,
    name: 'Seminario de Innovación 2025',
    category: EventCategory.seminar,
    modality: EventModality.online,
    date: DateTime(2025, 11, 18),
    estimatedAttendance: 120,
    registrations: 109,
  ),
  Event(
    id: 6,
    name: 'Seminario de Innovación 2024',
    category: EventCategory.seminar,
    modality: EventModality.online,
    date: DateTime(2024, 11, 19),
    estimatedAttendance: 110,
    registrations: 101,
  ),
]);
