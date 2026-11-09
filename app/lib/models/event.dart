enum EventCategory { congreso, feria, seminario, taller }

extension EventCategoryX on EventCategory {
  String get label => switch (this) {
    EventCategory.congreso => 'Congreso',
    EventCategory.feria => 'Feria',
    EventCategory.seminario => 'Seminario',
    EventCategory.taller => 'Taller',
  };
}

enum EventModality { presencial, virtual, hibrida }

extension EventModalityX on EventModality {
  String get label => switch (this) {
    EventModality.presencial => 'Presencial',
    EventModality.virtual => 'Virtual',
    EventModality.hibrida => 'Híbrida',
  };
}

enum EventStatus { configurado, enConfiguracion }

extension EventStatusX on EventStatus {
  String get label => switch (this) {
    EventStatus.configurado => 'Configurado',
    EventStatus.enConfiguracion => 'En configuración',
  };
}

enum RecommendationDecision { pendiente, aceptado, editado, rechazado }

extension RecommendationDecisionX on RecommendationDecision {
  String get label => switch (this) {
    RecommendationDecision.pendiente => 'Pendiente',
    RecommendationDecision.aceptado => 'Aceptado',
    RecommendationDecision.editado => 'Editado',
    RecommendationDecision.rechazado => 'Rechazado',
  };
}

enum RecommendationBlockType { formulario, cronograma, tareas }

extension RecommendationBlockTypeX on RecommendationBlockType {
  String get label => switch (this) {
    RecommendationBlockType.formulario => 'Formulario de inscripción',
    RecommendationBlockType.cronograma => 'Cronograma de actividades',
    RecommendationBlockType.tareas => 'Tareas operativas',
  };
}

enum SuggestedDateType { apertura, recordatorio }

extension SuggestedDateTypeX on SuggestedDateType {
  String get label => switch (this) {
    SuggestedDateType.apertura => 'Apertura de inscripciones',
    SuggestedDateType.recordatorio => 'Recordatorio',
  };
}

class RegistrationField {
  final String name;
  final bool required;

  const RegistrationField({required this.name, required this.required});
}

class ScheduleActivity {
  final String name;
  final int dayRelative;
  final String time;

  const ScheduleActivity({
    required this.name,
    required this.dayRelative,
    required this.time,
  });
}

class EventTask {
  final String name;
  final String responsible;
  final int daysBeforeDue;

  const EventTask({
    required this.name,
    required this.responsible,
    required this.daysBeforeDue,
  });
}

class RecommendationBlock {
  final RecommendationBlockType type;
  final RecommendationDecision decision;
  final List<String> suggestedItems;
  final List<String> finalItems;
  final List<String> originEvents;

  const RecommendationBlock({
    required this.type,
    required this.decision,
    required this.suggestedItems,
    this.finalItems = const [],
    this.originEvents = const [],
  });

  /// El bloque queda aceptado con el contenido que sugirió el sistema.
  RecommendationBlock accept() => copyWith(
    decision: RecommendationDecision.aceptado,
    finalItems: suggestedItems,
  );

  /// El bloque queda editado; se conserva aparte lo que sugirió el sistema.
  RecommendationBlock edit(List<String> items) =>
      copyWith(decision: RecommendationDecision.editado, finalItems: items);

  /// El bloque queda vacío y marcado como rechazado.
  RecommendationBlock reject() => copyWith(
    decision: RecommendationDecision.rechazado,
    finalItems: const [],
  );

  /// Contenido con el que el bloque entra a la configuración del evento.
  List<String> get currentItems => switch (decision) {
    RecommendationDecision.editado => finalItems,
    RecommendationDecision.rechazado => const [],
    _ => suggestedItems,
  };

  RecommendationBlock copyWith({
    RecommendationDecision? decision,
    List<String>? suggestedItems,
    List<String>? finalItems,
    List<String>? originEvents,
  }) {
    return RecommendationBlock(
      type: type,
      decision: decision ?? this.decision,
      suggestedItems: suggestedItems ?? this.suggestedItems,
      finalItems: finalItems ?? this.finalItems,
      originEvents: originEvents ?? this.originEvents,
    );
  }
}

class SuggestedDate {
  final SuggestedDateType type;
  final int daysBeforeSuggested;
  final int? daysBeforeFinal;
  final RecommendationDecision decision;

  const SuggestedDate({
    required this.type,
    required this.daysBeforeSuggested,
    required this.daysBeforeFinal,
    required this.decision,
  });
}

class EventRecommendation {
  final List<RecommendationBlock> blocks;
  final List<SuggestedDate> dates;
  final bool simulated;

  const EventRecommendation({
    required this.blocks,
    required this.dates,
    this.simulated = true,
  });

  EventRecommendation copyWith({
    List<RecommendationBlock>? blocks,
    List<SuggestedDate>? dates,
  }) {
    return EventRecommendation(
      blocks: blocks ?? this.blocks,
      dates: dates ?? this.dates,
      simulated: simulated,
    );
  }
}

class Event {
  final String id;
  final String organizationId;
  final String name;
  final EventCategory category;
  final EventModality modality;
  final int estimatedAttendees;
  final int registrations;
  final DateTime date;
  final EventStatus status;
  final String? baseEventName;
  final List<RegistrationField> registrationFields;
  final List<ScheduleActivity> schedule;
  final List<EventTask> tasks;
  final EventRecommendation recommendation;

  const Event({
    required this.id,
    required this.organizationId,
    required this.name,
    required this.category,
    required this.modality,
    required this.estimatedAttendees,
    this.registrations = 0,
    required this.date,
    required this.status,
    required this.registrationFields,
    required this.schedule,
    required this.tasks,
    required this.recommendation,
    this.baseEventName,
  });

  Event copyWith({
    List<RegistrationField>? registrationFields,
    List<ScheduleActivity>? schedule,
    List<EventTask>? tasks,
    EventRecommendation? recommendation,
  }) {
    return Event(
      id: id,
      organizationId: organizationId,
      name: name,
      category: category,
      modality: modality,
      estimatedAttendees: estimatedAttendees,
      registrations: registrations,
      date: date,
      status: status,
      baseEventName: baseEventName,
      registrationFields: registrationFields ?? this.registrationFields,
      schedule: schedule ?? this.schedule,
      tasks: tasks ?? this.tasks,
      recommendation: recommendation ?? this.recommendation,
    );
  }
}
