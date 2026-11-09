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

/// Resultado simulado de calcular fechas sugeridas para el paso 3 (F-05).
class DateSuggestions {
  final List<SuggestedDate> dates;
  final bool usesTypicalCurve;
  final bool openingAdjustedToToday;

  const DateSuggestions({
    required this.dates,
    required this.usesTypicalCurve,
    this.openingAdjustedToToday = false,
  });
}

/// Sugiere la fecha de apertura de inscripciones y los recordatorios para un nuevo evento (F-05).
DateSuggestions suggestDates({
  required Event draft,
  required List<Event> history,
  Event? baseEvent,
  DateTime? now,
}) {
  final currentDate = now ?? DateTime.now();
  final today = DateTime(currentDate.year, currentDate.month, currentDate.day);
  final eventDay = DateTime(draft.date.year, draft.date.month, draft.date.day);

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

  final bool usesTypicalCurve = sources.isEmpty;
  final List<SuggestedDate> sourceDates = usesTypicalCurve
      ? typicalRecommendation(draft.category).dates
      : sources.first.recommendation.dates;

  var openingAdjusted = false;
  final dates = <SuggestedDate>[];

  for (final date in sourceDates) {
    if (date.type == SuggestedDateType.apertura) {
      final days = date.daysBeforeSuggested;
      final openingDate = eventDay.subtract(Duration(days: days));

      if (openingDate.isBefore(today)) {
        final daysFromToday = eventDay.difference(today).inDays;
        final adjustedDays = daysFromToday > 0 ? daysFromToday : 0;
        dates.add(
          SuggestedDate(
            type: SuggestedDateType.apertura,
            daysBeforeSuggested: adjustedDays,
            daysBeforeFinal: null,
            decision: RecommendationDecision.pendiente,
          ),
        );
        openingAdjusted = true;
      } else {
        dates.add(
          SuggestedDate(
            type: SuggestedDateType.apertura,
            daysBeforeSuggested: days,
            daysBeforeFinal: null,
            decision: RecommendationDecision.pendiente,
          ),
        );
      }
    } else {
      dates.add(
        SuggestedDate(
          type: SuggestedDateType.recordatorio,
          daysBeforeSuggested: date.daysBeforeSuggested,
          daysBeforeFinal: null,
          decision: RecommendationDecision.pendiente,
        ),
      );
    }
  }

  return DateSuggestions(
    dates: dates,
    usesTypicalCurve: usesTypicalCurve,
    openingAdjustedToToday: openingAdjusted,
  );
}
