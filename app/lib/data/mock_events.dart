import 'mock_users.dart';
import '../models/event.dart';

const defaultRegistrationFields = <RegistrationField>[
  RegistrationField(name: 'Nombre completo', required: true),
  RegistrationField(name: 'Correo electrónico', required: true),
  RegistrationField(name: 'Institución', required: false),
  RegistrationField(name: 'Cargo', required: false),
];

const defaultSchedule = <ScheduleActivity>[
  ScheduleActivity(
    name: 'Registro y acreditación',
    dayRelative: 0,
    time: '08:00',
  ),
  ScheduleActivity(name: 'Apertura del evento', dayRelative: 0, time: '09:00'),
  ScheduleActivity(
    name: 'Conferencia principal',
    dayRelative: 0,
    time: '10:00',
  ),
  ScheduleActivity(name: 'Almuerzo', dayRelative: 0, time: '12:30'),
  ScheduleActivity(name: 'Talleres paralelos', dayRelative: 0, time: '14:00'),
  ScheduleActivity(name: 'Cierre', dayRelative: 0, time: '17:00'),
];

const defaultTasks = <EventTask>[
  EventTask(
    name: 'Confirmar conferencistas',
    responsible: 'Sofía Gómez',
    daysBeforeDue: 30,
  ),
  EventTask(
    name: 'Publicar agenda',
    responsible: 'Carlos Pérez',
    daysBeforeDue: 21,
  ),
  EventTask(
    name: 'Abrir inscripciones',
    responsible: 'Sofía Gómez',
    daysBeforeDue: 30,
  ),
  EventTask(
    name: 'Enviar recordatorio',
    responsible: 'Carlos Pérez',
    daysBeforeDue: 7,
  ),
  EventTask(
    name: 'Preparar materiales',
    responsible: 'Equipo de logística',
    daysBeforeDue: 5,
  ),
];

final mockEvents = <Event>[
  Event(
    id: 'evt-congreso-2025',
    organizationId: mockOrganizationId,
    name: 'Congreso Internacional de Tecnología 2025',
    category: EventCategory.congreso,
    modality: EventModality.hibrida,
    estimatedAttendees: 450,
    registrations: 412,
    date: DateTime(2025, 10, 15),
    status: EventStatus.configurado,
    registrationFields: const [
      RegistrationField(name: 'Nombre completo', required: true),
      RegistrationField(name: 'Correo electrónico', required: true),
      RegistrationField(name: 'Institución', required: false),
      RegistrationField(name: 'Cargo', required: false),
      RegistrationField(name: 'Talla de camiseta', required: false),
    ],
    schedule: const [
      ScheduleActivity(
        name: 'Registro y acreditación',
        dayRelative: 0,
        time: '08:00',
      ),
      ScheduleActivity(name: 'Apertura', dayRelative: 0, time: '09:00'),
      ScheduleActivity(
        name: 'Conferencia principal',
        dayRelative: 0,
        time: '10:00',
      ),
      ScheduleActivity(name: 'Almuerzo', dayRelative: 0, time: '12:30'),
      ScheduleActivity(
        name: 'Talleres paralelos',
        dayRelative: 0,
        time: '14:00',
      ),
      ScheduleActivity(name: 'Cierre', dayRelative: 0, time: '17:00'),
    ],
    tasks: const [
      EventTask(
        name: 'Confirmar conferencistas',
        responsible: 'Sofía Gómez',
        daysBeforeDue: 30,
      ),
      EventTask(
        name: 'Publicar agenda',
        responsible: 'Carlos Pérez',
        daysBeforeDue: 21,
      ),
      EventTask(
        name: 'Abrir inscripciones',
        responsible: 'Sofía Gómez',
        daysBeforeDue: 30,
      ),
      EventTask(
        name: 'Enviar recordatorio',
        responsible: 'Carlos Pérez',
        daysBeforeDue: 7,
      ),
      EventTask(
        name: 'Preparar materiales',
        responsible: 'Equipo de logística',
        daysBeforeDue: 5,
      ),
    ],
    recommendation: const EventRecommendation(
      blocks: [
        RecommendationBlock(
          type: RecommendationBlockType.formulario,
          decision: RecommendationDecision.aceptado,
          suggestedItems: [
            'Nombre completo (obligatorio)',
            'Correo electrónico (obligatorio)',
            'Institución (opcional)',
            'Cargo (opcional)',
            'Talla de camiseta (opcional)',
          ],
          originEvents: [
            'Congreso Tecnología 2024',
            'Congreso Tecnología 2023',
          ],
        ),
        RecommendationBlock(
          type: RecommendationBlockType.cronograma,
          decision: RecommendationDecision.editado,
          suggestedItems: [
            'Registro, apertura y conferencia principal',
            'Almuerzo y talleres paralelos',
            'Cierre del evento',
          ],
          finalItems: [
            'Se agregó un taller de IA generativa',
            'Se movió el almuerzo a las 12:30',
            'Se mantuvo el cierre a las 17:00',
          ],
          originEvents: [
            'Congreso Tecnología 2024',
            'Congreso Tecnología 2023',
          ],
        ),
        RecommendationBlock(
          type: RecommendationBlockType.tareas,
          decision: RecommendationDecision.aceptado,
          suggestedItems: [
            '5 tareas con responsables',
            'Confirmación de conferencistas 30 días antes',
            'Recordatorio a inscritos 7 días antes',
          ],
          originEvents: ['Congreso Tecnología 2024'],
        ),
      ],
      dates: [
        SuggestedDate(
          type: SuggestedDateType.apertura,
          daysBeforeSuggested: 30,
          daysBeforeFinal: 30,
          decision: RecommendationDecision.aceptado,
        ),
        SuggestedDate(
          type: SuggestedDateType.recordatorio,
          daysBeforeSuggested: 14,
          daysBeforeFinal: 14,
          decision: RecommendationDecision.aceptado,
        ),
        SuggestedDate(
          type: SuggestedDateType.recordatorio,
          daysBeforeSuggested: 7,
          daysBeforeFinal: 7,
          decision: RecommendationDecision.aceptado,
        ),
        SuggestedDate(
          type: SuggestedDateType.recordatorio,
          daysBeforeSuggested: 1,
          daysBeforeFinal: null,
          decision: RecommendationDecision.rechazado,
        ),
      ],
    ),
  ),
  Event(
    id: 'evt-feria-2025',
    organizationId: mockOrganizationId,
    name: 'Feria Universitaria de Innovación',
    category: EventCategory.feria,
    modality: EventModality.presencial,
    estimatedAttendees: 300,
    registrations: 274,
    date: DateTime(2025, 8, 20),
    status: EventStatus.configurado,
    registrationFields: const [
      RegistrationField(name: 'Nombre completo', required: true),
      RegistrationField(name: 'Correo electrónico', required: true),
      RegistrationField(name: 'Universidad', required: true),
      RegistrationField(name: 'Programa académico', required: false),
      RegistrationField(name: '¿Requieres almuerzo?', required: false),
    ],
    schedule: const [
      ScheduleActivity(
        name: 'Montaje de stands',
        dayRelative: -1,
        time: '16:00',
      ),
      ScheduleActivity(name: 'Apertura', dayRelative: 0, time: '09:00'),
      ScheduleActivity(
        name: 'Recorrido de stands',
        dayRelative: 0,
        time: '10:00',
      ),
      ScheduleActivity(name: 'Conversatorio', dayRelative: 0, time: '11:30'),
      ScheduleActivity(name: 'Almuerzo', dayRelative: 0, time: '13:00'),
      ScheduleActivity(name: 'Premiación', dayRelative: 0, time: '16:00'),
    ],
    tasks: const [
      EventTask(
        name: 'Confirmar expositores',
        responsible: 'Sofía Gómez',
        daysBeforeDue: 30,
      ),
      EventTask(
        name: 'Diseñar mapa de stands',
        responsible: 'Carlos Pérez',
        daysBeforeDue: 20,
      ),
      EventTask(
        name: 'Publicar convocatoria',
        responsible: 'Sofía Gómez',
        daysBeforeDue: 40,
      ),
      EventTask(
        name: 'Enviar recordatorio',
        responsible: 'Carlos Pérez',
        daysBeforeDue: 5,
      ),
    ],
    recommendation: const EventRecommendation(
      blocks: [
        RecommendationBlock(
          type: RecommendationBlockType.formulario,
          decision: RecommendationDecision.editado,
          suggestedItems: [
            'Nombre completo (obligatorio)',
            'Correo electrónico (obligatorio)',
            'Universidad (obligatorio)',
          ],
          finalItems: [
            'Se agregó el campo Programa académico',
            'Se agregó la pregunta ¿Requieres almuerzo?',
          ],
          originEvents: ['Feria de Innovación 2024'],
        ),
        RecommendationBlock(
          type: RecommendationBlockType.cronograma,
          decision: RecommendationDecision.aceptado,
          suggestedItems: [
            'Montaje de stands el día anterior',
            'Recorrido, conversatorio y premiación',
            'Almuerzo a la 1:00 p. m.',
          ],
          originEvents: ['Feria de Innovación 2024'],
        ),
        RecommendationBlock(
          type: RecommendationBlockType.tareas,
          decision: RecommendationDecision.rechazado,
          suggestedItems: ['4 tareas operativas con responsables'],
          originEvents: ['Feria de Innovación 2024'],
        ),
      ],
      dates: [
        SuggestedDate(
          type: SuggestedDateType.apertura,
          daysBeforeSuggested: 45,
          daysBeforeFinal: 45,
          decision: RecommendationDecision.aceptado,
        ),
        SuggestedDate(
          type: SuggestedDateType.recordatorio,
          daysBeforeSuggested: 10,
          daysBeforeFinal: 10,
          decision: RecommendationDecision.aceptado,
        ),
        SuggestedDate(
          type: SuggestedDateType.recordatorio,
          daysBeforeSuggested: 3,
          daysBeforeFinal: null,
          decision: RecommendationDecision.rechazado,
        ),
      ],
    ),
  ),
  Event(
    id: 'evt-seminario-2025',
    organizationId: mockOrganizationId,
    name: 'Seminario de Inteligencia Artificial',
    category: EventCategory.seminario,
    modality: EventModality.virtual,
    estimatedAttendees: 200,
    registrations: 181,
    date: DateTime(2025, 5, 10),
    status: EventStatus.configurado,
    registrationFields: const [
      RegistrationField(name: 'Nombre completo', required: true),
      RegistrationField(name: 'Correo electrónico', required: true),
      RegistrationField(name: 'Empresa', required: false),
      RegistrationField(name: 'Área de trabajo', required: false),
      RegistrationField(name: 'Años de experiencia', required: false),
    ],
    schedule: const [
      ScheduleActivity(
        name: 'Registro en línea',
        dayRelative: 0,
        time: '08:30',
      ),
      ScheduleActivity(
        name: 'Charla de apertura',
        dayRelative: 0,
        time: '09:00',
      ),
      ScheduleActivity(name: 'Taller práctico', dayRelative: 0, time: '11:00'),
      ScheduleActivity(
        name: 'Panel de expertos',
        dayRelative: 0,
        time: '15:00',
      ),
      ScheduleActivity(name: 'Cierre', dayRelative: 0, time: '17:00'),
    ],
    tasks: const [
      EventTask(
        name: 'Confirmar ponentes',
        responsible: 'Sofía Gómez',
        daysBeforeDue: 21,
      ),
      EventTask(
        name: 'Preparar certificados',
        responsible: 'Carlos Pérez',
        daysBeforeDue: 7,
      ),
      EventTask(
        name: 'Publicar grabaciones',
        responsible: 'Sofía Gómez',
        daysBeforeDue: 3,
      ),
    ],
    recommendation: const EventRecommendation(
      blocks: [
        RecommendationBlock(
          type: RecommendationBlockType.formulario,
          decision: RecommendationDecision.aceptado,
          suggestedItems: [
            'Nombre completo (obligatorio)',
            'Correo electrónico (obligatorio)',
            'Empresa y área de trabajo (opcionales)',
          ],
          originEvents: ['Seminario IA 2024', 'Seminario IA 2023'],
        ),
        RecommendationBlock(
          type: RecommendationBlockType.cronograma,
          decision: RecommendationDecision.aceptado,
          suggestedItems: [
            'Charla de apertura y taller práctico',
            'Panel de expertos en la tarde',
          ],
          originEvents: ['Seminario IA 2024'],
        ),
        RecommendationBlock(
          type: RecommendationBlockType.tareas,
          decision: RecommendationDecision.editado,
          suggestedItems: [
            '3 tareas con responsables',
            'Confirmar ponentes 21 días antes',
          ],
          finalItems: [
            'Se agregó la tarea de publicar grabaciones',
            'Se ajustó la preparación de certificados a 7 días',
          ],
          originEvents: ['Seminario IA 2024', 'Seminario IA 2023'],
        ),
      ],
      dates: [
        SuggestedDate(
          type: SuggestedDateType.apertura,
          daysBeforeSuggested: 30,
          daysBeforeFinal: 21,
          decision: RecommendationDecision.editado,
        ),
        SuggestedDate(
          type: SuggestedDateType.recordatorio,
          daysBeforeSuggested: 7,
          daysBeforeFinal: 7,
          decision: RecommendationDecision.aceptado,
        ),
        SuggestedDate(
          type: SuggestedDateType.recordatorio,
          daysBeforeSuggested: 1,
          daysBeforeFinal: 1,
          decision: RecommendationDecision.aceptado,
        ),
      ],
    ),
  ),
];

EventRecommendation typicalRecommendation(EventCategory category) {
  final origin = 'Configuración típica de ${category.label.toLowerCase()}';
  return EventRecommendation(
    blocks: [
      RecommendationBlock(
        type: RecommendationBlockType.formulario,
        decision: RecommendationDecision.aceptado,
        suggestedItems: const [
          'Nombre completo (obligatorio)',
          'Correo electrónico (obligatorio)',
          'Institución (opcional)',
          'Cargo (opcional)',
        ],
        originEvents: [origin],
      ),
      RecommendationBlock(
        type: RecommendationBlockType.cronograma,
        decision: RecommendationDecision.aceptado,
        suggestedItems: const [
          'Registro y apertura',
          'Conferencia principal',
          'Almuerzo y actividades de la tarde',
          'Cierre',
        ],
        originEvents: [origin],
      ),
      RecommendationBlock(
        type: RecommendationBlockType.tareas,
        decision: RecommendationDecision.aceptado,
        suggestedItems: const [
          'Confirmar conferencistas',
          'Publicar agenda',
          'Abrir inscripciones',
          'Enviar recordatorios',
        ],
        originEvents: [origin],
      ),
    ],
    dates: const [
      SuggestedDate(
        type: SuggestedDateType.apertura,
        daysBeforeSuggested: 30,
        daysBeforeFinal: 30,
        decision: RecommendationDecision.aceptado,
      ),
      SuggestedDate(
        type: SuggestedDateType.recordatorio,
        daysBeforeSuggested: 14,
        daysBeforeFinal: 14,
        decision: RecommendationDecision.aceptado,
      ),
      SuggestedDate(
        type: SuggestedDateType.recordatorio,
        daysBeforeSuggested: 7,
        daysBeforeFinal: 7,
        decision: RecommendationDecision.aceptado,
      ),
      SuggestedDate(
        type: SuggestedDateType.recordatorio,
        daysBeforeSuggested: 1,
        daysBeforeFinal: 1,
        decision: RecommendationDecision.aceptado,
      ),
    ],
  );
}

Event buildMockEventFromForm({
  required String name,
  required EventCategory? category,
  required EventModality? modality,
  required String attendees,
  required DateTime? date,
  Event? baseEvent,
}) {
  final resolvedCategory =
      category ?? baseEvent?.category ?? EventCategory.congreso;
  final resolvedModality =
      modality ?? baseEvent?.modality ?? EventModality.presencial;
  final parsedAttendees =
      int.tryParse(attendees) ?? baseEvent?.estimatedAttendees ?? 100;

  return Event(
    id: 'evt-${DateTime.now().millisecondsSinceEpoch}',
    organizationId: mockOrganizationId,
    name: name.trim().isEmpty ? 'Nuevo evento sin título' : name.trim(),
    category: resolvedCategory,
    modality: resolvedModality,
    estimatedAttendees: parsedAttendees,
    date: date ?? DateTime.now().add(const Duration(days: 30)),
    status: EventStatus.configurado,
    baseEventName: baseEvent?.name,
    registrationFields:
        baseEvent?.registrationFields ?? defaultRegistrationFields,
    schedule: baseEvent?.schedule ?? defaultSchedule,
    tasks: baseEvent?.tasks ?? defaultTasks,
    recommendation:
        baseEvent?.recommendation ?? typicalRecommendation(resolvedCategory),
  );
}
