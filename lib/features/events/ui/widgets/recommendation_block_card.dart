import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/event.dart';
import 'status_badge.dart';

/// Tarjeta de un bloque sugerido (formulario, cronograma o tareas).
///
/// Sin callbacks solo muestra el bloque, como en el detalle del evento (F-07).
/// Con callbacks muestra además las acciones del paso 2 (F-04).
class RecommendationBlockCard extends StatelessWidget {
  final RecommendationBlock block;
  final VoidCallback? onAccept;
  final VoidCallback? onEdit;
  final VoidCallback? onReject;

  const RecommendationBlockCard({
    super.key,
    required this.block,
    this.onAccept,
    this.onEdit,
    this.onReject,
  });

  bool get _hasActions =>
      onAccept != null || onEdit != null || onReject != null;

  @override
  Widget build(BuildContext context) {
    final decision = block.decision;
    final isEdited = decision == RecommendationDecision.editado;
    final isRejected = decision == RecommendationDecision.rechazado;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(12),
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
                  block.type.label,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              StatusBadge(
                key: ValueKey('decision_${block.type.name}'),
                label: decision.label,
                filled: decision == RecommendationDecision.aceptado,
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (isRejected)
            const _MutedText(
              'Bloque rechazado. No se incluye en la configuración final.',
            )
          else if (isEdited) ...[
            const _MiniLabel('Contenido sugerido'),
            const SizedBox(height: 4),
            BulletList(items: block.suggestedItems),
            const SizedBox(height: 8),
            const _MiniLabel('Contenido final'),
            const SizedBox(height: 4),
            BulletList(items: block.finalItems),
          ] else
            BulletList(items: block.suggestedItems),
          if (block.originEvents.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Basado en: ${block.originEvents.join(', ')}',
              style: const TextStyle(
                color: AppColors.gray500,
                fontSize: 10.5,
                height: 1.35,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          if (_hasActions) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _DecisionButton(
                  key: Key('accept_${block.type.name}'),
                  label: 'Aceptar',
                  icon: Icons.check_rounded,
                  selected: decision == RecommendationDecision.aceptado,
                  onPressed: onAccept,
                ),
                _DecisionButton(
                  key: Key('edit_${block.type.name}'),
                  label: 'Editar',
                  icon: Icons.edit_outlined,
                  selected: isEdited,
                  onPressed: onEdit,
                ),
                _DecisionButton(
                  key: Key('reject_${block.type.name}'),
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

/// Lista con viñetas para el contenido de un bloque.
class BulletList extends StatelessWidget {
  final List<String> items;

  const BulletList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const _MutedText('Sin contenido registrado.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Icon(Icons.circle, size: 4, color: AppColors.gray500),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: AppColors.gray600,
                      fontSize: 11.5,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
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
    final foreground = selected ? AppColors.white : AppColors.black;

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: foreground),
      label: Text(label, style: TextStyle(color: foreground)),
      style: OutlinedButton.styleFrom(
        foregroundColor: foreground,
        backgroundColor: selected ? AppColors.black : AppColors.white,
        side: BorderSide(
          color: selected ? AppColors.black : AppColors.gray300,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: const Size(0, 36),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _MiniLabel extends StatelessWidget {
  final String text;

  const _MiniLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: AppColors.gray500,
        fontSize: 9.5,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.6,
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
