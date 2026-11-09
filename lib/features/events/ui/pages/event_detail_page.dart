import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../domain/entities/event.dart';
import '../widgets/empty_state.dart';
import '../widgets/recommendation_block_card.dart';
import '../widgets/section_card.dart';
import '../widgets/status_badge.dart';

class EventDetailPage extends StatelessWidget {
  final Event event;
  final AuthUser user;
  final VoidCallback onUseAsBase;

  const EventDetailPage({
    super.key,
    required this.event,
    required this.user,
    required this.onUseAsBase,
  });

  @override
  Widget build(BuildContext context) {
    final dateEntries = _buildDateEntries(event.recommendation.dates);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SummaryCard(
                  event: event,
                  canUseAsBase: user.isAdmin,
                  onUseAsBase: onUseAsBase,
                ),
                const SizedBox(height: 18),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 940;
                    final operational = _OperationalSection(event: event);
                    final recommendations = _RecommendationsSection(
                      event: event,
                      dateEntries: dateEntries,
                    );

                    if (!isWide) {
                      return Column(
                        children: [
                          operational,
                          const SizedBox(height: 16),
                          recommendations,
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: operational),
                        const SizedBox(width: 16),
                        Expanded(child: recommendations),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 22),
                const _SimulationNote(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<_DateEntry> _buildDateEntries(List<SuggestedDate> dates) {
    final entries = <_DateEntry>[];
    var reminderNumber = 0;

    for (final date in dates) {
      if (date.type == SuggestedDateType.apertura) {
        entries.add(
          _DateEntry(date: date, title: 'Apertura de inscripciones'),
        );
      } else {
        reminderNumber++;
        entries.add(
          _DateEntry(date: date, title: 'Recordatorio $reminderNumber'),
        );
      }
    }

    return entries;
  }
}

class _SummaryCard extends StatelessWidget {
  final Event event;
  final bool canUseAsBase;
  final VoidCallback onUseAsBase;

  const _SummaryCard({
    required this.event,
    required this.canUseAsBase,
    required this.onUseAsBase,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              StatusBadge(label: event.category.label),
              StatusBadge(label: event.status.label, filled: true),
              if (event.baseEventName != null)
                StatusBadge(
                  label: 'Basado en un evento anterior',
                  icon: Icons.link_rounded,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            event.name,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 25,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.7,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _MetaPill(
                icon: Icons.public_outlined,
                label: event.modality.label,
              ),
              _MetaPill(
                icon: Icons.people_outline,
                label: '${event.estimatedAttendees} asistentes',
              ),
              _MetaPill(
                icon: Icons.calendar_today_outlined,
                label: formatLongDate(event.date),
              ),
              _MetaPill(
                icon: Icons.apartment_rounded,
                label: event.status.label,
              ),
            ],
          ),
          if (event.baseEventName != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.content_copy_outlined,
                  size: 15,
                  color: AppColors.gray500,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Este evento se creó usando como base: ${event.baseEventName}',
                    style: const TextStyle(
                      color: AppColors.gray600,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (canUseAsBase) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              key: const Key('use_as_base_detail'),
              onPressed: onUseAsBase,
              icon: const Icon(Icons.copy_all_outlined, size: 18),
              label: const Text('Usar como base'),
            ),
          ],
        ],
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.gray600),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.gray600,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _OperationalSection extends StatelessWidget {
  final Event event;

  const _OperationalSection({required this.event});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.tune_rounded,
      title: 'Configuración operativa',
      subtitle: 'Formulario de inscripción, cronograma y tareas del evento.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SubsectionTitle(
            icon: Icons.assignment_outlined,
            title: 'Formulario de inscripción',
            trailing: '${event.registrationFields.length} campos',
          ),
          const SizedBox(height: 10),
          if (event.registrationFields.isEmpty)
            const _MutedText('Sin campos de formulario.')
          else
            for (final field in event.registrationFields)
              _FieldRow(field: field),
          const Divider(height: 28),
          _SubsectionTitle(
            icon: Icons.schedule_outlined,
            title: 'Cronograma del evento',
            trailing: '${event.schedule.length} actividades',
          ),
          const SizedBox(height: 10),
          if (event.schedule.isEmpty)
            const _MutedText('Sin actividades programadas.')
          else
            for (final activity in event.schedule)
              _ActivityRow(activity: activity),
          const Divider(height: 28),
          _SubsectionTitle(
            icon: Icons.checklist_rounded,
            title: 'Tareas operativas',
            trailing: '${event.tasks.length} tareas',
          ),
          const SizedBox(height: 10),
          if (event.tasks.isEmpty)
            const _MutedText('Sin tareas registradas.')
          else
            for (final task in event.tasks) _TaskRow(task: task),
        ],
      ),
    );
  }
}

class _RecommendationsSection extends StatelessWidget {
  final Event event;
  final List<_DateEntry> dateEntries;

  const _RecommendationsSection({
    required this.event,
    required this.dateEntries,
  });

  @override
  Widget build(BuildContext context) {
    final recommendation = event.recommendation;

    return SectionCard(
      icon: Icons.auto_awesome_outlined,
      title: 'Consulta de recomendaciones',
      subtitle: 'Bloques sugeridos, decisiones tomadas y fechas estimadas.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SimulationBadge(),
          const SizedBox(height: 14),
          _SubsectionTitle(
            icon: Icons.view_agenda_outlined,
            title: 'Bloques sugeridos',
            trailing: '${recommendation.blocks.length} bloques',
          ),
          const SizedBox(height: 10),
          if (recommendation.blocks.isEmpty)
            const EmptyState(
              icon: Icons.auto_awesome_outlined,
              title: 'Este evento se configuró sin sugerencias',
              message: 'No se registraron bloques recomendados para este evento.',
            )
          else
            for (final block in recommendation.blocks)
              RecommendationBlockCard(block: block),
          const Divider(height: 28),
          _SubsectionTitle(
            icon: Icons.history_toggle_off_rounded,
            title: 'Registro de decisiones',
          ),
          const SizedBox(height: 10),
          for (final block in recommendation.blocks)
            _DecisionRow(
              title: block.type.label,
              decision: block.decision,
            ),
          for (final entry in dateEntries)
            _DecisionRow(
              title: entry.title,
              decision: entry.date.decision,
            ),
          const Divider(height: 28),
          _SubsectionTitle(
            icon: Icons.mark_email_read_outlined,
            title: 'Fechas de comunicación y recordatorios',
          ),
          const SizedBox(height: 10),
          if (dateEntries.isEmpty)
            const _MutedText('Sin fechas estimadas para este evento.')
          else
            for (final entry in dateEntries)
              _SuggestedDateRow(
                eventDate: event.date,
                entry: entry,
              ),
        ],
      ),
    );
  }
}

class _SubsectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;

  const _SubsectionTitle({
    required this.icon,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.black),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: const TextStyle(
              color: AppColors.gray500,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}

class _FieldRow extends StatelessWidget {
  final RegistrationField field;

  const _FieldRow({required this.field});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            size: 16,
            color: AppColors.gray500,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              field.name,
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          StatusBadge(
            label: field.required ? 'Obligatorio' : 'Opcional',
            filled: field.required,
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final ScheduleActivity activity;

  const _ActivityRow({required this.activity});

  @override
  Widget build(BuildContext context) {
    final dayLabel = activity.dayRelative == 0
        ? 'Día 0'
        : activity.dayRelative > 0
            ? 'Día +${activity.dayRelative}'
            : 'Día ${activity.dayRelative}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 62,
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                Text(
                  dayLabel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  activity.time,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.gray300,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                activity.name,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  final EventTask task;

  const _TaskRow({required this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.radio_button_unchecked_rounded,
              size: 16,
              color: AppColors.gray400,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.name,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${task.responsible} · ${formatDaysBefore(task.daysBeforeDue)}',
                  style: const TextStyle(
                    color: AppColors.gray500,
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DecisionRow extends StatelessWidget {
  final String title;
  final RecommendationDecision decision;

  const _DecisionRow({required this.title, required this.decision});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          StatusBadge(
            label: decision.label,
            filled: decision == RecommendationDecision.aceptado,
          ),
        ],
      ),
    );
  }
}

class _SuggestedDateRow extends StatelessWidget {
  final DateTime eventDate;
  final _DateEntry entry;

  const _SuggestedDateRow({required this.eventDate, required this.entry});

  @override
  Widget build(BuildContext context) {
    final date = entry.date;
    final suggestedDate = dateFromDaysBefore(eventDate, date.daysBeforeSuggested);
    final finalDate = date.daysBeforeFinal == null
        ? null
        : dateFromDaysBefore(eventDate, date.daysBeforeFinal!);
    final isRejected = date.decision == RecommendationDecision.rechazado;
    final isEdited = date.decision == RecommendationDecision.editado;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  entry.title,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              StatusBadge(
                label: date.decision.label,
                filled: date.decision == RecommendationDecision.aceptado,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Sugerido: ${formatLongDate(suggestedDate)} (${formatDaysBefore(date.daysBeforeSuggested)})',
            style: const TextStyle(
              color: AppColors.gray600,
              fontSize: 11.5,
              height: 1.35,
            ),
          ),
          if (isRejected) ...[
            const SizedBox(height: 3),
            const Text(
              'No programado: el recordatorio fue rechazado.',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ] else if (isEdited && finalDate != null) ...[
            const SizedBox(height: 3),
            Text(
              'Final: ${formatLongDate(finalDate)} (${formatDaysBefore(date.daysBeforeFinal!)})',
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                height: 1.35,
              ),
            ),
          ] else if (finalDate != null) ...[
            const SizedBox(height: 3),
            Text(
              'Programado: ${formatLongDate(finalDate)}',
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                height: 1.35,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MutedText extends StatelessWidget {
  final String text;

  const _MutedText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.gray500,
        fontSize: 11.5,
        height: 1.4,
      ),
    );
  }
}

class _SimulationBadge extends StatelessWidget {
  const _SimulationBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColors.gray200),
      ),
      child: const Row(
        children: [
          Icon(Icons.science_outlined, size: 16, color: AppColors.gray600),
          SizedBox(width: 7),
          Expanded(
            child: Text(
              'Recomendaciones simuladas para el MVP.',
              style: TextStyle(
                color: AppColors.gray600,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SimulationNote extends StatelessWidget {
  const _SimulationNote();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Vista de solo consulta con datos simulados. Las acciones de edición y persistencia se conectan en la siguiente iteración.',
      style: TextStyle(
        color: AppColors.gray500,
        fontSize: 11,
        height: 1.4,
      ),
    );
  }
}

class _DateEntry {
  final SuggestedDate date;
  final String title;

  const _DateEntry({required this.date, required this.title});
}
