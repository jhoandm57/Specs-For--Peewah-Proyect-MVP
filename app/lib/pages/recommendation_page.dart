import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../models/event.dart';
import '../components/recommendation_block_card.dart';
import '../components/section_card.dart';
import '../components/step_indicator.dart';
import '../components/primary_button.dart';
import '../components/secondary_button.dart';

/// Paso 2 del asistente (F-04): muestra los bloques sugeridos y reporta las
/// decisiones a la Screen. No guarda datos por su cuenta.
class RecommendationPage extends StatelessWidget {
  final String eventName;
  final String categoryLabel;
  final bool loading;
  final bool usesTypicalConfiguration;
  final bool showMissingDecisions;
  final List<RecommendationBlock> blocks;
  final ValueChanged<RecommendationBlockType> onAccept;
  final ValueChanged<RecommendationBlockType> onEdit;
  final ValueChanged<RecommendationBlockType> onReject;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const RecommendationPage({
    super.key,
    required this.eventName,
    required this.categoryLabel,
    required this.loading,
    required this.usesTypicalConfiguration,
    required this.showMissingDecisions,
    required this.blocks,
    required this.onAccept,
    required this.onEdit,
    required this.onReject,
    required this.onBack,
    required this.onNext,
  });

  int get _decidedCount => blocks
      .where((block) => block.decision != RecommendationDecision.pendiente)
      .length;

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
                  currentStep: 2,
                  labels: [
                    'Características',
                    'Bloques sugeridos',
                    'Fechas sugeridas',
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Revisa los bloques sugeridos',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Decide qué haces con cada bloque de "$eventName": '
                  'acéptalo, edítalo o recházalo.',
                  style: const TextStyle(
                    color: AppColors.gray600,
                    fontSize: 13.5,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),
                if (loading)
                  const _LoadingState()
                else ...[
                  if (usesTypicalConfiguration) ...[
                    _Notice(
                      key: const Key('typical_configuration_notice'),
                      text:
                          'Tu organización no tiene eventos similares; esta es '
                          'la configuración típica de un '
                          '${categoryLabel.toLowerCase()}.',
                    ),
                    const SizedBox(height: 16),
                  ],
                  SectionCard(
                    icon: Icons.auto_awesome_outlined,
                    title: 'Bloques sugeridos',
                    subtitle:
                        '$_decidedCount de ${blocks.length} bloques '
                        'con decisión.',
                    child: Column(
                      children: [
                        for (final block in blocks)
                          RecommendationBlockCard(
                            block: block,
                            onAccept: () => onAccept(block.type),
                            onEdit: () => onEdit(block.type),
                            onReject: () => onReject(block.type),
                          ),
                      ],
                    ),
                  ),
                ],
                if (showMissingDecisions) ...[
                  const SizedBox(height: 14),
                  const Text(
                    'Decide qué haces con los tres bloques',
                    key: Key('missing_decisions_message'),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xFFB91C1C),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    SecondaryButton(
                      buttonKey: const Key('recommendation_back_button'),
                      onPressed: onBack,
                      label: 'Atrás',
                    ),
                    PrimaryButton(
                      buttonKey: const Key('recommendation_next_button'),
                      onPressed: loading ? null : onNext,
                      icon: Icons.arrow_forward_rounded,
                      label: 'Siguiente',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Buscando eventos similares…',
              style: TextStyle(color: AppColors.gray600, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  final String text;

  const _Notice({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.gray800,
                fontSize: 12.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
