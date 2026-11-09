import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../models/event.dart';
import '../components/section_card.dart';
import '../components/step_indicator.dart';
import '../components/suggested_date_card.dart';

/// Página presentacional del paso 3 del flujo guiado (F-05).
/// Solo recibe datos y emite eventos hacia la screen anfitriona.
class TemporalityPage extends StatelessWidget {
  final String eventName;
  final String categoryLabel;
  final DateTime eventDate;
  final bool loading;
  final bool usesTypicalCurve;
  final bool openingAdjustedToToday;
  final SuggestedDate? openingDate;
  final List<SuggestedDate> reminders;
  final String? openingError;
  final String? reminderError;
  final VoidCallback onAcceptOpening;
  final VoidCallback onEditOpening;
  final VoidCallback onRejectOpening;
  final ValueChanged<int> onAcceptReminder;
  final ValueChanged<int> onEditReminder;
  final ValueChanged<int> onRejectReminder;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const TemporalityPage({
    super.key,
    required this.eventName,
    required this.categoryLabel,
    required this.eventDate,
    required this.loading,
    required this.usesTypicalCurve,
    required this.openingAdjustedToToday,
    required this.openingDate,
    required this.reminders,
    this.openingError,
    this.reminderError,
    required this.onAcceptOpening,
    required this.onEditOpening,
    required this.onRejectOpening,
    required this.onAcceptReminder,
    required this.onEditReminder,
    required this.onRejectReminder,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
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
                      const StepIndicator(
                        currentStep: 3,
                        labels: [
                          'Características',
                          'Bloques sugeridos',
                          'Fechas sugeridas',
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        eventName,
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Paso 3 · Revisa las fechas sugeridas para $categoryLabel',
                        style: const TextStyle(
                          color: AppColors.gray600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (usesTypicalCurve) ...[
                        Container(
                          key: const Key('typical_curve_banner'),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.gray100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.gray200),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.auto_graph_rounded,
                                size: 18,
                                color: AppColors.black,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Fechas basadas en la curva típica de un $categoryLabel',
                                  style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (openingAdjustedToToday) ...[
                        Container(
                          key: const Key('opening_adjusted_banner'),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF9E6),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFFFD566)),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                size: 18,
                                color: Color(0xFFB78103),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'La apertura sugerida caía antes de hoy; se sugiere abrir hoy.',
                                  style: TextStyle(
                                    color: Color(0xFF6B4B02),
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (loading) ...[
                        const SizedBox(height: 40),
                        const Center(
                          child: Column(
                            children: [
                              CircularProgressIndicator(strokeWidth: 2),
                              SizedBox(height: 14),
                              Text(
                                'Calculando fechas…',
                                style: TextStyle(
                                  color: AppColors.gray600,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        SectionCard(
                          title: 'Apertura de inscripciones',
                          subtitle:
                              'Define cuándo empezarán las personas a inscribirse a tu evento.',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (openingDate != null)
                                SuggestedDateCard(
                                  title: 'Apertura de inscripciones',
                                  date: openingDate!,
                                  eventDate: eventDate,
                                  actionKeyPrefix: 'apertura',
                                  onAccept: onAcceptOpening,
                                  onEdit: onEditOpening,
                                  onReject: onRejectOpening,
                                ),
                              if (openingError != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    openingError!,
                                    key: const Key('opening_error_text'),
                                    style: const TextStyle(
                                      color: AppColors.error,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SectionCard(
                          title: 'Recordatorios sugeridos',
                          subtitle:
                              'Programación de avisos previos a los inscritos.',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (reminders.isEmpty)
                                const Text(
                                  'No hay recordatorios sugeridos.',
                                  style: TextStyle(
                                    color: AppColors.gray500,
                                    fontSize: 12,
                                  ),
                                )
                              else
                                for (var i = 0; i < reminders.length; i++)
                                  SuggestedDateCard(
                                    title: 'Recordatorio ${i + 1}',
                                    date: reminders[i],
                                    eventDate: eventDate,
                                    actionKeyPrefix: 'recordatorio_$i',
                                    onAccept: () => onAcceptReminder(i),
                                    onEdit: () => onEditReminder(i),
                                    onReject: () => onRejectReminder(i),
                                  ),
                              if (reminderError != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    reminderError!,
                                    key: const Key('reminder_error_text'),
                                    style: const TextStyle(
                                      color: AppColors.error,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              _BottomNav(
                onBack: onBack,
                onNext: loading ? null : onNext,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback? onNext;

  const _BottomNav({
    required this.onBack,
    required this.onNext,
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
          OutlinedButton.icon(
            key: const Key('temporality_back_button'),
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded, size: 16),
            label: const Text('Atrás'),
          ),
          ElevatedButton.icon(
            key: const Key('temporality_next_button'),
            onPressed: onNext,
            icon: const Icon(Icons.arrow_forward_rounded, size: 16),
            label: const Text('Siguiente'),
          ),
        ],
      ),
    );
  }
}
