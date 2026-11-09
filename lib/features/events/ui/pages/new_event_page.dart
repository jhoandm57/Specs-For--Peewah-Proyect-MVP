import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../domain/entities/event.dart';
import '../widgets/section_card.dart';
import '../widgets/step_indicator.dart';

class NewEventPage extends StatelessWidget {
  final String name;
  final String attendees;
  final EventCategory? category;
  final EventModality? modality;
  final DateTime? date;
  final Event? baseEvent;
  final List<Event> availableEvents;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onAttendeesChanged;
  final ValueChanged<EventCategory?> onCategoryChanged;
  final ValueChanged<EventModality?> onModalityChanged;
  final VoidCallback onDateTap;
  final ValueChanged<String?> onBaseEventChanged;
  final VoidCallback onClearBase;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const NewEventPage({
    super.key,
    required this.name,
    required this.attendees,
    required this.category,
    required this.modality,
    required this.date,
    required this.baseEvent,
    required this.availableEvents,
    required this.onNameChanged,
    required this.onAttendeesChanged,
    required this.onCategoryChanged,
    required this.onModalityChanged,
    required this.onDateTap,
    required this.onBaseEventChanged,
    required this.onClearBase,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StepIndicator(
                  currentStep: 1,
                  labels: [
                    'Características',
                    'Bloques sugeridos',
                    'Fechas sugeridas',
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Describe el nuevo evento',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Estos datos permiten buscar eventos similares y preparar la configuración sugerida.',
                  style: TextStyle(
                    color: AppColors.gray600,
                    fontSize: 13.5,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),
                _BaseEventSection(
                  baseEvent: baseEvent,
                  availableEvents: availableEvents,
                  onChanged: onBaseEventChanged,
                  onClear: onClearBase,
                ),
                const SizedBox(height: 16),
                SectionCard(
                  icon: Icons.event_note_outlined,
                  title: 'Características del evento',
                  subtitle: 'Todos los campos son obligatorios.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        key: const Key('event_name_input'),
                        initialValue: name,
                        onChanged: onNameChanged,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Nombre del evento *',
                          hintText: 'Ej. Congreso de Innovación 2026',
                          prefixIcon: Icon(Icons.title_outlined),
                        ),
                      ),
                      const SizedBox(height: 14),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth >= 560;
                          final categoryField =
                              DropdownButtonFormField<EventCategory>(
                            key: ValueKey(
                              'category-${category?.name ?? 'none'}',
                            ),
                            initialValue: category,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Tipo de evento *',
                              prefixIcon: Icon(Icons.category_outlined),
                            ),
                            hint: const Text('Selecciona un tipo'),
                            items: [
                              for (final item in EventCategory.values)
                                DropdownMenuItem(
                                  value: item,
                                  child: Text(item.label),
                                ),
                            ],
                            onChanged: onCategoryChanged,
                          );
                          final modalityField =
                              DropdownButtonFormField<EventModality>(
                            key: ValueKey(
                              'modality-${modality?.name ?? 'none'}',
                            ),
                            initialValue: modality,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Modalidad *',
                              prefixIcon: Icon(Icons.public_outlined),
                            ),
                            hint: const Text('Selecciona una modalidad'),
                            items: [
                              for (final item in EventModality.values)
                                DropdownMenuItem(
                                  value: item,
                                  child: Text(item.label),
                                ),
                            ],
                            onChanged: onModalityChanged,
                          );

                          if (!isWide) {
                            return Column(
                              children: [
                                categoryField,
                                const SizedBox(height: 14),
                                modalityField,
                              ],
                            );
                          }

                          return Row(
                            children: [
                              Expanded(child: categoryField),
                              const SizedBox(width: 14),
                              Expanded(child: modalityField),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth >= 560;
                          final attendeesField = TextFormField(
                            key: const Key('event_attendees_input'),
                            initialValue: attendees,
                            onChanged: onAttendeesChanged,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Número de asistentes *',
                              hintText: 'Ej. 250',
                              prefixIcon: Icon(Icons.people_outline),
                            ),
                          );
                          final dateField = _DateField(
                            date: date,
                            onTap: onDateTap,
                          );

                          if (!isWide) {
                            return Column(
                              children: [
                                attendeesField,
                                const SizedBox(height: 14),
                                dateField,
                              ],
                            );
                          }

                          return Row(
                            children: [
                              Expanded(child: attendeesField),
                              const SizedBox(width: 14),
                              Expanded(child: dateField),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'La fecha del evento debe ser futura y el número de asistentes mayor que cero.',
                        style: TextStyle(
                          color: AppColors.gray500,
                          fontSize: 11.5,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    OutlinedButton(
                      key: const Key('cancel_event_button'),
                      onPressed: onCancel,
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton.icon(
                      key: const Key('save_event_button'),
                      onPressed: onSave,
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                      label: const Text('Siguiente'),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'En el siguiente paso verás los bloques sugeridos a partir de eventos similares.',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.gray500,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BaseEventSection extends StatelessWidget {
  final Event? baseEvent;
  final List<Event> availableEvents;
  final ValueChanged<String?> onChanged;
  final VoidCallback onClear;

  const _BaseEventSection({
    required this.baseEvent,
    required this.availableEvents,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.content_copy_outlined,
      title: 'Evento de referencia (opcional)',
      subtitle: 'Puedes elegir un evento anterior para precargar su configuración.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            key: ValueKey('base-${baseEvent?.id ?? 'none'}'),
            initialValue: baseEvent?.id ?? '',
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Usar un evento como base',
              prefixIcon: Icon(Icons.link_rounded),
            ),
            items: [
              const DropdownMenuItem(
                value: '',
                child: Text('Sin evento base'),
              ),
              for (final event in availableEvents)
                DropdownMenuItem(
                  value: event.id,
                  child: Text(
                    event.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            onChanged: onChanged,
          ),
          if (baseEvent != null) ...[
            const SizedBox(height: 12),
            Container(
              key: const Key('base_event_banner'),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.bookmark_added_outlined,
                    color: AppColors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Usando como base: ${baseEvent!.name}',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Se precargaron el tipo, la modalidad y el tamaño estimado.',
                          style: TextStyle(
                            color: AppColors.gray300,
                            fontSize: 11.5,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: onClear,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: const Text('Quitar'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final DateTime? date;
  final VoidCallback onTap;

  const _DateField({required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: const Key('event_date_field'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: InputDecorator(
        isEmpty: date == null,
        decoration: const InputDecoration(
          labelText: 'Fecha del evento *',
          prefixIcon: Icon(Icons.calendar_today_outlined),
        ),
        child: Text(
          date == null ? 'Selecciona una fecha' : formatLongDate(date!),
          style: TextStyle(
            color: date == null ? AppColors.gray400 : AppColors.black,
            fontSize: 14,
            fontWeight: date == null ? FontWeight.w400 : FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
