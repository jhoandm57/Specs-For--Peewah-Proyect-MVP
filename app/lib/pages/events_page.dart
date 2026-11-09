import 'package:flutter/material.dart';

import '../components/event_card.dart';
import '../models/event.dart';

/// Muestra los eventos que entrega la Screen y comunica las interacciones.
class EventsPage extends StatelessWidget {
  const EventsPage({
    super.key,
    required this.events,
    required this.selectedCategory,
    required this.onFilterChanged,
    required this.onEventSelected,
  });

  final List<Event> events;
  final EventCategory? selectedCategory;
  final ValueChanged<EventCategory?> onFilterChanged;
  final ValueChanged<Event> onEventSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Mis eventos',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        // Wrap acomoda los filtros en varias filas cuando hay poco espacio.
        Wrap(
          spacing: 8,
          children: [
            for (final category in [null, ...EventCategory.values])
              ChoiceChip(
                label: Text(category?.label ?? 'Todos'),
                selected: selectedCategory == category,
                onSelected: (_) => onFilterChanged(category),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (events.isEmpty)
          Text(
            selectedCategory == null
                ? 'Tu organización todavía no tiene eventos'
                : 'No hay eventos de esta categoría',
          ),
        for (final event in events)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: EventCard(
              name: event.name,
              category: event.category.label,
              modality: event.modality.label,
              dateLabel: event.dateLabel,
              registrations: event.registrations,
              estimatedAttendance: event.estimatedAttendance,
              onTap: () => onEventSelected(event),
            ),
          ),
      ],
    );
  }
}
