import '../models/event.dart';
import 'mock_events.dart';

/// Resultado simulado de buscar sugerencias para el paso 2 (F-04).
class BlockSuggestions {
  final List<RecommendationBlock> blocks;

  /// Verdadero cuando no hubo eventos similares y se usó la configuración
  /// típica de la categoría (flujo alterno A1).
  final bool usesTypicalConfiguration;

  const BlockSuggestions({
    required this.blocks,
    required this.usesTypicalConfiguration,
  });
}

/// Arma los tres bloques sugeridos para un evento nuevo.
///
/// Un evento es similar si es de la misma organización, del mismo tipo y de
/// la misma modalidad. Si se eligió un evento base, se usa primero. Todos los
/// bloques arrancan con decisión pendiente.
BlockSuggestions suggestBlocks({
  required Event draft,
  required List<Event> history,
  Event? baseEvent,
}) {
  final similar =
      history
          .where(
            (event) =>
                event.id != draft.id &&
                event.organizationId == draft.organizationId &&
                event.category == draft.category &&
                event.modality == draft.modality,
          )
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  final sources = <Event>[
    if (baseEvent != null && baseEvent.organizationId == draft.organizationId)
      baseEvent,
    ...similar.where((event) => event.id != baseEvent?.id),
  ];

  final typical = typicalRecommendation(draft.category).blocks;

  if (sources.isEmpty) {
    return BlockSuggestions(
      blocks: [
        for (final block in typical) _pending(block.suggestedItems, block),
      ],
      usesTypicalConfiguration: true,
    );
  }

  final originNames = [for (final event in sources) event.name];

  return BlockSuggestions(
    blocks: [
      for (final type in RecommendationBlockType.values)
        _blockFromSources(type, sources, typical, originNames),
    ],
    usesTypicalConfiguration: false,
  );
}

RecommendationBlock _blockFromSources(
  RecommendationBlockType type,
  List<Event> sources,
  List<RecommendationBlock> typical,
  List<String> originNames,
) {
  // Se toma el contenido con el que quedó el evento más reciente que sí usó
  // ese bloque; si ninguno lo usó, se completa con la configuración típica.
  for (final event in sources) {
    for (final block in event.recommendation.blocks) {
      if (block.type == type && block.currentItems.isNotEmpty) {
        return RecommendationBlock(
          type: type,
          decision: RecommendationDecision.pendiente,
          suggestedItems: block.currentItems,
          originEvents: originNames,
        );
      }
    }
  }

  final fallback = typical.firstWhere((block) => block.type == type);
  return _pending(fallback.suggestedItems, fallback);
}

RecommendationBlock _pending(List<String> items, RecommendationBlock block) {
  return RecommendationBlock(
    type: block.type,
    decision: RecommendationDecision.pendiente,
    suggestedItems: items,
    originEvents: block.originEvents,
  );
}
