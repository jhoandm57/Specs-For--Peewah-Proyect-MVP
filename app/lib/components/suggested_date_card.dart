import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../models/event.dart';
import '../utils/date_formatters.dart';
import 'status_badge.dart';

/// Tarjeta reutilizable para mostrar y gestionar una fecha sugerida
/// (apertura de inscripciones o recordatorio).
///
/// Se utiliza en el paso 3 (F-05) con acciones y en la consulta de evento (F-07)
/// en modo solo lectura.
class SuggestedDateCard extends StatelessWidget {
  final String title;
  final SuggestedDate date;
  final DateTime eventDate;
  final VoidCallback? onAccept;
  final VoidCallback? onEdit;
  final VoidCallback? onReject;
  final String? actionKeyPrefix;
  final Widget? customContent;

  const SuggestedDateCard({
    super.key,
    required this.title,
    required this.date,
    required this.eventDate,
    this.onAccept,
    this.onEdit,
    this.onReject,
    this.actionKeyPrefix,
    this.customContent,
  });

  bool get _hasActions =>
      onAccept != null || onEdit != null || onReject != null;

  @override
  Widget build(BuildContext context) {
    final decision = date.decision;
    final isEdited = decision == RecommendationDecision.editado;
    final isRejected = decision == RecommendationDecision.rechazado;

    final suggestedDateTime = dateFromDaysBefore(
      eventDate,
      date.daysBeforeSuggested,
    );
    final finalDateTime = date.daysBeforeFinal == null
        ? null
        : dateFromDaysBefore(eventDate, date.daysBeforeFinal!);

    final isOpening = date.type == SuggestedDateType.apertura;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRejected
              ? AppColors.gray300
              : (isEdited ? AppColors.black : AppColors.gray200),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              StatusBadge(
                key: actionKeyPrefix != null
                    ? ValueKey('decision_$actionKeyPrefix')
                    : null,
                label: decision.label,
                filled: decision == RecommendationDecision.aceptado,
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (isRejected) ...[
            if (isOpening)
              const Text(
                'Apertura sugerida rechazada. Debes definir una fecha propia.',
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              )
            else
              const Text(
                'Recordatorio rechazado. No se enviará a los inscritos.',
                style: TextStyle(
                  color: AppColors.gray500,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ] else if (isEdited && finalDateTime != null) ...[
            Text(
              'Sugerido: ${formatLongDate(suggestedDateTime)} (${formatDaysBefore(date.daysBeforeSuggested)})',
              style: const TextStyle(
                color: AppColors.gray500,
                fontSize: 12,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Fecha final: ${formatLongDate(finalDateTime)} (${formatDaysBefore(date.daysBeforeFinal!)})',
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ] else ...[
            Text(
              isOpening
                  ? 'Abrir inscripciones: ${formatLongDate(suggestedDateTime)} (${formatDaysBefore(date.daysBeforeSuggested)})'
                  : '${formatDaysBefore(date.daysBeforeSuggested)}: ${formatLongDate(suggestedDateTime)}',
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          if (customContent != null) ...[
            const SizedBox(height: 10),
            customContent!,
          ],
          if (_hasActions) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _DecisionButton(
                  key: actionKeyPrefix != null
                      ? Key('accept_$actionKeyPrefix')
                      : null,
                  label: 'Aceptar',
                  icon: Icons.check_rounded,
                  selected: decision == RecommendationDecision.aceptado,
                  onPressed: onAccept,
                ),
                _DecisionButton(
                  key: actionKeyPrefix != null
                      ? Key('edit_$actionKeyPrefix')
                      : null,
                  label: 'Editar',
                  icon: Icons.edit_outlined,
                  selected: isEdited,
                  onPressed: onEdit,
                ),
                _DecisionButton(
                  key: actionKeyPrefix != null
                      ? Key('reject_$actionKeyPrefix')
                      : null,
                  label: 'Rechazar',
                  icon: Icons.close_rounded,
                  selected: isRejected,
                  onPressed: onReject,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DecisionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onPressed;

  const _DecisionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 15),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: selected ? AppColors.white : AppColors.black,
        backgroundColor: selected ? AppColors.black : AppColors.white,
        side: BorderSide(color: selected ? AppColors.black : AppColors.gray300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        minimumSize: const Size(0, 34),
        textStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
      ),
    );
  }
}
