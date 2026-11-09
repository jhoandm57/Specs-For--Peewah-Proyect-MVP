import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../models/event.dart';
import '../utils/date_formatters.dart';
import '../components/section_card.dart';
import '../components/status_badge.dart';
import '../components/recommendation_block_card.dart';
import '../components/suggested_date_card.dart';
import '../components/primary_button.dart';
import '../components/secondary_button.dart';

/// Página presentacional del resumen de confirmación del evento (F-06).
class ConfirmEventPage extends StatelessWidget {
  final Event event;
  final bool isSaving;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmEventPage({
    super.key,
    required this.event,
    required this.isSaving,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Resumen de configuración',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          StatusBadge(
                            label: event.status.label,
                            filled: event.status == EventStatus.configurado,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Revisa la configuración final antes de guardar el evento.',
                        style: TextStyle(
                          color: AppColors.gray600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SectionCard(
                        title: 'Características generales',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _InfoRow(label: 'Nombre', value: event.name),
                            _InfoRow(
                              label: 'Categoría',
                              value: event.category.label,
                            ),
                            _InfoRow(
                              label: 'Modalidad',
                              value: event.modality.label,
                            ),
                            _InfoRow(
                              label: 'Asistentes estimados',
                              value: '${event.estimatedAttendees}',
                            ),
                            _InfoRow(
                              label: 'Fecha del evento',
                              value: formatLongDate(event.date),
                            ),
                            if (event.baseEventName != null)
                              _InfoRow(
                                label: 'Basado en',
                                value: event.baseEventName!,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      SectionCard(
                        title: 'Bloques operativos decididos',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final block in event.recommendation.blocks)
                              RecommendationBlockCard(block: block),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      SectionCard(
                        title: 'Fechas de apertura y recordatorios',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var i = 0;
                                i < event.recommendation.dates.length;
                                i++)
                              SuggestedDateCard(
                                title: event.recommendation.dates[i].type ==
                                        SuggestedDateType.apertura
                                    ? 'Apertura de inscripciones'
                                    : 'Recordatorio $i',
                                date: event.recommendation.dates[i],
                                eventDate: event.date,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _ConfirmationBottomNav(
                isSaving: isSaving,
                onConfirm: onConfirm,
                onCancel: onCancel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.gray500,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmationBottomNav extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _ConfirmationBottomNav({
    required this.isSaving,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.gray200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SecondaryButton(
            buttonKey: const Key('cancel_confirmation_button'),
            onPressed: isSaving ? null : onCancel,
            label: 'Salir sin guardar',
          ),
          PrimaryButton(
            buttonKey: const Key('confirm_event_button'),
            onPressed: isSaving ? null : onConfirm,
            isLoading: isSaving,
            icon: Icons.check_circle_outline_rounded,
            label: 'Confirmar evento',
          ),
        ],
      ),
    );
  }
}
